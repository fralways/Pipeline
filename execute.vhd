library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity execute is

port
(
	clk : in std_logic;
	reset : in std_logic;
	PC : in std_logic_vector(31 downto 0);
	PC_plus : in std_logic_vector(31 downto 0);
	RS1 : in std_logic_vector(31 downto 0);
	RS2 : in std_logic_vector(31 downto 0);
	RD : in std_logic_vector(4 downto 0);
	IMM : in std_logic_vector(31 downto 0);
	fwd_MEM_A : in std_logic;
	fwd_MEM_B : in std_logic;
	fwd_WB_A : in std_logic;
	fwd_WB_B : in std_logic;
	forward_A_MEM : in std_logic_vector(31 downto 0);
	forward_B_MEM : in std_logic_vector(31 downto 0);
	forward_A_WB : in std_logic_vector(31 downto 0);
	forward_B_WB : in std_logic_vector(31 downto 0);
	
	dstvalid_EX : in std_logic;
	dstvalid_MEM : in std_logic;
	RS_IMM_type : in std_logic;
	MOV_type : in std_logic;
	JMP_type : in std_logic;
	COND_type : in std_logic;
	STACK_PUSH_type : in std_logic;
	STACK_POP_type : in std_logic;
	LOAD_type : in std_logic;
	STORE_type : in std_logic;
	RTS_type : in std_logic;
	JSR_type : in std_logic;
	
	MEM_RD : in std_logic;
	MEM_WR : in std_logic;
	HAS_DR : in std_logic;
	
	MOV_type_out : out std_logic;
	JMP_type_out : out std_logic;
	COND_type_out : out std_logic;
	jmp_is_ok : out std_logic;
	STACK_PUSH_type_out : out std_logic;
	STACK_POP_type_out : out std_logic;
	LOAD_type_out : out std_logic;
	STORE_type_out : out std_logic;
	RTS_type_out : out std_logic;
	JSR_type_out : out std_logic;
	RD_out : out std_logic_vector(4 downto 0);
	
	dst_valid : out std_logic;
	dstvalid_MEM_out  : out std_logic;
	MEM_RD_out : out std_logic;
	MEM_WR_out : out std_logic;
	HAS_DR_out : out std_logic;
	
	address : out std_logic_vector(31 downto 0); --memory address
	result : out std_logic_vector(31 downto 0); --result from aritm instr
	pc_jmp_value : out std_logic_vector(31 downto 0); --value that should be put into pc (jumps)
	stack_error : out std_logic;
	bad_address : out std_logic
);

end execute;

architecture execute_arch of execute is

component MX_2_1
port
(
	cs : in std_logic;
	data_in : in array_of_reg2;
	
	data_out : out std_logic_vector(31 downto 0)

);

end component;

component MX_4_1
port
(
	cs : in std_logic_vector(1 downto 0);
	data_in : in array_of_reg4;
	
	data_out : out std_logic_vector(31 downto 0)

);

end component;

component SPreg
port
(
	clk : in std_logic;
	load : in std_logic;
	inc : in std_logic;
	dec : in std_logic;
	reset : in std_logic;
	data_in : in std_logic_vector(31 downto 0);
		
	data_out : out std_logic_vector(31 downto 0);
	adr_error_out : out std_logic

);

end component;

component alu is
port
(
	mode : in std_logic_vector(5 downto 0);
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	
	output : out std_logic_vector(31 downto 0)
);
end component;

signal B_MUX_CS, A_MUX_CS : std_logic_vector(1 downto 0);
signal B_MUX_IN, A_MUX_IN : array_of_reg4;
signal JMP_mux_cs, mem_mux_cs : std_logic;
signal JMP_mux_in, mem_mux_in : array_of_reg2;
signal B_MUX_OUT, A_MUX_OUT, ALU_OUT : std_logic_vector(31 downto 0);

signal PC_IMM_ADD : std_logic_vector(31 downto 0);

signal RS1_IMM_value : std_logic_vector(31 downto 0);
signal LOAD_STORE_signal : std_logic;

--signal PUSH_POP_signal : std_logic;

signal SP_value_out : std_logic_vector(31 downto 0);
signal SP_in, SP_out : std_logic_vector(31 downto 0);
signal SP_inc, SP_dec, SP_load : std_logic;

signal err_PC_IMM, err_RS1_IMM : std_logic;
signal check_PC_IMM : std_logic_vector(32 downto 0);

begin
	--izuzeci su : kod racunanja adrese bezuslovnog skoka rs1+immed
	--					kod racunanja adrese uslovnog skoka pc+immed
	--					kod load_store	rs1+immed
	--					kod prekoracenja steka
	
	SP_in <= (others => '0');
	SP_load <= '0';
	
	A_MUX_IN <= (0 => RS1, 1 => PC_plus, 2 => forward_A_MEM, 3 => forward_A_WB);
	A_MUX_CS(0) <= '1' when JSR_type = '1' or fwd_WB_A = '1' else '0';
	A_MUX_CS(1) <= '1' when fwd_MEM_A = '1' or fwd_WB_A = '1' else '0';
	A_MUX : MX_4_1 port map (A_MUX_CS, A_MUX_IN, A_MUX_OUT); --RS1, PC+1(JSR), FORWARDOVANA VREDNOST IZ MEM I IZ WB
	
	B_MUX_IN <= (0 => RS2, 1 => IMM, 2 => forward_B_MEM, 3 => forward_B_WB); --RS2, IMM, FORWARDOVANA VREDNOST IZ MEM I IZ WB
	B_MUX_CS(0) <= '1' when RS_IMM_type = '1' or fwd_WB_B = '1' else '0';
	B_MUX_CS(1) <= '1' when fwd_MEM_B = '1' or fwd_WB_B = '1' else '0';
	B_MUX : MX_4_1 port map (B_MUX_CS, B_MUX_IN, B_MUX_OUT);
	
	SP_dec <= '1' when STACK_PUSH_type = '1' else '0';
	SP_inc <= '1' when STACK_POP_type = '1' else '0';
	SP_REG : SPreg port map (clk, SP_load, SP_inc, SP_dec, reset, SP_in, SP_out, stack_error);
	
	ALU_ENTITY : alu port map (PC(31 downto 26), A_MUX_OUT, B_MUX_OUT, ALU_OUT);
	
	SP_value_out <= std_logic_vector(unsigned(SP_out)) when STACK_PUSH_type='1' else std_logic_vector(unsigned(SP_out)-1); --this is for RTS also (same like pop);
	
	check_PC_IMM <= std_logic_vector(to_signed(to_integer(unsigned(PC)) + to_integer(signed(IMM)), check_PC_IMM'length));
	err_PC_IMM <= check_PC_IMM(32);
	PC_IMM_ADD <= check_PC_IMM(31 downto 0);
	
	RS1_IMM_value <= std_logic_vector(signed(RS1) + signed(IMM)); --ovo je i za JMP vrednost adrese i za load/store
	err_RS1_IMM <= RS1_IMM_value(31); -- ako je negativna adresa onda je error
	LOAD_STORE_signal <= '1' when LOAD_type = '1' or STORE_type = '1' else '0';
		
	result <= ALU_OUT;
	
	JMP_mux_in <= (0=>PC_IMM_ADD, 1=> RS1_IMM_value);
	JMP_mux_cs <= '1' when JMP_type = '1' or JSR_type = '1' else '0'; --else if conditional
	JMP_MUX : MX_2_1 port map(JMP_mux_cs, JMP_mux_in, PC_jmp_value);
	
	mem_mux_in <= (0=> SP_value_out, 1=> RS1_IMM_value);
	mem_mux_cs <= '1' when LOAD_STORE_signal='1' else '0'; --else if push/pop
	mem_MUX : MX_2_1 port map(mem_mux_cs, mem_mux_in, address);
	
	bad_address <= '1' when err_PC_IMM = '1' or err_RS1_IMM = '1' else '0';
	dst_valid <= dstvalid_EX;
	dstvalid_MEM_out <= dstvalid_MEM;
	jmp_is_ok <= ALU_OUT(0);
	MOV_type_out <= MOV_type;
	JMP_type_out <= JMP_type;
	COND_type_out <= COND_type;
	STACK_PUSH_type_out <= STACK_PUSH_type;
	STACK_POP_type_out <= STACK_POP_type;
	LOAD_type_out <= LOAD_type;
	STORE_type_out <= STORE_type;
	RTS_type_out <= RTS_type;
	JSR_type_out <= JSR_type;
	RD_out <= RD;
	MEM_RD_out <= MEM_RD;
	MEM_WR_out <= MEM_WR;
	HAS_DR_out <= HAS_DR;
end execute_arch;