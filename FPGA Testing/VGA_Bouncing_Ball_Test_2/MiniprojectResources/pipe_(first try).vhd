LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;


ENTITY pipe IS
  PORT (
    clk, vert_sync : IN std_logic;
    pixel_row, pixel_column : IN std_logic_vector(9 DOWNTO 0);
    pipe_on : OUT std_logic
  );
END pipe;

ARCHITECTURE behavior OF pipe IS
  SIGNAL pipe_x_pos : std_logic_vector(10 DOWNTO 0);
  SIGNAL pipe_width, pipe_height : std_logic_vector(9 DOWNTO 0);
  SIGNAL screen_width, screen_height : std_logic_vector(9 DOWNTO 0);

BEGIN
  -- Screen and pipe dimensions
  screen_width  <= CONV_STD_LOGIC_VECTOR(640, 11);-- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(480, 11);  -- 480 in binary
  pipe_width    <= CONV_STD_LOGIC_VECTOR(100, 10); -- 100 in binary
  pipe_height   <= CONV_STD_LOGIC_VECTOR(300, 10); -- 300 in binary

  -- Initialize pipe starting position on the right side of the screen
  --pipe_x_pos    <= screen_width + pipe_width; -- Start from the far right

  -- Process to move the pipe
  pipe_movement : PROCESS(vert_sync)
  BEGIN

    IF rising_edge(vert_sync) THEN
      IF pipe_x_pos <= "0000000000" THEN
        pipe_x_pos <= screen_width + pipe_width; -- Reset to the right side of the screen
      ELSE
        pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(2, 10); -- Move left by one pixel each clock cycle
      END IF;
    END IF;

  END PROCESS;

  -- Check if current pixel is within the bounds of the pipe
  pipe_on <= '1' WHEN ('0' & pixel_column <= '0' & pipe_x_pos AND
                        '0' & pixel_column >=  '0' & pipe_x_pos - pipe_width AND
                        (pixel_row >= screen_height - pipe_height AND
                        pixel_row <= screen_height)or(pixel_row <= CONV_STD_LOGIC_VECTOR(0, 10) + pipe_height AND
                        pixel_row >= CONV_STD_LOGIC_VECTOR(0, 10)))
                ELSE '0';

  -- Set the output colors, pipe in red, background in black
END behavior;
