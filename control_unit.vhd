library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.custom_types.all;

entity control_unit is
port
(
	clk : in std_logic;
	reset : in std_logic;
	
	--signali za stek povratnih adresa
	ID_RTS_inst : in std_logic;
	ID_JSR_inst : in std_logic;
	EX_JSR_inst : in std_logic;
	EX_pc : in std_logic_vector(31 downto 0);
	MEM_RTS_inst : in std_logic;
	MEM_result : in std_logic_vector(31 downto 0);
	
	--signali za skok i predikciju skoka
	IF_is_prediction_entry_found : in std_logic;
	IF_prediction : in std_logic;
	ID_is_prediction_entry_found : in std_logic;
	ID_COND_type : in std_logic;
	
	--sigali gresaka
	ID_ocerror : in std_logic;
	EX_stack_error : in std_logic;
	EX_bad_address : in std_logic;
	
	--predvidjeni signali za forwarding i stalling
	
	ID_EX_src1 : in std_logic_vector(4 downto 0);
	ID_EX_src2 : in std_logic_vector(4 downto 0);
	ID_EX_has_SR1 : in std_logic;
	ID_EX_has_SR2 : in std_logic;
	MEM_dst : in std_logic_vector(4 downto 0);
	MEM_has_DR : in std_logic;
	MEM_dst_valid : in std_logic;
	WB_dst : in std_logic_vector(4 downto 0);
	WB_has_DR : in std_logic;
	MEM_misspred : in std_logic;

	fwd_WB_EX1 : out std_logic;
	fwd_WB_EX2 : out std_logic;
	fwd_MEM_EX1 : out std_logic;
	fwd_MEM_EX2 : out std_logic;
	
	stall_PC : out std_logic;
	stall_IF_ID : out std_logic;
	
	flush_IF : out std_logic;
	flush_ID : out std_logic;
	flush_EX : out std_logic;

	RAS_retPC_out : out std_logic_vector(31 downto 0);
	pc_jumping : out std_logic
	
);
end control_unit;

architecture control_unit_arch of control_unit is

component RAS is

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

end component;
	signal RAS_misspred : std_logic;
	signal ret_adr_exist : std_logic;
	signal stall_temp : std_logic;
begin
	--instrukcija koja nije bila u kesu predikcije
	
	pc_jumping <= '1' when (IF_is_prediction_entry_found = '1' and IF_prediction = '1') or (RAS_misspred = '1') or
					(RAS_misspred = '0' and ret_adr_exist = '1') else '0';
		
	--forwarding logika
	fwd_MEM_EX1 <= '1' when ID_EX_has_SR1 = '1' and MEM_has_DR = '1' and MEM_dst_valid = '1' and to_integer(unsigned(ID_EX_src1)) = to_integer(unsigned(MEM_dst)) else '0';
	fwd_MEM_EX2 <= '1' when ID_EX_has_SR2 = '1' and MEM_has_DR = '1' and MEM_dst_valid = '1' and to_integer(unsigned(ID_EX_src2)) = to_integer(unsigned(MEM_dst)) else '0';
	
	fwd_WB_EX1 <= '1' when WB_has_DR = '1' and to_integer(unsigned(ID_EX_src1)) = to_integer(unsigned(WB_dst)) else '0';
	fwd_WB_EX2 <= '1' when WB_has_DR = '1' and to_integer(unsigned(ID_EX_src2)) = to_integer(unsigned(WB_dst)) else '0';--	
	
	flush_IF <= '1' when MEM_misspred = '1' or RAS_misspred = '1' or stall_temp = '1' else '0';
	flush_ID <= '1' when MEM_misspred = '1' or RAS_misspred = '1' else '0';
	flush_EX <= '1' when MEM_misspred = '1' or RAS_misspred = '1' else '0';
	
	stall_temp <= '1' when ID_RTS_inst = '1' or ID_JSR_inst = '1' else '0';
	stall_PC <= stall_temp;

	--RAS - Return Adress Stack, stek povratnih adresa
	RASunit : RAS port map (clk, reset, ID_RTS_inst, EX_JSR_inst, EX_pc, MEM_RTS_inst, MEM_result, RAS_misspred, RAS_retPC_out, ret_adr_exist);
	--morace jos neki signal da postoji da bi davao informaciju o tome sta je izazvalo potrebu za skokom
--	
end control_unit_arch;
