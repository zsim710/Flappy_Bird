library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_SIGNED.all;

entity pipe_hard is
  port (
    clk, reset, vert_sync   : in  std_logic;
    pixel_row, pixel_column : in  std_logic_vector(9 downto 0);
    pipe_on                 : out std_logic
  );
end entity;

architecture behavior of pipe_hard is
  signal pipe_x_pos                  : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(230, 11);
  signal pipe2_x_pos                 : std_logic_vector(10 downto 0) := conv_std_logic_vector(460, 11);
  signal pipe3_x_pos                 : std_logic_vector(10 downto 0) := conv_std_logic_vector(690, 11);
  signal pipe_width    : std_logic_vector(10 downto 0);
  signal screen_width, screen_height : std_logic_vector(10 downto 0);
  signal pipe_top, pipe_bot          : std_logic;
  signal pipe2_top, pipe2_bot        : std_logic;
  signal pipe3_top, pipe3_bot        : std_logic;
  constant gap_half_width : integer := 40;
  signal gap_pos_cent1, gap_pos_cent2, gap_pos_cent3 : integer range 150 to 350;
  signal random_number                               : std_logic_vector(7 downto 0);
  constant speed : integer := 5;

  component GaloisLFSR8 is
    port (
      clk, reset : in  std_logic;
      lfsr_out   : out std_logic_vector(7 downto 0)
    );
  end component;

begin
  -- Screen and pipe dimensions
  screen_width  <= CONV_STD_LOGIC_VECTOR(639, 11); -- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(479, 11); -- 480 in binary
  pipe_width    <= CONV_STD_LOGIC_VECTOR(50, 11);  -- 100 in binary
  --pipe_height   <= CONV_STD_LOGIC_VECTOR(150, 11); -- 300 in binary

  LFSR1: GaloisLFSR8
    port map (
      clk      => clk,
      reset    => '0',
      lfsr_out => random_number
    );

  -- Initialize pipe starting position on the right side of the screen
  --pipe_x_pos    <= screen_width + pipe_width; -- Start from the far right
  -- Process to move the pipe

  pipe_movement: process (vert_sync)
  begin

    if rising_edge(vert_sync) then

      if pipe_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11) then
        pipe_x_pos <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent1 <= conv_integer(random_number(7 downto 0)) mod 101 + 200;
      else
        pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- movement of pipe 1 
      end if;

      if (pipe2_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11)) then
        pipe2_x_pos <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent2 <= conv_integer(random_number(7 downto 0)) mod 101 + 200;
      else
        pipe2_x_pos <= pipe2_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- Movement of pipe 2
      end if;

      if (pipe3_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11)) then
        pipe3_x_pos <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent3 <= conv_integer(random_number(7 downto 0)) mod 101 + 200;
      else
        pipe3_x_pos <= pipe3_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- Movement of pipe 3
      end if;

    end if;

  end process;
  -- 
  -- check if current pixel is in the bounds of the bottom pipe
  pipe_bot <= '1' when ('0' & pixel_column <= pipe_x_pos and '0' & pixel_column >= pipe_x_pos - pipe_width and pixel_row >= conv_std_logic_vector((conv_integer(gap_pos_cent1) + gap_half_width), 11) and '0' & pixel_row < screen_height) else
              '0';
  -- Check if current pixel is within bounds of the top pipe
  pipe_top <= '1' when ('0' & pixel_column <= pipe_x_pos and '0' & pixel_column >= pipe_x_pos - pipe_width and pixel_row <= conv_std_logic_vector((conv_integer(gap_pos_cent1) - gap_half_width), 11) and '0' & pixel_row > CONV_STD_LOGIC_VECTOR(0, 11)) else
              '0';

  -- same thing but for the second pipe
  pipe2_bot <= '1' when ('0' & pixel_column <= pipe2_x_pos and '0' & pixel_column >= pipe2_x_pos - pipe_width and pixel_row >= conv_std_logic_vector((conv_integer(gap_pos_cent2) + gap_half_width), 11) and '0' & pixel_row < screen_height) else
               '0';
  pipe2_top <= '1' when ('0' & pixel_column <= pipe2_x_pos and '0' & pixel_column >= pipe2_x_pos - pipe_width and pixel_row <= conv_std_logic_vector((conv_integer(gap_pos_cent2) - gap_half_width), 11) and '0' & pixel_row > CONV_STD_LOGIC_VECTOR(0, 11)) else
               '0';

  -- same for the third pipe  
  pipe3_bot <= '1' when ('0' & pixel_column <= pipe3_x_pos and '0' & pixel_column >= pipe3_x_pos - pipe_width and pixel_row >= conv_std_logic_vector((conv_integer(gap_pos_cent3) + gap_half_width), 11) and '0' & pixel_row < screen_height) else
               '0';
  pipe3_top <= '1' when ('0' & pixel_column <= pipe3_x_pos and '0' & pixel_column >= pipe3_x_pos - pipe_width and pixel_row <= conv_std_logic_vector((conv_integer(gap_pos_cent3) - gap_half_width), 11) and '0' & pixel_row > CONV_STD_LOGIC_VECTOR(0, 11)) else
               '0';

  pipe_on <= (pipe_top or pipe_bot) or (pipe2_top or pipe2_bot) or (pipe3_bot or pipe3_top);

  -- Set the output colors, pipe in red, background in black
end architecture;