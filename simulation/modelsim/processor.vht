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
-- Generated on "12/10/2015 12:48:28"
                                                            
-- Vhdl Test Bench template for design  :  processor
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY processor_vhd_tst IS
END processor_vhd_tst;
ARCHITECTURE processor_arch OF processor_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT processor
	PORT (
	clk : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : processor
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	reset => reset
	);
PROCESS                                               
	variable clk_next : std_LOGIC := '0';
BEGIN                                                        
   clk<=clk_next;
	clk_next := not clk_next;
WAIT for 5 ns;                                                       
END PROCESS;    

PROCESS
begin
  reset<='1';
  wait for 15 ns;
  reset<='0';
  wait for 28 ns;
  reset<='1';
  wait for 22 ns;
  reset<='0';
  wait;                                       
end process;
END processor_arch;
