-- Update the register output on the clock's rising edge
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PCreg is
	port
	(
		clk : in std_logic;
		load : in std_logic;
		inc : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		data_out : out std_logic_vector(31 downto 0)
	);
end PCreg;

architecture pcreg_arch of PCreg is
begin

process (clk, reset)
--	variable data : std_logic_vector(31 downto 0);
	variable temp : integer;
begin
	if (reset = '1') then
		data_out <= (others => '0');
--		data := (others => '0');
		temp := 0;
	elsif (rising_edge(clk)) then
		if (load = '1') then
			data_out <= data_in;
--			data := data_in;
			temp := to_integer(unsigned(data_in));
		elsif (inc = '1') then
			--povecaj sadrzaj data za 1
			temp := temp+1;
			data_out <= std_logic_vector(to_unsigned(temp, data_in'length));
--			data_out <= data;
		end if;
	end if;
end process;

end pcreg_arch;