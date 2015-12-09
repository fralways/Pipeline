library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.custom_types.all;

entity reg_file is

port
(
	clk : in std_logic;
--	ld : in std_logic;
	wr : in std_logic;
	cs : in std_logic_vector(4 downto 0);
	data_in : in std_logic_vector(31 downto 0);
	
	data_out : out std_logic_vector(31 downto 0)
);

end reg_file;

architecture reg_file_arch of reg_file is

--components
component reg
port
(
	clk : in std_logic;
	ld : in std_logic;
	reset : in std_logic;
	data_in : in std_logic_vector(31 downto 0);
		
	data_out : out std_logic_vector(31 downto 0)
);
end component;

component decoder_32
port
(
	cs : in std_logic_vector(4 downto 0);
	
	select_out : out std_logic_vector(31 downto 0)
);
end component;

component MX_32_1 is

port
(
	cs : in std_logic_vector(4 downto 0);
	data_in : in array_of_reg;
	
	data_out : out std_logic_vector(31 downto 0)
);

end component;
--end components

--signals
--decoder
signal decoder_out : std_logic_vector(31 downto 0);
signal MX_out : std_logic_vector(31 downto 0);

--registers
type reg_control_type is array (0 to 31) of std_logic;
signal reg_data_in, reg_data_out : array_of_reg;
signal reg_reset, reg_load : reg_control_type;
--end signals

begin

	DECODER : decoder_32 port map (cs, decoder_out);
	
	LOAD_REG_SIGNAL_GEN:
	for i in 0 to 31 generate
		reg_load(i) <= '1' when wr = '1' and decoder_out(i) = '1' else '0';
		reg_reset(i) <= '0';
	end generate;
	
	GEN_REG: 
   for i in 0 to 31 generate
      REGX : REG port map
        (clk, reg_load(i), reg_reset(i), data_in, reg_data_out(i));
   end generate GEN_REG;
	
	MX : MX_32_1 port map (cs, reg_data_out, MX_out);

	data_out <= MX_out;

end reg_file_arch;