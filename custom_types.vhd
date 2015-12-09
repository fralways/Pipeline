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
	type array_of_branch_entries is array (0 to 7) of branch_predictor_entry;
	
	type blocker is record
		pc : std_logic_vector(31 downto 0);
		pc_plus : std_logic_vector(31 downto 0);
		is_prediction_entry_found : std_logic;
		prediction : std_logic;
		prediction_address : std_logic_vector(31 downto 0);
	end record blocker;
end package custom_types;