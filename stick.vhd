library ieee;
use ieee.std_logic_1164.all;
use work.custom_types.all;

entity stick is
port
(
	clk : in std_logic;
	signals_in : in stick_struct;
	signals_out : out stick_struct
);
end stick;

architecture stick_arch of stick is

begin

	process(clk)
	
	variable signals : stick_struct;
	
	begin
		if (rising_edge(clk)) then
			if (signals_in.IF_stall = '0') then
				signals := signals_in;
			else
				signals.IF_stall := '1';
			end if;
		end if;
		signals_out <= signals;
	end process;
		
end stick_arch;