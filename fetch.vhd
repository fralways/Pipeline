library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity fetch is
port
(
	clk : in std_logic;
	reset : in std_logic;
	pc : in std_logic_vector(31 downto 0);
	update_entry : in std_logic;
	prediction_was_success : in std_logic;
	update_entry_pc : in std_logic_vector(31 downto 0);
	update_entry_jmp_address : in std_logic_vector(31 downto 0);
	
	pc_out : out std_logic_vector(31 downto 0);
	pc_plus : out std_logic_vector(31 downto 0);
	is_prediction_entry_found : out std_logic;
	prediction : out std_logic;
	prediction_address : out std_logic_vector(31 downto 0)

);
end fetch;

architecture fetch_arch of fetch is

component branch_predictor
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
end component;

signal get_prediction : std_logic;

begin
	get_prediction <= '1' when reset = '0' else '0';
	PREDICTOR : branch_predictor port map (clk, reset, get_prediction, pc, update_entry, prediction_was_success, update_entry_pc, 
														update_entry_jmp_address, is_prediction_entry_found, prediction, prediction_address);
														
	pc_out <= pc;
	pc_plus <= std_logic_vector(to_unsigned(to_integer(unsigned(pc))+1, pc_plus'length));

end fetch_arch;