library ieee;
use ieee.std_logic_1164.all;
use work.custom_types.all;

entity stick_EXE_MEM is
port
(
	clk : in std_logic;
	signals_in : in stick_structEXE_MEM;
	signals_out : out stick_structEXE_MEM
);
end stick_EXE_MEM;

architecture stick_EXE_MEM_arch of stick_EXE_MEM is

begin

	process(clk)
	
	variable signals : stick_structEXE_MEM;
	
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
		
end stick_EXE_MEM_arch;