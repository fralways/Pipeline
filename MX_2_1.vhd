library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.custom_types.all;

entity MX_2_1 is

port
(

	cs : in std_logic;
	data_in : in array_of_reg2;
	
	data_out : out std_logic_vector(31 downto 0)

);

end MX_2_1;

architecture MX_2_1_arch of MX_2_1 is

begin

	process (cs, data_in)
	variable index : integer;
	begin
		if (cs = '1') then
			index := 1;
		else
			index := 0;
		end if;
		data_out <= data_in(index);
	
	end process;

end MX_2_1_arch;