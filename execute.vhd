library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity execute is

port
(
	PC : in std_logic_vector(31 downto 0);
	RS1 : in std_logic_vector(31 downto 0);
	RS2 : in std_logic_vector(31 downto 0);
	IMM : in std_logic_vector(31 downto 0);
	
	RS_RS_type : in std_logic;
	RS_IMM_type : in std_logic;
	MOV_type : in std_logic;
	JMP_type : in std_logic;
	COND_type : in std_logic;
	
	RS_RS_type_out : out std_logic;
	RS_IMM_type_out : out std_logic;
	MOV_type_out : out std_logic;
	JMP_type_out : out std_logic;
	COND_type_out : out std_logic;
	jmp_is_ok : out std_logic;
	result : out std_logic_vector(31 downto 0)
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

component alu is
port
(
	mode : in std_logic_vector(5 downto 0);
	A : in std_logic_vector(31 downto 0);
	B : in std_logic_vector(31 downto 0);
	
	output : out std_logic_vector(31 downto 0)
);
end component;

signal B_MUX_CS, output_mux_cs : std_logic;
signal B_MUX_IN, output_mux_in : array_of_reg2;
signal B_MUX_OUT, ALU_OUT : std_logic_vector(31 downto 0);
signal RS1_IMM_ADD : std_logic_vector(31 downto 0);

begin
	B_MUX_IN <= (0 => RS2, 1 => IMM);
	B_MUX_CS <= '1' when RS_IMM_type = '1' or JMP_type = '1' else '0';
	B_MUX : MX_2_1 port map (B_MUX_CS, B_MUX_IN, B_MUX_OUT);
	
	ALU_ENTITY : alu port map (PC(31 downto 26), RS1, B_MUX_OUT, ALU_OUT);
	
	RS1_IMM_ADD <= std_logic_vector(unsigned(PC) + unsigned(IMM));
	output_mux_in <= (0 => ALU_OUT, 1 => RS1_IMM_ADD);
	output_mux_cs <= '1' when JMP_type = '1' else '0';
	OUTPUT_MUX : MX_2_1 port map(output_mux_cs, output_mux_in, result);
	
	jmp_is_ok <= ALU_OUT(0);
	RS_RS_type_out <= RS_RS_type;
	RS_IMM_type_out <= RS_IMM_type;
	MOV_type_out <= MOV_type;
	JMP_type_out <= JMP_type;
	COND_type_out <= COND_type;
end execute_arch;