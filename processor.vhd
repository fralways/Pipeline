library ieee;
use ieee.std_logic_1164.all;
use work.custom_types.all;

entity processor is
port
(
	clk : in std_logic;
	reset : in std_logic
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

component MX_4_1
port
(
	cs : in std_logic_vector(1 downto 0);
	data_in : in array_of_reg4;
	
	data_out : out std_logic_vector(31 downto 0)

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

component stick is
port
(
	clk : in std_logic;
	signals_in : in stick_structIF_ID;
	signals_out : out stick_structIF_ID
);
end component;

component stick_ID_EXE is
port
(
	clk : in std_logic;
	signals_in : in stick_structID_EXE;
	signals_out : out stick_structID_EXE
);
end component;

component stick_EXE_MEM is
port
(
	clk : in std_logic;
	signals_in : in stick_structEXE_MEM;
	signals_out : out stick_structEXE_MEM
);
end component;

component stick_MEM_WB is
port
(
	clk : in std_logic;
	signals_in : in stick_structMEM_WB;
	signals_out : out stick_structMEM_WB
);
end component;

component control_unit is
port
(
	IF_is_prediction_entry_found : in std_logic;
	IF_prediction : in std_logic;
	
	pc_jumping : out std_logic
);
end component;

component decode is
port
(
	--za sad je u redu
	flush : in std_logic;
	IF_pc : in std_logic_vector(31 downto 0);
	IF_pc_plus : in std_logic_vector(31 downto 0);
	IF_is_prediction_entry_found : in std_logic;
	IF_prediction : in std_logic;
	IF_prediction_address : in std_logic_vector(31 downto 0);
	IF_stall : in std_logic;
	IF_flush : in std_logic;
	IF_instr_value : in std_logic_vector(31 downto 0);
	WB_rdst : in std_logic_vector(4 downto 0);
	WB_data : in std_logic_vector(31 downto 0);
	WB_write : in std_logic;
	clk : in std_logic;
	reset : in std_logic;
	
	is_prediction_entry_found : out std_logic;
	prediction : out std_logic;
	prediction_address : out std_logic_vector(31 downto 0);
	instr_value : out std_logic_vector(31 downto 0);
	dst : out std_logic_vector(4 downto 0);
	src1 : out std_logic_vector(4 downto 0);
	RSRC1 : out std_logic_vector(31 downto 0);
	src2 : out std_logic_vector(4 downto 0);
	RSRC2 : out std_logic_vector(31 downto 0);
	IMM : out std_logic_vector(31 downto 0);
	stall : out std_logic;
	flush_out : out std_logic;
	ocerror : out std_logic;
	pc : out std_logic_vector(31 downto 0);
	pc_plus : out std_logic_vector(31 downto 0);
	
	dstvalid_EX : out std_logic;
	dstvalid_MEM : out std_logic;
	RS_IM_type : out std_logic;
	MOV_type : out std_logic;
	JMP_inst : out std_logic;
	COND_type : out std_logic;
	RTS_type : out std_logic;
	JSR_inst : out std_logic;
	PUSH_inst : out std_logic;
	POP_inst : out std_logic;
	LOAD_inst : out std_logic;
	STORE_inst : out std_logic;
	MEM_WR : out std_logic;
	MEM_RD : out std_logic;
	has_DR : out std_logic;
	has_SR1 : out std_logic;
	has_SR2 : out std_logic
	
);
end component;

component execute is

port
(
	clk : in std_logic;
	reset : in std_logic;
	PC : in std_logic_vector(31 downto 0);
	PC_plus : in std_logic_vector(31 downto 0);
	RS1 : in std_logic_vector(31 downto 0);
	RS2 : in std_logic_vector(31 downto 0);
	RD : in std_logic_vector(4 downto 0);
	IMM : in std_logic_vector(31 downto 0);
	fwd_MEM_A : in std_logic;
	fwd_MEM_B : in std_logic;
	fwd_WB_A : in std_logic;
	fwd_WB_B : in std_logic;
	forward_A_MEM : in std_logic_vector(31 downto 0);
	forward_B_MEM : in std_logic_vector(31 downto 0);
	forward_A_WB : in std_logic_vector(31 downto 0);
	forward_B_WB : in std_logic_vector(31 downto 0);
	
	dstvalid_EX : in std_logic;
	dstvalid_MEM : in std_logic;
	RS_IMM_type : in std_logic;
	MOV_type : in std_logic;
	JMP_type : in std_logic;
	COND_type : in std_logic;
	STACK_PUSH_type : in std_logic;
	STACK_POP_type : in std_logic;
	LOAD_type : in std_logic;
	STORE_type : in std_logic;
	RTS_type : in std_logic;
	JSR_type : in std_logic;
	is_prediction_entry_found : in std_logic;
	prediction : in std_logic;
	
	MEM_RD : in std_logic;
	MEM_WR : in std_logic;
	HAS_DR : in std_logic;
	
	stall_ID_MEM : in std_logic;
	ID_flush : in std_logic;
	flush : in std_logic;
	
	MOV_type_out : out std_logic;
	JMP_type_out : out std_logic;
	COND_type_out : out std_logic;
	jmp_is_ok : out std_logic;
	STACK_PUSH_type_out : out std_logic;
	STACK_POP_type_out : out std_logic;
	LOAD_type_out : out std_logic;
	STORE_type_out : out std_logic;
	RTS_type_out : out std_logic;
	JSR_type_out : out std_logic;
	RD_out : out std_logic_vector(4 downto 0);
	
	dst_valid : out std_logic;
	dstvalid_MEM_out  : out std_logic;
	MEM_RD_out : out std_logic;
	MEM_WR_out : out std_logic;
	HAS_DR_out : out std_logic;
	pc_plus_out : out std_logic_vector(31 downto 0);

	
	address : out std_logic_vector(31 downto 0); --memory address
	result : out std_logic_vector(31 downto 0); --result from aritm instr
	pc_jmp_value : out std_logic_vector(31 downto 0); --value that should be put into pc (jumps)
	stack_error : out std_logic;
	bad_address : out std_logic;
	
	is_prediction_entry_found_out : out std_logic;
	prediction_out : out std_logic;
	
	stall_ID_MEM_out : out std_logic;
	flush_out : out std_logic
);
end component;

component memory is

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

end component;

signal PC_load, PC_inc : std_logic;
signal PC_data_in, PC_data_out : std_logic_vector(31 downto 0);
signal CACHE_rd_instr, CACHE_rd_data, CACHE_wr : std_logic;
signal CACHE_address_in, CACHE_data_in, CACHE_data_out : std_logic_vector(31 downto 0);
signal FETCH_update_entry, FETCH_prediction_was_success, FETCH_is_prediction_entry_found, FETCH_prediction : std_logic;
signal FETCH_update_entry_pc, FETCH_update_entry_jmp_address, FETCH_pc_out, FETCH_pc_plus, FETCH_prediction_address : std_logic_vector(31 downto 0);
signal CU_PC_jumping, CU_stall_ID_MEM, CU_flash_IF, CU_flash_ID, CU_flash_EX : std_logic;
signal PC_MUX_CS : std_logic_vector(1 downto 0);
signal PC_MUX_IN : array_of_reg4;

--sticks
signal IF_ID_signal_in, IF_ID_signal_out : stick_structIF_ID;
signal ID_EXE_signal_in, ID_EXE_signal_out : stick_structID_EXE;
signal EXE_MEM_signal_in, EXE_MEM_signal_out : stick_structEXE_MEM;
signal MEM_WB_signal_in, MEM_WB_signal_out : stick_structMEM_WB;

--decode
signal ID_WB_write, ID_is_prediction_entry_found, ID_prediction, ID_stall, ID_ocerror, ID_dstvalid_EX, ID_dstvalid_MEM, 
			ID_RS_IM_type, ID_MOV_type, ID_JMP_inst, ID_COND_type, ID_RTS_type, ID_JSR_inst, ID_PUSH_inst, ID_POP_inst, 
			ID_LOAD_inst, ID_STORE_inst, ID_MEM_WR, ID_MEM_RD, ID_has_DR, ID_has_SR1, ID_has_SR2, ID_flush : std_logic;

signal ID_WB_data, ID_prediction_address, ID_RSRC1, ID_RSRC2, ID_IMM, ID_pc, ID_pc_plus, ID_instr_value : std_logic_vector(31 downto 0);
signal ID_WB_rdst, ID_dst, ID_src1, ID_src2 : std_logic_vector(4 downto 0);

--execute
signal fwd_MEM_A, fwd_MEM_B, fwd_WB_A, fwd_WB_B : std_logic;
signal forward_A_MEM, forward_B_MEM, forward_A_WB, forward_B_WB : std_logic_vector(31 downto 0);
signal EXE_MOV_type, EXE_JMP_type, EXE_COND_type, EXE_jmp_is_ok, EXE_PUSH_type, EXE_POP_type, EXE_LOAD_type, 
			EXE_STORE_type, EXE_RTS_type, EXE_JSR_type : std_logic;
signal EXE_RD : std_logic_vector(4 downto 0);
signal EXE_is_prediction_entry_found, EXE_prediction : std_logic;
signal EXE_dst_valid, EXE_dstvalid_MEM, EXE_MEM_RD, EXE_MEM_WR, EXE_HAS_DR : std_logic;
signal EXE_address, EXE_result, EXE_pc_jmp_value, EXE_pc_plus : std_logic_vector(31 downto 0);
signal EXE_stack_error, EXE_bad_address : std_logic;
signal EXE_stall_ID_MEM, EXE_flush : std_logic;

--memory
signal MEM_stall, MEM_flush : std_logic;
signal MEM_get_data_from_data_cache, MEM_write_data_to_cache, MEM_has_DR_out, MEM_misspred : std_logic;
signal MEM_cache_data_in, MEM_cache_address_in, MEM_pc_jmp_value_out, MEM_mem_data_out : std_logic_vector(31 downto 0);
signal MEM_rd_out : std_logic_vector(4 downto 0);
	
begin
	
	--IF/ID stick
	
	IF_ID_signal_in <= (
											IF_pc => FETCH_pc_out,
											IF_pc_plus => FETCH_pc_plus,
											IF_is_prediction_entry_found => FETCH_is_prediction_entry_found,
											IF_prediction => FETCH_prediction,
											IF_prediction_address => FETCH_prediction_address,
											stall => '0',
											flush => '0',
											IF_instr_value => CACHE_data_out
											
	);
	
	--ID/EXE stick
	
	ID_EXE_signal_in <= (
											stall => ID_stall,
											flush => ID_flush,
											ID_is_prediction_entry_found => ID_is_prediction_entry_found, 
											ID_prediction => ID_prediction,
											ID_prediction_address => ID_prediction_address,
											ID_pc => ID_pc,
											ID_pc_plus => ID_pc_plus,
											ID_instr_value => ID_instr_value,
											--generisani	
											ID_dstvalid_EX => ID_dstvalid_EX,
											ID_dstvalid_MEM => ID_dstvalid_MEM,
											ID_dst => ID_dst,
											ID_src1 => ID_src1,
											ID_RSRC1 => ID_RSRC1,
											ID_src2 => ID_src2,
											ID_RSRC2 => ID_RSRC2,
											ID_IMM => ID_IMM,
											ID_ocerror => ID_ocerror,
											ID_RS_IM_type => ID_RS_IM_type,
											ID_MOV_type => ID_MOV_type,
											ID_JMP_inst => ID_JMP_inst,
											ID_COND_type => ID_COND_type,
											ID_RTS_type => ID_RTS_type,
											ID_JSR_inst => ID_JSR_inst,
											ID_PUSH_inst => ID_PUSH_inst,
											ID_POP_inst => ID_POP_inst,
											ID_LOAD_inst => ID_LOAD_inst,
											ID_STORE_inst => ID_STORE_inst,
											ID_MEM_WR => ID_MEM_WR,
											ID_MEM_RD => ID_MEM_RD,
											ID_has_DR => ID_has_DR,
											ID_stall_MEM => CU_stall_ID_MEM
	);
	
	--EX/MEM stick
	
	EXE_MEM_signal_in <= (
											stall => '0',
											flush => EXE_flush,
											EX_prediction_address => ID_prediction_address,
											EX_pc => ID_pc,
											EX_pc_plus => EXE_pc_plus,
											EX_instr_value => ID_instr_value,  
											EX_dstvalid_MEM => EXE_dstvalid_MEM,
											EX_dst_valid => EXE_dst_valid,
											EX_RD => EXE_RD,
											EX_MOV_type => EXE_MOV_type,
											EX_JMP_type => EXE_JMP_type,
											EX_COND_type => EXE_COND_type,
											EX_RTS_type => EXE_RTS_type,
											EX_JSR_inst => EXE_JSR_type,
											EX_is_prediction_entry_found => EXE_is_prediction_entry_found,
											EX_prediction => EXE_prediction,
											EX_PUSH_inst => EXE_PUSH_type,
											EX_POP_inst => EXE_POP_type,
											EX_LOAD_inst => EXE_LOAD_type,
											EX_STORE_inst => EXE_STORE_type,
											EX_MEM_WR => EXE_MEM_WR,
											EX_MEM_RD => EXE_MEM_RD,
											EX_has_DR => EXE_has_DR,
											EX_stall_ID_MEM => EXE_stall_ID_MEM,
											EX_jmp_is_ok => EXE_jmp_is_ok,
											EX_address => EXE_address,
											EX_result => EXE_result,
											EX_pc_jmp_value=> EXE_pc_jmp_value,
											EX_stack_error => EXE_stack_error,
											EX_bad_address => EXE_bad_address
											
	);
	
	--MEM/WB stick
	MEM_WB_signal_in <= (
											stall => '0',
											flush => MEM_flush,
											get_data_from_data_cache => MEM_get_data_from_data_cache,
											write_data_to_cache => MEM_write_data_to_cache,
											cache_data_in => MEM_cache_data_in,
											cache_address_in => MEM_cache_address_in,
											pc_jmp_value_out => MEM_pc_jmp_value_out,
											mem_data_out => MEM_mem_data_out,
											rd_out => MEM_rd_out,
											has_DR_out => MEM_has_DR_out,
											misspred => MEM_misspred
									
	);
											
	PC_load <= '1' when reset = '1' or CU_PC_jumping = '1' else '0';
	PC_inc <= '1' when PC_load = '0' else '0';
	CACHE_address_in <= PC_data_out;
	CACHE_rd_instr <= '1';
	PC_MUX_IN <= (0 => (others => '0'), 1 => FETCH_prediction_address, 2 => MEM_pc_jmp_value_out, 3 => CACHE_data_out);
	--PC_MUX_CS <= "11" when reset = '1' else "01" when CU_PC_jumping = '1' else "10" when MEM_misspred = '1' else "00";
	PC_MUX_CS <= (0 => reset or CU_PC_jumping, 1 => reset or MEM_misspred);

	PC_MUX : MX_4_1 port map ( PC_MUX_CS, PC_MUX_IN, PC_data_in);
	
	CACHE_ENTITY : Cache port map (clk, CACHE_rd_instr, CACHE_rd_data, CACHE_wr, CACHE_address_in, CACHE_data_in, CACHE_data_out);
	PC_REG : PCreg port map (clk, PC_load, PC_inc, '0', PC_data_in, PC_data_out);
	FETCH_PHASE : fetch port map (clk, reset, PC_data_out, FETCH_update_entry, FETCH_prediction_was_success, FETCH_update_entry_pc, FETCH_update_entry_jmp_address,
														FETCH_pc_out, FETCH_pc_plus, FETCH_is_prediction_entry_found, FETCH_prediction, FETCH_prediction_address);
	IF_ID_stick : stick port map (
											clk => clk,
											signals_in => IF_ID_signal_in,
											signals_out => IF_ID_signal_out	
	);
	
	CU : control_unit port map (FETCH_is_prediction_entry_found, FETCH_prediction, CU_PC_jumping);
	
	--WB_rdst, WB_data, WB_write ??
	DECODE_PHASE : decode port map (CU_flash_ID, IF_ID_signal_out.IF_pc, IF_ID_signal_out.IF_pc_plus, IF_ID_signal_out.IF_is_prediction_entry_found, 
										IF_ID_signal_out.IF_prediction, IF_ID_signal_out.IF_prediction_address, IF_ID_signal_out.stall, IF_ID_signal_out.flush, 
										IF_ID_signal_out.IF_instr_value, ID_WB_rdst, ID_WB_data, ID_WB_write, clk, reset, 
										ID_is_prediction_entry_found, ID_prediction, ID_prediction_address, ID_instr_value, ID_dst, ID_src1, ID_RSRC1, ID_src2, ID_RSRC2, 
										ID_IMM, ID_stall, ID_flush, ID_ocerror, ID_pc, ID_pc_plus, ID_dstvalid_EX, ID_dstvalid_MEM, ID_RS_IM_type, ID_MOV_type, ID_JMP_inst, 
										ID_COND_type, ID_RTS_type, ID_JSR_inst, ID_PUSH_inst, ID_POP_inst, ID_LOAD_inst, ID_STORE_inst, ID_MEM_WR, ID_MEM_RD, 
										ID_has_DR, ID_has_SR1, ID_has_SR2);
										
	ID_EXE_stick : stick_ID_EXE port map (
											clk => clk,
											signals_in => ID_EXE_signal_in,
											signals_out => ID_EXE_signal_out
											);
	EXECUTE_PHASE : execute port map (clk, reset, ID_EXE_signal_out.ID_pc, ID_EXE_signal_out.ID_pc_plus, ID_EXE_signal_out.ID_RSRC1, ID_EXE_signal_out.ID_RSRC2,
													ID_dst, ID_IMM, fwd_MEM_A, fwd_MEM_B, fwd_WB_A, fwd_WB_B, forward_A_MEM, forward_B_MEM, forward_A_WB, forward_B_WB,
													ID_EXE_signal_out.ID_dstvalid_EX, ID_EXE_signal_out.ID_dstvalid_MEM, ID_EXE_signal_out.ID_RS_IM_type, 
													ID_EXE_signal_out.ID_MOV_type, ID_EXE_signal_out.ID_JMP_inst, ID_EXE_signal_out.ID_COND_type, ID_EXE_signal_out.ID_PUSH_inst,
													ID_EXE_signal_out.ID_POP_inst, ID_EXE_signal_out.ID_LOAD_inst, ID_EXE_signal_out.ID_STORE_inst, 
													ID_EXE_signal_out.ID_RTS_type, ID_EXE_signal_out.ID_JSR_inst, ID_EXE_signal_out.ID_is_prediction_entry_found,
													ID_EXE_signal_out.ID_prediction, ID_EXE_signal_out.ID_MEM_RD, ID_EXE_signal_out.ID_MEM_WR, 
													ID_EXE_signal_out.ID_HAS_DR, ID_EXE_signal_out.ID_stall_MEM, CU_flash_EX, ID_EXE_signal_out.flush, EXE_MOV_type, EXE_JMP_type, EXE_COND_type, EXE_jmp_is_ok, EXE_PUSH_type,
													EXE_POP_type, EXE_LOAD_type, EXE_STORE_type, EXE_RTS_type, EXE_JSR_type, EXE_RD, 
													EXE_dst_valid, EXE_dstvalid_MEM, EXE_MEM_RD, EXE_MEM_WR, EXE_HAS_DR, EXE_pc_plus, EXE_address, EXE_result, 
													EXE_pc_jmp_value, EXE_stack_error, EXE_bad_address, EXE_is_prediction_entry_found, EXE_prediction, EXE_stall_ID_MEM, EXE_flush);
	EXE_MEM_stick : stick_EXE_MEM port map (
											clk => clk,
											signals_in => EXE_MEM_signal_in,
											signals_out => EXE_MEM_signal_out
	);
	MEMORY_PHASE : memory port map (EXE_MEM_signal_out.flush, EXE_MEM_signal_out.EX_COND_type, EXE_MEM_signal_out.EX_jmp_is_ok, EXE_MEM_signal_out.EX_RD, 
												EXE_MEM_signal_out.EX_MEM_RD, EXE_MEM_signal_out.EX_MEM_WR, EXE_MEM_signal_out.EX_HAS_DR, EXE_MEM_signal_out.EX_pc_plus,
												EXE_MEM_signal_out.EX_address, EXE_MEM_signal_out.EX_result, EXE_MEM_signal_out.EX_pc_jmp_value, EXE_MEM_signal_out.EX_prediction,
												CACHE_data_out, MEM_get_data_from_data_cache, MEM_write_data_to_cache, MEM_cache_data_in, MEM_cache_address_in, 
												MEM_pc_jmp_value_out, MEM_mem_data_out, MEM_rd_out, MEM_has_DR_out, MEM_flush, MEM_misspred);
												
	MEM_WB_stick : stick_MEM_WB port map (
											clk => clk,
											signals_in => MEM_WB_signal_in,
											signals_out => MEM_WB_signal_out
	);
	--MEM_WB_signal_out.has_DR_out = '1' and MEM_WB_signal_out.flush = '0' + josh nesto mozda => upisi u reg
end processor_arch;