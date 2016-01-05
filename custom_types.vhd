library ieee;
use ieee.std_logic_1164.all;

package custom_types is

	type array_of_reg is array(0 to 31) of std_logic_vector(31 downto 0);
	type array_of_reg8 is array(0 to 7) of std_logic_vector(31 downto 0);
	type array_of_reg4 is array(0 to 3) of std_logic_vector(31 downto 0);
	type array_of_reg2 is array(0 to 1) of std_logic_vector(31 downto 0);
	
	type branch_predictor_entry is record
		v : std_logic;
		pc_value  : std_logic_vector(31 downto 0);
		prediction_value : std_logic_vector(1 downto 0);
		jump_address : std_logic_vector(31 downto 0);
	end record branch_predictor_entry;
	type array_of_branch_entries is array (0 to 31) of branch_predictor_entry;
	
	type stick_structIF_ID is record
		stall : std_logic;
		flush : std_logic;

		--izlazi IF faze
		IF_pc : std_logic_vector(31 downto 0);
		IF_pc_plus : std_logic_vector(31 downto 0);
		IF_is_prediction_entry_found : std_logic;
		IF_prediction : std_logic;
		IF_prediction_address : std_logic_vector(31 downto 0);
		IF_instr_value : std_logic_vector(31 downto 0);
		
	end record stick_structIF_ID;
	
	type stick_structID_EXE is record
		stall : std_logic;
		flush : std_logic;
		--izlazi ID faze
		--preneseni
		ID_is_prediction_entry_found : std_logic;
		ID_prediction : std_logic;
		ID_prediction_address : std_logic_vector(31 downto 0);
		ID_pc : std_logic_vector(31 downto 0);
		ID_pc_plus : std_logic_vector(31 downto 0);
		ID_instr_value : std_logic_vector(31 downto 0);
		--generisani	
		ID_dstvalid_EX : std_logic;
		ID_dstvalid_MEM : std_logic;
		ID_dst : std_logic_vector(4 downto 0);
		ID_src1 : std_logic_vector(4 downto 0);
		ID_RSRC1 : std_logic_vector(31 downto 0);
		ID_src2 : std_logic_vector(4 downto 0);
		ID_RSRC2 : std_logic_vector(31 downto 0);
		ID_IMM : std_logic_vector(31 downto 0);
		ID_ocerror : std_logic;
		ID_RS_IM_type : std_logic;
		ID_MOV_type : std_logic;
		ID_JMP_inst : std_logic;
		ID_COND_type : std_logic;
		ID_RTS_type : std_logic;
		ID_JSR_inst : std_logic;
		ID_PUSH_inst : std_logic;
		ID_POP_inst : std_logic;
		ID_LOAD_inst : std_logic;
		ID_STORE_inst : std_logic;
		ID_MEM_WR : std_logic;
		ID_MEM_RD : std_logic;
		ID_has_DR : std_logic;
		ID_stall_MEM : std_logic;
	end record stick_structID_EXE;
	
	type stick_structEXE_MEM is record
		stall : std_logic;
		flush : std_logic;

		--izlazi EX faze
		--preneseni
		EX_is_prediction_entry_found : std_logic;
		EX_prediction : std_logic;
		EX_prediction_address : std_logic_vector(31 downto 0);
		EX_pc : std_logic_vector(31 downto 0);
		EX_pc_plus : std_logic_vector(31 downto 0);
		EX_instr_value : std_logic_vector(31 downto 0);
		EX_dstvalid_MEM : std_logic;
		EX_dst_valid : std_logic;
		EX_RD : std_logic_vector(4 downto 0);
		EX_MOV_type : std_logic;
		EX_JMP_type : std_logic;
		EX_COND_type : std_logic;
		EX_RTS_type : std_logic;
		EX_JSR_inst : std_logic;
		EX_PUSH_inst : std_logic;
		EX_POP_inst : std_logic;
		EX_LOAD_inst : std_logic;
		EX_STORE_inst : std_logic;
		EX_MEM_WR : std_logic;
		EX_MEM_RD : std_logic;
		EX_has_DR : std_logic;
		EX_stall_ID_MEM : std_logic;
		--generisani
		EX_jmp_is_ok : std_logic;
		EX_address : std_logic_vector(31 downto 0); --jmp address
		EX_result : std_logic_vector(31 downto 0); --result from aritm instr
		EX_pc_jmp_value : std_logic_vector(31 downto 0); --value that should be put into pc (jumps)

		EX_stack_error : std_logic;
		EX_bad_address : std_logic;
		
	end record stick_structEXE_MEM;
	
	type stick_structMEM_WB is record
		stall : std_logic;
		flush : std_logic;

		--izlazi mem faze
		get_data_from_data_cache : std_logic;
		write_data_to_cache : std_logic;
		cache_data_in : std_logic_vector(31 downto 0);
		cache_address_in : std_logic_vector(31 downto 0);
		pc_jmp_value_out : std_logic_vector(31 downto 0);
		mem_data_out : std_logic_vector(31 downto 0);
		rd_out : std_logic_vector(4 downto 0);
		has_DR_out : std_logic;
		misspred : std_logic;
		
	end record stick_structMEM_WB;

end package custom_types;