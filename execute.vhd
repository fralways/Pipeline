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
	
	MEM_RD_out : out std_logic;
	MEM_WR_out : out std_logic;
	
	address : out std_logic_vector(31 downto 0); --jmp address
	result : out std_logic_vector(31 downto 0); --result from aritm instr
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
		
	data_out : out std_logic_vector(31 downto 0)

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

signal B_MUX_CS : std_logic;
signal B_MUX_IN : array_of_reg2;
signal output_mux_cs : std_logic_vector(1 downto 0);
signal output_mux_in : array_of_reg4;
signal B_MUX_OUT, ALU_OUT : std_logic_vector(31 downto 0);

signal PC_IMM_ADD : std_logic_vector(31 downto 0);

signal LOAD_STORE_value : std_logic_vector(31 downto 0);
signal LOAD_STORE_signal : std_logic;

signal PUSH_POP_signal : std_logic;

signal SP_value_out : std_logic_vector(31 downto 0);
signal SP_in, SP_out : std_logic_vector(31 downto 0);
signal SP_inc, SP_dec, SP_load : std_logic;
begin
	SP_in <= (others => '0');
	SP_load <= '0';
	B_MUX_IN <= (0 => RS2, 1 => IMM);
	B_MUX_CS <= '1' when RS_IMM_type = '1' else '0';
	B_MUX : MX_2_1 port map (B_MUX_CS, B_MUX_IN, B_MUX_OUT);
	
	SP_dec <= '1' when STACK_PUSH_type = '1' else '0';
	SP_inc <= '1' when STACK_POP_type = '1' else '0';
	SP_REG : SPreg port map (clk, SP_load, SP_inc, SP_dec, reset, SP_in, SP_out);
	
	ALU_ENTITY : alu port map (PC(31 downto 26), RS1, B_MUX_OUT, ALU_OUT);
	
	SP_value_out <= std_logic_vector(unsigned(SP_out)) when STACK_PUSH_type='1' else std_logic_vector(unsigned(SP_out)-1); --this is for RTS also (same like pop);
	
	PC_IMM_ADD <= std_logic_vector(signed(PC) + signed(IMM));
	
	LOAD_STORE_value <= std_logic_vector(std_logic_vector(signed(RS1) + signed(IMM)));
	LOAD_STORE_signal <= '1' when LOAD_type = '1' or STORE_type = '1' else '0';
	
	PUSH_POP_signal <= '1' when STACK_PUSH_type = '1' or STACK_POP_type = '1' else '0';
	
	result <= ALU_OUT;
	output_mux_in <= (1 => PC_IMM_ADD, 2 => SP_value_out, 3 => LOAD_STORE_value, 0 => PC_plus);
	output_mux_cs(0) <= '1' when PUSH_POP_signal = '1' or LOAD_STORE_signal = '1' else '0';
	output_mux_cs(1) <= '1' when LOAD_STORE_signal = '1' or JMP_type = '1' else '0';
	OUTPUT_MUX : MX_4_1 port map(output_mux_cs, output_mux_in, address);
	
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
end execute_arch;