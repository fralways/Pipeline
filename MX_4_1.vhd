library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.custom_types.all;

entity MX_4_1 is

port
(

	cs : in std_logic_vector(1 downto 0);
	data_in : in array_of_reg4;
	
	data_out : out std_logic_vector(31 downto 0)

);

end MX_4_1;

architecture MX_4_1_arch of MX_4_1 is

begin

	process (cs, data_in)
	variable index : integer;
	begin
	
		index := to_integer(unsigned(cs));
		data_out <= data_in(index);
	
	end process;

end MX_4_1_arch;
