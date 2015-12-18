library ieee;
use ieee.std_logic_1164.all;

package custom_types is

	type array_of_reg is array(0 to 31) of std_logic_vector(31 downto 0);
	type array_of_reg4 is array(0 to 3) of std_logic_vector(31 downto 0);
	type array_of_reg2 is array(0 to 1) of std_logic_vector(31 downto 0);
	
	type branch_predictor_entry is record
		v : std_logic;
		pc_value  : std_logic_vector(31 downto 0);
		prediction_value : std_logic_vector(1 downto 0);
		jump_address : std_logic_vector(31 downto 0);
	end record branch_predictor_entry;
	type array_of_branch_entries is array (0 to 31) of branch_predictor_entry;
	
	type stick_struct is record
		IF_pc : std_logic_vector(31 downto 0);
		IF_pc_plus : std_logic_vector(31 downto 0);
		IF_is_prediction_entry_found : std_logic;
		IF_prediction : std_logic;
		IF_prediction_address : std_logic_vector(31 downto 0);
		IF_stall : std_logic;
		IF_flush : std_logic;
		IF_instr_value : std_logic_vector(31 downto 0);
	end record stick_struct;
end package custom_types;