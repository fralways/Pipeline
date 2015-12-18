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
-- Generated on "12/18/2015 13:57:51"
                                                            
-- Vhdl Test Bench template for design  :  alu
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY alu_vhd_tst IS
END alu_vhd_tst;
ARCHITECTURE alu_arch OF alu_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL A : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL B : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL mode : STD_LOGIC_VECTOR(5 DOWNTO 0);
SIGNAL output : STD_LOGIC_VECTOR(31 DOWNTO 0);
COMPONENT alu
	PORT (
	A : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	mode : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
	output : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END COMPONENT;
BEGIN
	i1 : alu
	PORT MAP (
-- list connections between master ports and signals
	A => A,
	B => B,
	mode => mode,
	output => output
	);
PROCESS                                               
-- variable declarations                                     
BEGIN                                                        
        -- code that executes only once 
	wait for 5 ns;
	A <= (31 downto 1 => '0', 0 => '1');
	B <= (31 downto 2 => '0', 1 downto 0 => '1');
	mode <= "011001";
	wait for 5 ns;
	mode <= "011000";
	wait for 5 ns;
	A <= (31 => '1'  ,30 downto 1 => '0', 0 => '1');
	mode <= "011010";
	wait for 5 ns;
	mode <= "011001";
	
WAIT;                                                       
END PROCESS;                                           
                                      
END alu_arch;
