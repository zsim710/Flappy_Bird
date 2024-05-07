library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
entity bouncy_ball is
  port
  (
    pb1, pb2, left_click, right_click, clk, vert_sync : in std_logic;
    pixel_row, pixel_column              : in std_logic_vector(9 downto 0);
    red, green, blue                     : out std_logic);
end bouncy_ball;

architecture behavior of bouncy_ball is



  component vga_sync is
    port
    (
      clock_25Mhz, red, green, blue                               : in std_logic;
      red_out, green_out, blue_out, horiz_sync_out, vert_sync_out : out std_logic;
      pixel_row, pixel_column                                     : out std_logic_vector(9 downto 0)
    );
  end component;

  signal ball_on       : std_logic                     := '0';
  signal size          : std_logic_vector(9 downto 0)  := "0000001000";
  signal ball_y_pos    : std_logic_vector(9 downto 0)  := "0011110000";
  signal ball_x_pos    : std_logic_vector(10 downto 0) := "00101000000";
  signal ball_y_motion : std_logic_vector(9 downto 0)  := "0000000010";
  signal ball_x_motion : std_logic_vector(10 downto 0) := "00000000010";
begin

  size <= CONV_STD_LOGIC_VECTOR(8, 10);
  -- ball_x_pos and ball_y_pos show the (x,y) for the centre of ball

  ball_on <= '1' when (('0' & ball_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & ball_x_pos + size) -- x_pos - size <= pixel_column <= x_pos + size
    and ('0' & ball_y_pos <= pixel_row + size) and ('0' & pixel_row <= ball_y_pos + size)) else -- y_pos - size <= pixel_row <= y_pos + size
    '0';
  -- Colours for pixel data on video signal
  -- Changing the background and ball colour by pushbuttons
  Red   <= not ball_on;
  Green <= '1';
  Blue  <= not ball_on;
  Move_Ball : process (vert_sync, left_click, right_click)
  begin
    -- Move ball once every vertical sync
    if (rising_edge(vert_sync)) then
      -- Bounce off top or bottom of the screen
      if (('0' & ball_y_pos >= CONV_STD_LOGIC_VECTOR(479, 10) - size)) then
        ball_y_motion     <= - CONV_STD_LOGIC_VECTOR(2, 10);
      elsif (ball_y_pos <= size) then
        ball_y_motion     <= CONV_STD_LOGIC_VECTOR(2, 10);
      end if;
      -- Bounce off left or right of the screen
      --if (('0' & ball_x_pos >= CONV_STD_LOGIC_VECTOR(639, 11) - size)) then
        --ball_x_motion     <= - CONV_STD_LOGIC_VECTOR(2, 11);
      --elsif (ball_x_pos <= size) then
        --ball_x_motion     <= CONV_STD_LOGIC_VECTOR(2, 11);
      --end if;
      if (left_click = '1') then
        --ball_x_motion <= CONV_STD_LOGIC_VECTOR(5, 11);
        ball_y_motion <= - CONV_STD_LOGIC_VECTOR(4, 10);
		  ball_y_pos <= ball_y_pos + 10;
		--elsif (right_click = '1') then
		  --ball_x_motion <= CONV_STD_LOGIC_VECTOR(5, 11);
		  --ball_y_motion <= CONV_STD_LOGIC_VECTOR(4, 10);
	   end if;
		 -- Compute next ball Y position
		 --ball_x_pos <= ball_x_pos + ball_x_motion;
		 ball_y_pos <= ball_y_pos + ball_y_motion;
	  end if;
   end process Move_Ball;

 end behavior;