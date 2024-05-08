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
  signal pipe_leftside : std_logic_vector(9 DOWNTO 0);


BEGIN
  -- Screen and pipe dimensions
  screen_width  <= CONV_STD_LOGIC_VECTOR(640, 10);-- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(480, 10);  -- 480 in binary
  pipe_width    <= CONV_STD_LOGIC_VECTOR(100, 10); -- 100 in binary
  pipe_height   <= CONV_STD_LOGIC_VECTOR(300, 10); -- 300 in binary

  -- Initialize pipe starting position on the right side of the screen
  pipe_x_pos    <= screen_width + pipe_width; -- Start from the far right
 

  -- Process to move the pipe
pipe_movement : PROCESS(vert_sync)
-- BEGIN: ed8c6549bwf9
variable pipe_left : std_logic := CONV_STD_LOGIC_VECTOR(screen_width, 10);
-- END: ed8c6549bwf9
  BEGIN
    IF rising_edge(clk) THEN
      IF (pipe_x_pos = CONV_STD_LOGIC_VECTOR(0, 10))  THEN
        pipe_x_pos <= screen_width; -- Reset to the right side of the screen
        pipe_left := CONV_STD_LOGIC_VECTOR(screen_width, 10);
      elsif(pipe_left = CONV_STD_LOGIC_VECTOR(0, 10)) THEN
      pipe_left := CONV_STD_LOGIC_VECTOR(0, 10);
      pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(2, 10);
      else
        pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(2, 10);
        pipe_left := pipe_left - CONV_STD_LOGIC_VECTOR(2, 10); -- Move left by one pixel each clock cycle
         -- Move left by one pixel each clock cycle
      END IF;
      pipe_leftside <= pipe_left;
    END IF;
  END PROCESS;


  -- Check if current pixel is within the bounds of the pipe
  pipe_on <= '1' WHEN (pixel_column <= pipe_x_pos AND
                        pixel_column >= pipe_leftside AND
                        pixel_row >= screen_height - pipe_height AND -- the height logic is fine
                        pixel_row <= screen_height)
                ELSE '0' ;

  -- Set the output colors, pipe in red, background in black
  red   <= pipe_on;
  green <= not pipe_on;
  blue  <= not pipe_on;

END behavior;
