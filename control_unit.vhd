library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
port
(
	IF_is_prediction_entry_found : in std_logic;
	IF_prediction : in std_logic;
	
	pc_jumping : out std_logic
);
end control_unit;

architecture control_unit_arch of control_unit is
begin
	pc_jumping <= '1' when IF_is_prediction_entry_found = '1' and IF_prediction = '1' else '0';
end control_unit_arch;
