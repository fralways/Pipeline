library ieee;
use ieee.std_logic_1164.all;
use work.custom_types.all;

entity stick_ID_EXE is
port
(
	clk : in std_logic;
	signals_in : in stick_structID_EXE;
	signals_out : out stick_structID_EXE
);
end stick_ID_EXE;

architecture stick_ID_EXE_arch of stick_ID_EXE is

begin

	process(clk)
	
	variable signals : stick_structID_EXE;
	
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
		
end stick_ID_EXE_arch;