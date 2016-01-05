library ieee;
use ieee.std_logic_1164.all;

entity memory is

port
(
	flush : in std_logic;
	COND_type : in std_logic;
	jmp_is_ok : in std_logic;
	RD : in std_logic_vector(4 downto 0);
	
	MEM_RD : in std_logic;
	MEM_WR : in std_logic;
	HAS_DR : in std_logic;
	
	pc_plus : in std_logic_vector(31 downto 0);
	address : in std_logic_vector(31 downto 0); --memory address
	result : in std_logic_vector(31 downto 0); --result from aritm instr or pc+1 if JSR instr
	pc_jmp_value : in std_logic_vector(31 downto 0); --value that should be put into pc (jumps)

	prediction : in std_logic;
		
	--iz kesa
	fetch_data_from_cache : in std_logic_vector(31 downto 0);
	
	get_data_from_data_cache : out std_logic;
	write_data_to_cache : out std_logic;
	cache_data_in : out std_logic_vector(31 downto 0);
	cache_address_in : out std_logic_vector(31 downto 0);
	pc_jmp_value_out : out std_logic_vector(31 downto 0);
	mem_data_out : out std_logic_vector(31 downto 0);
	
	rd_out : out std_logic_vector(4 downto 0);
	has_DR_out : out std_logic;
	flush_out : out std_logic;
	
	misspred : out std_logic
);

end memory;

architecture memory_arch of memory is

begin

	get_data_from_data_cache <= '1' when MEM_RD = '1' else '0';

	write_data_to_cache <= '1' when MEM_WR = '1' and flush = '0' else '0';
	cache_address_in <= address;
	cache_data_in <= result;
	
	--uzeo data iz mem ili hasDR
	mem_data_out <= fetch_data_from_cache when MEM_RD = '1' else result;
	
	--if prediction is okay or else ...
	pc_jmp_value_out <= pc_jmp_value when jmp_is_ok = '1' else pc_plus;
	--ako smo omasili predikciju (default predikcija je '0')
	misspred <= '1' when not (jmp_is_ok = prediction) and COND_type = '1' else '0';
	
	rd_out <= RD;
	HAS_DR_out <= HAS_DR;
	flush_out <= flush;
	
end memory_arch;
