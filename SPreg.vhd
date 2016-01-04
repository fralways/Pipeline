library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPreg is
	port
	(
		clk : in std_logic;
		load : in std_logic;
		inc : in std_logic;
		dec : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		
		data_out : out std_logic_vector(31 downto 0);
		adr_error_out : out std_logic
	);
end SPreg;

architecture spreg_arch of SPreg is
begin

process (clk, reset)
	variable data : std_logic_vector(31 downto 0);
begin
	if (reset = '1') then
		data := (others => '1');
		adr_error_out <= '0';
	elsif (rising_edge(clk)) then
		adr_error_out <= '0';
		if (load = '1') then
			data := data_in;
		elsif (inc = '1') then
			data := std_logic_vector(to_unsigned(to_integer(unsigned(data))+1, data_out'length));
			if (data = X"00000000") then adr_error_out <= '1';
			end if;
		elsif (dec = '1') then
			data := std_logic_vector(to_unsigned(to_integer(unsigned(data))-1, data_out'length));
			if (data = X"FFFFFFFF") then adr_error_out <= '1';
			end if;
		end if;
	end if;
	
	data_out <= data;
	
end process;

end spreg_arch;