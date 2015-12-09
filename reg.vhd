library ieee;
use ieee.std_logic_1164.all;

entity reg is
	port
	(
		clk : in std_logic;
		ld : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		
		data_out : out std_logic_vector(31 downto 0)
	);
end reg;

architecture reg_arch of reg is
begin

process (clk, reset)
	variable data : std_logic_vector(31 downto 0);
begin

	if (reset = '1') then
		data := (others => '0');
	elsif (rising_edge(clk)) then
		if (ld = '1') then
			data := data_in;
		end if;
	end if;
	
	data_out <= data;
	
end process;

end reg_arch;

