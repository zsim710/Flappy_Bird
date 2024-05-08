LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;


ENTITY pipe IS
  PORT (
    clk, vert_sync : IN std_logic;
    pixel_row, pixel_column : IN std_logic_vector(9 DOWNTO 0);
    red, green, blue : OUT std_logic
  );
END pipe;

ARCHITECTURE behavior OF pipe IS
  SIGNAL pipe_x_pos : std_logic_vector(9 DOWNTO 0);
  SIGNAL pipe_width, pipe_height : std_logic_vector(9 DOWNTO 0);
  SIGNAL screen_width, screen_height : std_logic_vector(9 DOWNTO 0);
  SIGNAL pipe_on : std_logic;

BEGIN
  -- Screen and pipe dimensions
  screen_width  <= "1010000000"; -- 640 in binary
  screen_height <= "111100000";  -- 480 in binary
  pipe_width    <= "1100100";    -- 100 in binary
  pipe_height   <= "100101100";  -- 300 in binary

  -- Initialize pipe starting position on the right side of the screen
  pipe_x_pos    <= screen_width; -- Start from the far right

  -- Process to move the pipe
  pipe_movement : PROCESS(vert_sync)
  BEGIN
    IF rising_edge(clk) THEN
      IF pipe_x_pos <= "0000000000" THEN
        pipe_x_pos <= screen_width; -- Reset to the right side of the screen
      ELSE
        pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(1, 10); -- Move left by one pixel each clock cycle
      END IF;
    END IF;
  END PROCESS;

  -- Check if current pixel is within the bounds of the pipe
  pipe_on <= '1' WHEN (pixel_column >= pipe_x_pos AND
                        pixel_column <= pipe_x_pos + pipe_width - 1 AND
                        pixel_row >= screen_height - pipe_height AND
                        pixel_row <= screen_height - 1)
                ELSE '0'; 

  -- Set the output colors, pipe in red, background in black
  red   <= pipe_on;
  green <= '0';
  blue  <= '0';

END behavior;
