library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder_64 is

port
(

	cs : in std_logic_vector(5 downto 0);
	
	select_out : out std_logic_vector(63 downto 0)

);

end decoder_64;

architecture decoder_64_arch of decoder_64 is

begin

	process (cs)
	variable index : integer;
	begin
	
		index := to_integer(unsigned(cs));
		select_out <= (others => '0');
		select_out(index) <= '1';
	
	end process;

end decoder_64_arch;