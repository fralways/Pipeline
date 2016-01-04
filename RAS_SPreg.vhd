library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAS_SPreg is
	port
	(
		clk : in std_logic;
		inc : in std_logic;
		dec : in std_logic;
		reset : in std_logic;
		
		data_out : out std_logic_vector(2 downto 0)
	);
end RAS_SPreg;

architecture ras_spreg_arch of RAS_SPreg is
begin

process (clk, reset)
	variable data : std_logic_vector(2 downto 0);
begin
	if (reset = '1') then
		data := (others => '1');
	elsif (rising_edge(clk)) then
		if (inc = '1') then
			data := std_logic_vector(to_unsigned(to_integer(unsigned(data))+1, data_out'length));
		elsif (dec = '1') then
			data := std_logic_vector(to_unsigned(to_integer(unsigned(data))-1, data_out'length));
		end if;
	end if;
	
	data_out <= data;
	
end process;

end ras_spreg_arch;