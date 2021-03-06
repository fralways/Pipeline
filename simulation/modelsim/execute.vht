 -- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "12/26/2015 16:10:53"
                                                            
-- Vhdl Test Bench template for design  :  execute
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY execute_vhd_tst IS
END execute_vhd_tst;
ARCHITECTURE execute_arch OF execute_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL address : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL pc_jmp_value : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL forward_A_MEM : std_logic_vector(31 downto 0);
SIGNAL forward_B_MEM : std_logic_vector(31 downto 0);
SIGNAL forward_A_WB : std_logic_vector(31 downto 0);
SIGNAL forward_B_WB : std_logic_vector(31 downto 0);
SIGNAL fwd_MEM_A : std_logic;
SIGNAL fwd_MEM_B : std_logic;
SIGNAL fwd_WB_A : std_logic;
SIGNAL fwd_WB_B : std_logic;
SIGNAL bad_address : STD_LOGIC;
SIGNAL clk : STD_LOGIC;
SIGNAL COND_type : STD_LOGIC;
SIGNAL COND_type_out : STD_LOGIC;
SIGNAL dst_valid : STD_LOGIC;
SIGNAL dstvalid_EX : STD_LOGIC;
SIGNAL dstvalid_MEM : STD_LOGIC;
SIGNAL dstvalid_MEM_out : STD_LOGIC;
SIGNAL HAS_DR : STD_LOGIC;
SIGNAL HAS_DR_out : STD_LOGIC;
SIGNAL IMM : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL jmp_is_ok : STD_LOGIC;
SIGNAL JMP_type : STD_LOGIC;
SIGNAL JMP_type_out : STD_LOGIC;
SIGNAL JSR_type : STD_LOGIC;
SIGNAL JSR_type_out : STD_LOGIC;
SIGNAL LOAD_type : STD_LOGIC;
SIGNAL LOAD_type_out : STD_LOGIC;
SIGNAL MEM_RD : STD_LOGIC;
SIGNAL MEM_RD_out : STD_LOGIC;
SIGNAL MEM_WR : STD_LOGIC;
SIGNAL MEM_WR_out : STD_LOGIC;
SIGNAL MOV_type : STD_LOGIC;
SIGNAL MOV_type_out : STD_LOGIC;
SIGNAL PC : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL PC_plus : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RD : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL RD_out : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL result : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RS1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RS2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL RS_IMM_type : STD_LOGIC;
SIGNAL RTS_type : STD_LOGIC;
SIGNAL RTS_type_out : STD_LOGIC;
SIGNAL stack_error : STD_LOGIC;
SIGNAL STACK_POP_type : STD_LOGIC;
SIGNAL STACK_POP_type_out : STD_LOGIC;
SIGNAL STACK_PUSH_type : STD_LOGIC;
SIGNAL STACK_PUSH_type_out : STD_LOGIC;
SIGNAL STORE_type : STD_LOGIC;
SIGNAL STORE_type_out : STD_LOGIC;
COMPONENT execute
	PORT (
	forward_A_MEM : in std_logic_vector(31 downto 0);
	forward_B_MEM : in std_logic_vector(31 downto 0);
	forward_A_WB : in std_logic_vector(31 downto 0);
	forward_B_WB : in std_logic_vector(31 downto 0);
	fwd_MEM_A : in std_logic;
	fwd_MEM_B : in std_logic;
	fwd_WB_A : in std_logic;
	fwd_WB_B : in std_logic;
	address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	pc_jmp_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	bad_address : OUT STD_LOGIC;
	clk : IN STD_LOGIC;
	COND_type : IN STD_LOGIC;
	COND_type_out : OUT STD_LOGIC;
	dst_valid : OUT STD_LOGIC;
	dstvalid_EX : IN STD_LOGIC;
	dstvalid_MEM : IN STD_LOGIC;
	dstvalid_MEM_out : OUT STD_LOGIC;
	HAS_DR : IN STD_LOGIC;
	HAS_DR_out : OUT STD_LOGIC;
	IMM : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	jmp_is_ok : OUT STD_LOGIC;
	JMP_type : IN STD_LOGIC;
	JMP_type_out : OUT STD_LOGIC;
	JSR_type : IN STD_LOGIC;
	JSR_type_out : OUT STD_LOGIC;
	LOAD_type : IN STD_LOGIC;
	LOAD_type_out : OUT STD_LOGIC;
	MEM_RD : IN STD_LOGIC;
	MEM_RD_out : OUT STD_LOGIC;
	MEM_WR : IN STD_LOGIC;
	MEM_WR_out : OUT STD_LOGIC;
	MOV_type : IN STD_LOGIC;
	MOV_type_out : OUT STD_LOGIC;
	PC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	PC_plus : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	RD : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	RD_out : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
	reset : IN STD_LOGIC;
	result : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	RS1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	RS2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	RS_IMM_type : IN STD_LOGIC;
	RTS_type : IN STD_LOGIC;
	RTS_type_out : OUT STD_LOGIC;
	stack_error : OUT STD_LOGIC;
	STACK_POP_type : IN STD_LOGIC;
	STACK_POP_type_out : OUT STD_LOGIC;
	STACK_PUSH_type : IN STD_LOGIC;
	STACK_PUSH_type_out : OUT STD_LOGIC;
	STORE_type : IN STD_LOGIC;
	STORE_type_out : OUT STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : execute
	PORT MAP (
-- list connections between master ports and signals
	address => address,
	pc_jmp_value => pc_jmp_value,
	bad_address => bad_address,
	forward_A_MEM => forward_A_MEM,
	forward_B_MEM => forward_B_MEM,
	forward_A_WB => forward_A_WB,
	forward_B_WB => forward_B_WB,
	fwd_MEM_A => fwd_MEM_A,
	fwd_MEM_B => fwd_MEM_B,
	fwd_WB_A => fwd_WB_A,
	fwd_WB_B => fwd_WB_B,
	clk => clk,
	COND_type => COND_type,
	COND_type_out => COND_type_out,
	dst_valid => dst_valid,
	dstvalid_EX => dstvalid_EX,
	dstvalid_MEM => dstvalid_MEM,
	dstvalid_MEM_out => dstvalid_MEM_out,
	HAS_DR => HAS_DR,
	HAS_DR_out => HAS_DR_out,
	IMM => IMM,
	jmp_is_ok => jmp_is_ok,
	JMP_type => JMP_type,
	JMP_type_out => JMP_type_out,
	JSR_type => JSR_type,
	JSR_type_out => JSR_type_out,
	LOAD_type => LOAD_type,
	LOAD_type_out => LOAD_type_out,
	MEM_RD => MEM_RD,
	MEM_RD_out => MEM_RD_out,
	MEM_WR => MEM_WR,
	MEM_WR_out => MEM_WR_out,
	MOV_type => MOV_type,
	MOV_type_out => MOV_type_out,
	PC => PC,
	PC_plus => PC_plus,
	RD => RD,
	RD_out => RD_out,
	reset => reset,
	result => result,
	RS1 => RS1,
	RS2 => RS2,
	RS_IMM_type => RS_IMM_type,
	RTS_type => RTS_type,
	RTS_type_out => RTS_type_out,
	stack_error => stack_error,
	STACK_POP_type => STACK_POP_type,
	STACK_POP_type_out => STACK_POP_type_out,
	STACK_PUSH_type => STACK_PUSH_type,
	STACK_PUSH_type_out => STACK_PUSH_type_out,
	STORE_type => STORE_type,
	STORE_type_out => STORE_type_out
	);
PROCESS                                               
-- variable declarations                                     
BEGIN    
  
  PC <= (31 downto 30 => '0', 29 => '1', 28 downto 0 => '0');
  RS1 <= X"00000001";
	--RS1 <= X"00000000";
	RS2 <= X"0000000A";
	
	--JMP <= '1';
  WAIT;                                            
END PROCESS;                                          
                                          
END execute_arch;
