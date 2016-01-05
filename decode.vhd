library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity decode is
port
(
	--za sad je u redu
	flush : in std_logic;
	IF_pc : in std_logic_vector(31 downto 0);
	IF_pc_plus : in std_logic_vector(31 downto 0);
	IF_is_prediction_entry_found : in std_logic;
	IF_prediction : in std_logic;
	IF_prediction_address : in std_logic_vector(31 downto 0);
	IF_stall : in std_logic;
	IF_flush : in std_logic;
	IF_instr_value : in std_logic_vector(31 downto 0);
	WB_rdst : in std_logic_vector(4 downto 0);
	WB_data : in std_logic_vector(31 downto 0);
	WB_write : in std_logic;
	clk : in std_logic;
	reset : in std_logic;
	
	is_prediction_entry_found : out std_logic;
	prediction : out std_logic;
	prediction_address : out std_logic_vector(31 downto 0);
	instr_value : out std_logic_vector(31 downto 0);
	dst : out std_logic_vector(4 downto 0);
	src1 : out std_logic_vector(4 downto 0);
	RSRC1 : out std_logic_vector(31 downto 0);
	src2 : out std_logic_vector(4 downto 0);
	RSRC2 : out std_logic_vector(31 downto 0);
	IMM : out std_logic_vector(31 downto 0);
	stall : out std_logic;
	flush_out : out std_logic;
	ocerror : out std_logic;
	pc : out std_logic_vector(31 downto 0);
	pc_plus : out std_logic_vector(31 downto 0);
	
	dstvalid_EX : out std_logic;
	dstvalid_MEM : out std_logic;
	RS_IM_type : out std_logic;
	MOV_type : out std_logic;
	JMP_inst : out std_logic;
	COND_type : out std_logic;
	RTS_type : out std_logic;
	JSR_inst : out std_logic;
	PUSH_inst : out std_logic;
	POP_inst : out std_logic;
	LOAD_inst : out std_logic;
	STORE_inst : out std_logic;
	MEM_WR : out std_logic;
	MEM_RD : out std_logic;
	has_DR : out std_logic;
	has_SR1 : out std_logic;
	has_SR2 : out std_logic
	
);
end decode;

architecture decode_arch of decode is

component decoder_64
port
(
	cs : in std_logic_vector(5 downto 0);
	
	select_out : out std_logic_vector(63 downto 0)
);
end component;

component reg_file
port
(
	clk : in std_logic;
	reset : in std_logic;
	wr : in std_logic;
	dst : in std_logic_vector(4 downto 0);
	src1 : in std_logic_vector(4 downto 0);
	src2 : in std_logic_vector(4 downto 0);
	data_in : in std_logic_vector(31 downto 0);
	
	data_out1 : out std_logic_vector(31 downto 0);
	data_out2 : out std_logic_vector(31 downto 0)
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

signal opcode : std_logic_vector (5 downto 0);
signal rs1 :std_logic_vector (4 downto 0);
signal rs2 : std_logic_vector (4 downto 0);
signal rs1_val : std_logic_vector(31 downto 0);
signal rs2_val : std_logic_vector(31 downto 0);
signal immcnt : std_logic_vector (15 downto 0);
signal immshift : std_logic_vector (4 downto 0);
signal immbranch : std_logic_vector (15 downto 0);
signal operation : std_logic_vector (63 downto 0);
signal is_immcnt : std_logic;
signal is_immshift : std_logic;
signal is_immbranch : std_logic;
signal immcntext : std_logic_vector(31 downto 0);
signal immshiftext : std_logic_vector(31 downto 0);
signal immbranchext : std_logic_vector(31 downto 0);
signal mx_cs : std_logic_vector(1 downto 0);
signal imm_mx_datain : array_of_reg4;
signal flushing : std_logic;

begin
	flushing <= '1' when IF_flush = '1' or IF_stall = '1' or flush = '1' else '0';
	opcode <= IF_instr_value (31 downto 26);
	dst <= IF_instr_value (25 downto 21);
	rs1 <= IF_instr_value (20 downto 16);
	rs2 <= IF_instr_value (15 downto 11);
	src1 <= rs1;
	src2 <= rs2;
	immcnt <= IF_instr_value (15 downto 0);
	immshift <= IF_instr_value (15 downto 11);
	immbranch <= IF_instr_value (25 downto 21) & IF_instr_value(10 downto 0);
	OCDECODER : decoder_64 port map(opcode, operation);
	
	--vezivanje svih neispravnih kodova instrukcija na signal greske + NOP (3Fh) i HALT (38h)
	ocerror <= '1' when operation(2)='1' or operation(3)='1' or operation(6)='1' or operation(7)='1' or
				operation(10)='1' or operation(11)='1' or operation(14)='1' or operation(15)='1' or 
				operation(20)='1' or operation(21)='1' or operation(22)='1' or operation(23)='1' or 
				operation(29)='1' or operation(30)='1' or operation(31)='1' or 
				operation(35)='1' or operation(38)='1' or operation(39)='1' or 
				operation(46)='1' or operation(47)='1' or 
				operation(48)='1' or operation(49)='1' or operation(50)='1' or operation(51)='1' or
				operation(52)='1' or operation(53)='1' or operation(54)='1' or operation(55)='1' or 
				operation(57)='1' or operation(58)='1' or operation(59)='1' or operation(60)='1' or
				operation(61)='1' or operation(62)='1'
	else '0';
	--signali selekcije neposredne vrednosti koju treba koristiti
	--za LOAD, MOVI, ADDI, SUBI, JMP, JSR
	is_immcnt <= '1' when operation(0) = '1' or operation(12) = '1' or operation(13) = '1' or 
					operation(5) = '1' or operation(32) = '1' or operation(33) = '1' else '0';
	--za SHL, SHR, SAR, ROL, ROR
	is_immshift <= '1' when operation(24) = '1' or operation(25) = '1' or operation(26) = '1' or
					operation(27) = '1' or operation(28) = '1' else '0';
	--za STORE i uslovne skokove
	is_immbranch <= '1' when operation(1) = '1' or operation(40) = '1' or operation(41) = '1' or
					operation(42) = '1' or operation(43) = '1' or
						operation(44) = '1' or operation(45) = '1' else '0';
	--registarski fajl
	REGFILE : reg_file port map(clk, reset, WB_write, WB_rdst, rs1, rs2, WB_data, rs1_val, rs2_val);
	
	RSRC1 <= rs1_val;
	RSRC2 <= rs2_val;
	
	--priprema ulaza MX za neposrednu vrednost
	mx_cs(0) <= '1' when is_immshift = '1' or is_immbranch = '1' else '0';
	mx_cs(1) <= '1' when is_immcnt = '1' or is_immbranch = '1' else '0';
	
	immshiftext <= (31 downto 5 => '0') & immshift;
	immcntext <= (31 downto 16 => '1') & immcnt when immcnt(15) = '1' else (31 downto 16 => '0') & immcnt;
	immbranchext <= (31 downto 16 => '1') & immbranch when immbranch(15) = '1' else (31 downto 16 => '0') & immbranch;	
	imm_mx_datain <= (0 => (31 downto 1 => '0') & '1', 1 => immshiftext, 2 => immcntext, 3 => immbranchext);
	
	IMM_MX : MX_4_1 port map(mx_cs, imm_mx_datain, IMM);
	
	is_prediction_entry_found <= IF_is_prediction_entry_found;
	prediction <= IF_prediction;
	prediction_address <= IF_prediction_address;
	stall <= IF_stall;
	flush_out <= IF_flush or flush;
	instr_value <= IF_instr_value when not flushing = '1' else X"FC000000";
	pc <= IF_pc when not flushing = '1' else X"00000000";
	pc_plus <= IF_pc_plus when not flushing = '1' else X"00000000";
	
	--instrukcije koje imaju destinacioni registar i vrednost za upis dobijaju u EX fazi ili ranije
	--MOV, MOVI, ADD, SUB, ADDI, SUBI, AND, OR, XOR, NOT, SHL, SHR, SAR, ROL, ROR
	dstvalid_EX <= '1' when (operation(4)='1' or operation(5)='1' or operation(7)='1' or operation(8)='1' or 
					operation(9)='1' or operation(12)='1' or operation(13)='1' or operation(16)='1' or operation(17)='1' or 
					operation(18)='1' or operation(19)='1' or operation(24)='1' or operation(25)='1' or operation(26)='1' or 
					operation(27)='1' or operation(28)='1') and flushing = '0' else '0';
	
	--instrukcije koje imaju destinacioni registar i vrednost za upis dobijaju u MEM fazi
	--LOAD, POP
	dstvalid_MEM <= '1' when (operation(0)='1' or operation(37)='1') and flushing = '0'  else '0';
	
	--instrukcije koje koriste 1 RS1 i IMM vrednost za racunanje:
	-- MOVI, ADDI, SUBI, SHL, SHR, SAR, ROL, ROR
	RS_IM_type <= '1' when (operation(5)='1' or operation(12)='1' or operation(13)='1' or operation(24)='1' or
					operation(25)='1' or operation(26)='1' or operation(27)='1' or operation(28)='1') and flushing = '0' else '0';
					
	--instrkucije pomeranja operanda u registar i efektivno ne koriste EX fazu:
	-- MOV, MOVI
	MOV_type <= '1' when (operation(4)='1' or operation(5)='1') and not flushing = '0' else '0';
	
	--instrukcije uslovnog skoka:
	--BEQ, BNQ, BGT, BLT, BGE, BLE
	COND_type <= '1' when (operation(40)='1' or operation(41)='1' or operation(42)='1' or operation(43)='1' or
					operation(44)='1' or operation(45)='1') and flushing = '0' else '0';
					
	JMP_inst <= operation(32) and not flushing;
	RTS_type <= operation(34) and not flushing;
	JSR_inst <= operation(33) and not flushing;
	PUSH_inst <= operation(36) and not flushing;
	POP_inst <= operation(37) and not flushing;
	LOAD_inst <= operation(0) and not flushing;
	STORE_inst <= operation(1) and not flushing;
	
	--instrukcije koje vrse upis u memoriju:
	--STORE, JSR, PUSH
	MEM_WR <= '1' when (operation(1) = '1' or operation(33) = '1' or operation(36) = '1') and flushing = '0' else '0';
	
	--instrkucije koje vrse citanje iz memorije:
	--LOAD, RTS, POP
	MEM_RD <= '1' when (operation(0) = '1' or operation(34) = '1' or operation(37) = '1') and flushing = '0' else '0';
	
	--instrukcije koje imaju neki registar kao odrediste;
	--LOAD, MOV, MOVI, ADD, SUB, ADDI, SUBI, AND, OR, XOR, NOT, SHL, SHR, SAR, ROL, ROR, POP
	has_DR <= '1' when (operation(0) = '1' or operation(4) = '1' or operation(5) = '1' or operation(8) = '1' or operation(9) = '1' or 
				operation(12) = '1' or operation(13) = '1' or operation(16) = '1' or operation(17) = '1' or operation(18) = '1' or 
				operation(19) = '1' or operation(24) = '1' or operation(25) = '1' or operation(26) = '1' or operation(27) = '1' or 
				operation(28) = '1' or operation(37) = '1') and flushing = '0' else '0';
				
	--instrukcije koje koriste polje RS1:
	--LOAD, STORE, MOV, ADD, SUB, ADDI, SUBI, AND, OR, XOR, NOT, SHL, SHR, SAR, ROL, ROR, JMP, JSR, PUSH, BEQ, BNQ, BLT, BGT, BLE, BGE
	has_SR1 <= '1' when (operation(0) = '1' or operation(1) = '1' or operation(4) = '1' or operation(8) = '1' or operation(9) = '1' or
				operation(12) = '1' or operation(13) = '1' or operation(16) = '1' or operation(17) = '1' or operation(18) = '1' or
				operation(19) = '1' or operation(24) = '1' or operation(25) = '1' or operation(26) = '1' or operation(27) = '1' or 
				operation(28) = '1' or operation(32) = '1' or operation(33) = '1' or operation(36) = '1' or operation(40) = '1' or
				operation(41) = '1' or operation(42) = '1' or operation(43) = '1' or operation(44) = '1' or operation(45) = '1') and flushing = '0'
				else '0';
	
	--instrukcije koje koriste polje RS2
	--STORE, ADD, SUB, AND, OR, XOR, 
	has_SR2 <= '1' when (operation(1) = '1' or operation(8) = '1' or operation(9) = '1' or operation(16) = '1' or operation(17) = '1' or
				operation(18) = '1' or operation(24) = '1' or operation(25) = '1' or operation(26) = '1' or operation(27) = '1' or 
				operation(28) = '1' or operation(40) = '1' or operation(41) = '1' or operation(42) = '1' or operation(43) = '1' or
				operation(44) = '1' or operation(45) = '1') and flushing = '0' else '0';
	
	
end decode_arch;

