library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_8 is

port
(

	cs : in std_logic_vector(2 downto 0);
	
	select_out : out std_logic_vector(7 downto 0)

);

end decoder_8;

architecture decoder_8_arch of decoder_8 is

begin

	process (cs)
	variable index : integer;
	begin
	
		index := to_integer(unsigned(cs));
		select_out <= (others => '0');
		select_out(index) <= '1';
	
	end process;

end decoder_8_arch;