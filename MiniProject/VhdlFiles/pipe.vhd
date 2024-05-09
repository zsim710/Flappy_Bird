library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
entity pipe is
  port
  (
    clk, vert_sync          : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    pipe_on                 : out std_logic
  );
end pipe;

architecture behavior of pipe is
  signal pipe_x_pos                  : std_logic_vector(10 downto 0);
  signal pipe_width, pipe_height     : std_logic_vector(10 downto 0);
  signal screen_width, screen_height : std_logic_vector(10 downto 0);

begin
  -- Screen and pipe dimensions
  screen_width  <= CONV_STD_LOGIC_VECTOR(640, 11);-- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(480, 11); -- 480 in binary
  pipe_width    <= CONV_STD_LOGIC_VECTOR(100, 11); -- 100 in binary
  pipe_height   <= CONV_STD_LOGIC_VECTOR(300, 11); -- 300 in binary

  -- Process to move the pipe
  pipe_movement : process (vert_sync)
  begin
    if (rising_edge(vert_sync)) then
      if pipe_x_pos <= "00000000000" then
        pipe_x_pos    <= screen_width; -- Reset to the right side of the screen
      else
        pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(2, 11); -- Move left by one pixel each clock cycle
      end if;
    end if;
  end process;

  -- Set the output colors, pipe in red, background in black
end behavior;