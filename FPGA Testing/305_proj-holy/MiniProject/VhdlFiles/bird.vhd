library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
--
--
--
--
--
entity bird is
  port
  (
    left_click, clk, vert_sync : in std_logic;
    pixel_row, pixel_column    : in std_logic_vector(9 downto 0);
    ball_on                    : out std_logic
  );
end bird;
--
--
--
--
--
architecture behaviour of bird is

  signal size          : std_logic_vector(9 downto 0)  := "0000001000";
  signal ball_y_pos    : std_logic_vector(9 downto 0)  := "0011110000";
  signal ball_x_pos    : std_logic_vector(10 downto 0) := "00101000000";
  signal ball_y_motion : std_logic_vector(9 downto 0)  := "0000000010";
  signal ball_x_motion : std_logic_vector(10 downto 0) := "00000000010";
  signal speed         : std_logic_vector(9 downto 0)  := "0000000101";
  --
  --
  --
  --
  --
begin

  size <= CONV_STD_LOGIC_VECTOR(8, 10);
  -- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball
  ball_on <= '1' when (('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) -- x_pos - size <= pixel_column <= x_pos + size
    and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size)) else -- y_pos - size <= pixel_row <= y_pos + size
    '0';
  -- Colours for pixel data on video signal
  -- Changing the background and ball colour by pushbuttons

  Move_Ball : process (vert_sync, left_click)
    variable previousYBallMotion : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);
    variable left_click_pressed  : std_logic                    := '0';
  begin
    -- Move ball once every vertical sync
    if (rising_edge(vert_sync)) then
      -- Apply gravity effect
      if (left_click_pressed = '0' and left_click = '1') then -- Adjust threshold as needed
        ball_y_motion <= previousYBallMotion + CONV_STD_LOGIC_VECTOR(1, 10); -- Increase downward motion
        if (ball_y_motion = CONV_STD_LOGIC_VECTOR(20, 10)) then
          ball_y_motion <= CONV_STD_LOGIC_VECTOR(20, 10);
        end if;

        -- Check if left click is active (jump)
      elsif (left_click = '0' and left_click_pressed = '0') then
        -- Apply upward impulse for a short duration
        ball_y_motion <= - CONV_STD_LOGIC_VECTOR(7, 10); -- Set initial upward motion

      elsif (left_click = '1') then
        left_click_pressed := '0';
      end if;
      -- Update ball position

      if (('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(450, 10) - size)) then
        ball_y_motion     <= - CONV_STD_LOGIC_VECTOR(1, 10);
      elsif ('0' & ball_y_pos <= size + 8) then
        ball_y_motion     <= CONV_STD_LOGIC_VECTOR(1, 10);
      end if;

      ball_y_pos <= ball_y_pos + ball_y_motion;

      -- Update previous motion for next iteration
      previousYBallMotion := ball_y_motion;
    end if;

  end process Move_Ball;
end behaviour;