library ieee;
use ieee.std_logic_1164.all;
use work.custom_types.all;

entity stick_MEM_WB is
port
(
	clk : in std_logic;
	signals_in : in stick_structMEM_WB;
	signals_out : out stick_structMEM_WB
);
end stick_MEM_WB;

architecture stick_MEM_WB_arch of stick_MEM_WB is

begin

	process(clk)
	
	variable signals : stick_structMEM_WB;
	
	begin
		if (rising_edge(clk)) then
			if (signals_in.stall = '0') then
				signals := signals_in;
			else
				signals.stall := '1';
			end if;
		end if;
		signals_out <= signals;
	end process;
		
end stick_MEM_WB_arch;