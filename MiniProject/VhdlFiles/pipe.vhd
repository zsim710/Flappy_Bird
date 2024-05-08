LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;


ENTITY pipe IS
	PORT
		( clk 						: IN std_logic;
		  pixel_row, pixel_column	: IN std_logic_vector(9 DOWNTO 0);
		  red, green, blue 			: OUT std_logic);		
END pipe;

architecture behavior of pipe is

SIGNAL pipe_on					: std_logic;
SIGNAL pipe_width,pipe_height 					: std_logic_vector(9 DOWNTO 0);  
SIGNAL pipe_y_pos, pipe_x_pos	: std_logic_vector(9 DOWNTO 0);

BEGIN           

--size <= CONV_STD_LOGIC_VECTOR(8,10);
pipe_width <= CONV_STD_LOGIC_VECTOR(20,10);   -- Example width
pipe_height <= CONV_STD_LOGIC_VECTOR(80,10); 

-- pipe_x_pos and pipe_y_pos show the (x,y) for the centre of ball
pipe_x_pos <= CONV_STD_LOGIC_VECTOR(50,10);
pipe_y_pos <= CONV_STD_LOGIC_VECTOR(100,10);


pipe_on <= '1' when (pixel_column >= pipe_x_pos and pixel_column <= pipe_x_pos + pipe_width - 1 and
                         pixel_row >= pipe_y_pos and pixel_row <= pipe_y_pos + pipe_height - 1)
                else '0';


-- Colours for pixel data on video signal
-- Keeping background white and square in red
Red <=  '1';
-- Turn off Green and Blue when displaying square
Green <= not pipe_on;
Blue <=  not pipe_on;

END behavior;