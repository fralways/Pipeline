library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity branch_predictor is

port
(
	clk : in std_logic;
	reset : in std_logic;
	get_prediction : in std_logic;
	prediction_entry_pc : in std_logic_vector(31 downto 0);
	update_entry : in std_logic;
	prediction_was_success : in std_logic;
	update_entry_pc : in std_logic_vector(31 downto 0);
	update_entry_jmp_address : in std_logic_vector(31 downto 0);
	
	is_prediction_entry_found : out std_logic;
	prediction : out std_logic;
	prediction_address : out std_logic_vector(31 downto 0)
);
end branch_predictor;

architecture branch_predictor_arch of branch_predictor is

	signal branch_entries : array_of_branch_entries := (others=>
									(
                             pc_value => (others => '0'), 
                             prediction_value => (others => '0'),
                             jump_address => (others => '0'),
									  v => '0'
                           ));
	
procedure prediction_bits_to_value(prediction_bits: std_logic_vector(1 downto 0); prediction_value: out std_logic) is
begin

	if (prediction_bits = "11" or prediction_bits = "10") then
		prediction_value := '1';
	else
		prediction_value := '0';
	end if;

end prediction_bits_to_value;

begin
	
	process(clk, reset)
	
		variable branch_entry : branch_predictor_entry;
		variable found_entry : boolean;
		variable found_entry_index : integer;
		variable prediction_value : std_logic;
		variable prediction_number : integer;
		variable head : integer range 0 to 32 := 0;
	begin
		if (reset = '1') then
			for i in 0 to 31 loop
				branch_entries(i).v <= '0';
			end loop;
		elsif (rising_edge(clk)) then
			prediction <= '0';
			if (update_entry = '1') then
				found_entry := false;
				for i in 0 to 31 loop
					if (branch_entries(i).v = '1') then
						if (update_entry_pc = branch_entries(i).pc_value) then
							found_entry := true;
							found_entry_index := i;
							exit;
						end if;
					end if;
				end loop;
					
				if (found_entry = true) then
					prediction_number :=  to_integer(unsigned(branch_entries(found_entry_index).prediction_value));
					if (prediction_was_success = '1') then
						if (prediction_number < 3) then
							prediction_number := prediction_number + 1;
						end if;
					else
						if (prediction_number > 0) then
							prediction_number := prediction_number - 1;
						end if;
					end if;
					branch_entries(found_entry_index).prediction_value <= std_logic_vector(to_unsigned(prediction_number, branch_entries(found_entry_index).prediction_value'length));					
					branch_entries(found_entry_index).jump_address <= update_entry_jmp_address;
				else
					prediction_number :=  2;
					if (prediction_was_success = '1') then						
							prediction_number := 3;
					else
							prediction_number := 1;
					end if;
					branch_entries(head) <=
									(
										v => '1',
										pc_value => update_entry_pc, 
										prediction_value => std_logic_vector(to_unsigned(prediction_number, 2)),
										jump_address => update_entry_jmp_address
									);
					head := head + 1;
					if (head > 31) then
						head := 0;
					end if;
				end if;
			end if;
			if (get_prediction = '1') then
				is_prediction_entry_found <= '0';
				found_entry := false;
				for i in 0 to 31 loop
					if (branch_entries(i).v = '1') then
						if (prediction_entry_pc = branch_entries(i).pc_value) then
							found_entry := true;
							found_entry_index := i;
							exit;
						end if;
					end if;
				end loop;
				if (found_entry = true) then
					prediction_bits_to_value(branch_entries(found_entry_index).prediction_value, prediction_value);
					prediction <= prediction_value;
					prediction_address <= branch_entries(found_entry_index).jump_address;
					is_prediction_entry_found <= '1';
				else
					is_prediction_entry_found <= '0';
				end if;
			end if;	
		end if;
	end process;

end branch_predictor_arch;