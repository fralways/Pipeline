library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_32 is

port
(

	cs : in std_logic_vector(4 downto 0);
	
	select_out : out std_logic_vector(31 downto 0)

);

end decoder_32;

architecture decoder_32_arch of decoder_32 is

begin

	process (cs)
	variable index : integer;
	begin
	
		index := to_integer(unsigned(cs));
		select_out <= (others => '0');
		select_out(index) <= '1';
	
	end process;

end decoder_32_arch;