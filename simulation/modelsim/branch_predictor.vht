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
-- Generated on "12/09/2015 17:42:03"
                                                            
-- Vhdl Test Bench template for design  :  branch_predictor
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY branch_predictor_vhd_tst IS
END branch_predictor_vhd_tst;
ARCHITECTURE branch_predictor_arch OF branch_predictor_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
SIGNAL get_prediction : STD_LOGIC;
SIGNAL prediction_entry_pc : std_logic_vector(31 downto 0);
SIGNAL prediction : STD_LOGIC;
SIGNAL prediction_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL prediction_was_success : STD_LOGIC;
SIGNAL update_entry : STD_LOGIC;
SIGNAL update_entry_pc : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL update_entry_jmp_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL is_prediction_entry_found : STD_LOGIC;
COMPONENT branch_predictor
	PORT (
	clk : IN STD_LOGIC;
	reset : IN STD_LOGIC;
	get_prediction : IN STD_LOGIC;
	prediction_entry_pc : in std_logic_vector(31 downto 0);
	prediction : OUT STD_LOGIC;
	is_prediction_entry_found : OUT STD_LOGIC;
	prediction_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	prediction_was_success : IN STD_LOGIC;
	update_entry : IN STD_LOGIC;
	update_entry_pc : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	update_entry_jmp_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : branch_predictor
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	reset => reset,
	get_prediction => get_prediction,
	prediction_entry_pc => prediction_entry_pc,
	prediction => prediction,
	prediction_address => prediction_address,
	prediction_was_success => prediction_was_success,
	update_entry => update_entry,
	update_entry_pc => update_entry_pc,
	is_prediction_entry_found => is_prediction_entry_found,
	update_entry_jmp_address => update_entry_jmp_address
	);    
                                
PROCESS                                               
	variable clk_next : std_LOGIC := '0';
BEGIN                                                        
   clk<=clk_next;
	clk_next := not clk_next;
WAIT for 5 ns;                                                       
END PROCESS;                
                          
PROCESS                                              
-- optional sensitivity list                                  
-- (        )                                                 
-- variable declarations                                      
BEGIN                                                         

	get_prediction <= '1';
	prediction_entry_pc <= (others => '1');
	wait for 10 ns;
	get_prediction <= '1';
	prediction_entry_pc <= (others => '0');
	wait for 10 ns;
	get_prediction <= '1';
	update_entry <= '1';
	prediction_entry_pc <= (others => '0');
	update_entry_pc <= (others => '1');
	update_entry_jmp_address <= (others => '1');
	prediction_was_success <= '0';
	wait for 10 ns;
	update_entry <= '0';
	get_prediction <= '1';
	prediction_entry_pc <= (others => '1');
	wait for 10 ns;
	update_entry <= '0';
	get_prediction <= '1';
	prediction_entry_pc <= (others => '0');

WAIT;                                                        
END PROCESS;                                          
END branch_predictor_arch;
