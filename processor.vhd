library ieee;
use ieee.std_logic_1164.all;
use work.custom_types.all;

entity processor is
port
(
	clk : std_logic;
	reset : std_logic
);
end processor;

architecture processor_arch of processor is

component fetch
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
end component;

component PCreg
	port
	(
		clk : in std_logic;
		load : in std_logic;
		inc : in std_logic;
		reset : in std_logic;
		data_in : in std_logic_vector(31 downto 0);
		
		data_out : out std_logic_vector(31 downto 0)
	);
end component;

component Cache is
port
(
	clk : in std_logic;
	rd_instr : in std_logic;
	rd_data : in std_logic;
	wr : in std_logic;
	address_in : in std_logic_vector(31 downto 0);
	data_in : in std_logic_vector(31 downto 0);
	
	data_out : out std_logic_vector(31 downto 0)

);
end component;

signal PC_load, PC_inc : std_logic;
signal PC_data_out : std_logic_vector(31 downto 0);
signal CACHE_rd_instr, CACHE_rd_data, CACHE_wr : std_logic;
signal CACHE_address_in, CACHE_data_in, CACHE_data_out : std_logic_vector(31 downto 0);
signal FETCH_update_entry, FETCH_prediction_was_success, FETCH_is_prediction_entry_found, FETCH_prediction : std_logic;
signal FETCH_update_entry_pc, FETCH_update_entry_jmp_address, FETCH_pc_out, FETCH_pc_plus, FETCH_prediction_address : std_logic_vector(31 downto 0); 

begin

	PC_load <= '1' when reset = '1' else '0';
	PC_inc <= '1' when reset = '0' else '0';
	CACHE_address_in <= PC_data_out;
	CACHE_rd_instr <= '1';
	
	CACHE_ENTITY : Cache port map (clk, CACHE_rd_instr, CACHE_rd_data, CACHE_wr, CACHE_address_in, CACHE_data_in, CACHE_data_out);
	PC_REG : PCreg port map (clk, PC_load, PC_inc, '0', CACHE_data_out, PC_data_out);
	FETCH_PHASE : fetch port map (clk, reset, PC_data_out, FETCH_update_entry, FETCH_prediction_was_success, FETCH_update_entry_pc, FETCH_update_entry_jmp_address,
														FETCH_pc_out, FETCH_pc_plus, FETCH_is_prediction_entry_found, FETCH_prediction, FETCH_prediction_address);

end processor_arch;