-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Mon May 06 17:23:07 2024"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY high_lvl_entity IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		pb1 :  IN  STD_LOGIC;
		pb2 :  IN  STD_LOGIC;
		vert_sync_out :  OUT  STD_LOGIC;
		red_out :  OUT  STD_LOGIC;
		green_out :  OUT  STD_LOGIC;
		blue_out :  OUT  STD_LOGIC;
		horiz_sync_out :  OUT  STD_LOGIC
	);
END high_lvl_entity;

ARCHITECTURE bdf_type OF high_lvl_entity IS 

COMPONENT pll
	PORT(refclk : IN STD_LOGIC;
		 rst : IN STD_LOGIC;
		 outclk_0 : OUT STD_LOGIC;
		 locked : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bouncy_ball
	PORT(pb1 : IN STD_LOGIC;
		 pb2 : IN STD_LOGIC;
		 clk : IN STD_LOGIC;
		 vert_sync : IN STD_LOGIC;
		 pixel_column : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 pixel_row : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 red : OUT STD_LOGIC;
		 green : OUT STD_LOGIC;
		 blue : OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT vga_sync
	PORT(clock_25Mhz : IN STD_LOGIC;
		 red : IN STD_LOGIC;
		 green : IN STD_LOGIC;
		 blue : IN STD_LOGIC;
		 red_out : OUT STD_LOGIC;
		 green_out : OUT STD_LOGIC;
		 blue_out : OUT STD_LOGIC;
		 horiz_sync_out : OUT STD_LOGIC;
		 vert_sync_out : OUT STD_LOGIC;
		 pixel_column : OUT STD_LOGIC_VECTOR(9 DOWNTO 0);
		 pixel_row : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_9 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_3 :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_4 :  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_6 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_7 :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_8 :  STD_LOGIC;


BEGIN 
vert_sync_out <= SYNTHESIZED_WIRE_2;
SYNTHESIZED_WIRE_0 <= '0';



b2v_inst : pll
PORT MAP(refclk => clk,
		 rst => SYNTHESIZED_WIRE_0,
		 outclk_0 => SYNTHESIZED_WIRE_9);


b2v_inst1 : bouncy_ball
PORT MAP(pb1 => pb1,
		 pb2 => pb2,
		 clk => SYNTHESIZED_WIRE_9,
		 vert_sync => SYNTHESIZED_WIRE_2,
		 pixel_column => SYNTHESIZED_WIRE_3,
		 pixel_row => SYNTHESIZED_WIRE_4,
		 red => SYNTHESIZED_WIRE_6,
		 green => SYNTHESIZED_WIRE_7,
		 blue => SYNTHESIZED_WIRE_8);


b2v_inst2 : vga_sync
PORT MAP(clock_25Mhz => SYNTHESIZED_WIRE_9,
		 red => SYNTESIZED_WIRE_6,
		 green => SYNTHESIZED_WIRE_7,
		 blue => SYNTHESIZED_WIRE_8,
		 red_out => red_out,
		 green_out => green_out,
		 blue_out => blue_out,
		 horiz_sync_out => horiz_sync_out,
		 vert_sync_out => SYNTHESIZED_WIRE_2,
		 pixel_column => SYNTHESIZED_WIRE_3,
		 pixel_row => SYNTHESIZED_WIRE_4);



END bdf_type;