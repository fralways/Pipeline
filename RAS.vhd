library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAS is

port
(
	clk : in std_logic;
	reset : in std_logic;
	ID_RTS_inst : in std_logic;
	EX_JSR_inst : in std_logic;
	EX_pc : in std_logic_vector(31 downto 0);
	MEM_RTS_inst : in std_logic;
	MEM_result : in std_logic_vector(31 downto 0);
	
	RAS_ramiss : out std_logic;
	RAS_retPC_out : out std_logic_vector(31 downto 0);
	ret_adr_exist : out std_logic
);

end RAS;

architecture RAS_arch of RAS is

component RAS_reg_file is

port
(
	clk : in std_logic;
	reset : in std_logic;
	wr : in std_logic;
	dst : in std_logic_vector(2 downto 0);
	src : in std_logic_vector(2 downto 0);
	data_in : in std_logic_vector(31 downto 0);
	
	data_out : out std_logic_vector(31 downto 0)
);

end component;

component RAS_SPreg is

port
(
	clk : in std_logic;
	inc : in std_logic;
	dec : in std_logic;
	reset : in std_logic;
		
	data_out : out std_logic_vector(2 downto 0)
);

end component;

component RAS_CLC is

port
(
	clk : in std_logic;
	inc : in std_logic;
	dec : in std_logic;
	reset : in std_logic;
		
	data_out : out std_logic_vector(2 downto 0)
);

end component;

signal reset_all : std_logic;
signal pop_adr : std_logic;
signal push_adr : std_logic;
signal push_up : std_logic;
signal stack_error : std_logic;
signal empty_stack : std_logic;
signal CLCount : std_logic_vector(2 downto 0);
signal SPCount : std_logic_vector(2 downto 0);
signal next_adr : std_logic_vector(2 downto 0);
signal pred_pc : std_logic_vector(31 downto 0);

begin

	--stek cuva najblizih osam nivoa ugnjezdavanja pozvanih funkcija.
	--ugradjena je i detekcija greske (nekonzistentnost sa stvarnom vrednoscu sa steka) i generisanje signala koji
	--treba da omoguce oporavak. U slucaju pogresne adrese ne usporava rad procesora, u slucaju ispravne
	--ubrzava ga za dva takta

	--CLC - call level counter, broji nivo ugnjezdenosti/broj upotrebljenih ulaza u steku
	CLC : RAS_CLC port map (clk, push_up, pop_adr, reset_all, CLCount);
	
	--SP - Stack Pointer, pokazivac na vrh steka
	SP : RAS_SPreg port map (clk, push_adr, pop_adr, reset_all, SPCount);
	
	next_adr <= std_logic_vector(unsigned(SPCount)+1);
	
	--registarski fajl koji simulira stek memoriju
	stek : RAS_reg_file port map (clk, reset_all, push_adr, next_adr, SPCount, EX_pc, pred_pc);
	empty_stack <= '1' when CLCount = "000" else '0';
	stack_error <= '1' when MEM_RTS_inst = '1' and not (pred_pc=MEM_result) else '0';
	reset_all <= '1' when reset = '1' or stack_error = '1' else '0';
	pop_adr <= '1' when MEM_RTS_inst = '1' and pred_pc=MEM_result and empty_stack = '0' else '0';
	push_adr <= EX_JSR_inst;
	push_up <= '1' when EX_JSR_inst = '1' and not (CLCount = "111") else '0';
	ret_adr_exist <= '1' when ID_RTS_inst = '1' and empty_stack = '0' else '0';
	
	RAS_ramiss <= stack_error;
	RAS_retPC_out <= pred_pc;
	
end RAS_arch;