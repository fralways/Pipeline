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
-- Generated on "12/05/2015 13:12:48"
                                                            
-- Vhdl Test Bench template for design  :  Cache
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY Cache_vhd_tst IS
END Cache_vhd_tst;
ARCHITECTURE Cache_arch OF Cache_vhd_tst IS
-- constants                                                 
-- signals                                     
SIGNAL address_in : STD_LOGIC_VECTOR(31 DOWNTO 0);              
SIGNAL data_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL clk : STD_LOGIC;
SIGNAL wr : STD_LOGIC;
SIGNAL rd_instr : STD_LOGIC;
SIGNAL rd_data : STD_LOGIC;

COMPONENT Cache
	PORT (
	  address_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	  data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	clk : IN STD_LOGIC;
	wr : IN STD_LOGIC;
	rd_data : IN STD_LOGIC;
	rd_instr : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : Cache
	PORT MAP (
-- list connections between master ports and signals
	data_out => data_out,
	address_in => address_in,
	data_in => data_in,
	clk => clk,
	wr => wr,
	rd_instr => rd_instr,
	rd_data => rd_data
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
  rd_instr<='1';         
  address_in <= (31 downto 1 => '0' , 0 => '1');   
  WAIT for 10 ns;  
  rd_instr<='0';
  wr<='1';
  data_in <= (others=>'1');                            
  address_in <= (31 downto 2 => '0' , 1 downto 0 => '1'); --3
  wait for 10 ns;
  data_in <= (others=>'0');
  address_in <= (31 downto 2 => '0' , 1 => '1', 0 => '0'); --2
  WAIT for 10 ns;                              
  address_in <= (31 downto 2 => '0' , 1 downto 0 => '1'); --3
  
  wait;                         
END PROCESS;
                                        
END Cache_arch;
