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
-- Generated on "12/08/2015 17:29:07"
                                                            
-- Vhdl Test Bench template for design  :  reg_file
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY reg_file_vhd_tst IS
END reg_file_vhd_tst;
ARCHITECTURE reg_file_arch OF reg_file_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL dst : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL src1 : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL src2 : STD_LOGIC_VECTOR(4 DOWNTO 0);
SIGNAL reset : STD_LOGIC;
SIGNAL data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL wr : STD_LOGIC;
COMPONENT reg_file
	PORT (
	clk : IN STD_LOGIC;
	dst : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	src1 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	src2 : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	reset : IN STD_LOGIC;
	data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	data_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	data_out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	wr : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : reg_file
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	dst => dst,
	src1 => src1,
	src2 => src2,
	reset => reset,
	data_in => data_in,
	data_out1 => data_out1,
	data_out2 => data_out2,
	wr => wr
	);
	
PROCESS                                               
	variable clk_next : std_LOGIC := '0';
BEGIN                                                        
   clk<=clk_next;
	clk_next := not clk_next;
WAIT for 5 ns;                                                       
END PROCESS;   
                                     
PROCESS

BEGIN                                                         
	wait for 1 ns;
	dst <= "00001";
	wr <= '1';
	data_in <= (others=>'0');
	
	wait for 10 ns;
	dst <= "00000";
	wr <= '1';
	data_in <= (31 downto 2 => '0',
              	1 downto 0 => '1');
	src1 <= "00001";
	
	WAIT;                                                        
END PROCESS;                                          
END reg_file_arch;
