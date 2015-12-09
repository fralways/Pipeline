library ieee;
use ieee.std_logic_1164.all;

package custom_types is

	type array_of_reg is array(0 to 31) of std_logic_vector(31 downto 0);
	type branch_predictor_entry is record
		v : std_logic;
		pc_value  : std_logic_vector(31 downto 0);
		prediction_value : std_logic_vector(1 downto 0);
		jump_address : std_logic_vector(31 downto 0);
	end record branch_predictor_entry;
	type array_of_branch_entries is array (0 to 8) of branch_predictor_entry;
end package custom_types;