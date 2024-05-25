library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity pipe_test is
  port
  (
    normal_mode, training_mode, clk, reset, vert_sync                  : in std_logic;
    easy_mode_out, medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
    pixel_row, pixel_column                                            : in std_logic_vector(9 downto 0);
    pipe_on, piped_pass                                                : out std_logic
  );
end entity;

architecture behavior of pipe_test is
<<<<<<< HEAD
  constant screen_width : unsigned := to_unsigned(639, 11); -- 640 in binary
  constant screen_height : unsigned := to_unsigned(479, 11); -- 480 in binary
  constant pipe_width_int   : integer := 50; -- 100 in binary
  constant pipe_spacing : integer := 345;
  constant pipe_spacing_hard : integer := 230;
  signal pipe_x_pos                                  : unsigned(10 downto 0) := (690, 11);
  signal pipe2_x_pos                                 : unsigned(10 downto 0) := unsigned(639 + pipe_width_int + pipe_spacing, 11);
  signal pipe3_x_pos                                 : unsigned(10 downto 0) := unsigned(639 + pipe_width_int + pipe_spacing_hard + pipe_spacing_hard , 11);
  signal pipe_width                                  : unsigned(10 downto 0);
  signal screen_width, screen_height                 : unsigned(10 downto 0);
=======
  signal pipe_x_pos                                  : std_logic_vector(10 downto 0) := conv_std_logic_vector(690, 11);
  signal pipe2_x_pos                                 : std_logic_vector(10 downto 0) := conv_std_logic_vector(1013, 11);
  signal pipe3_x_pos                                 : std_logic_vector(10 downto 0) := conv_std_logic_vector(898, 11);
  signal pipe_width                                  : std_logic_vector(10 downto 0);
  signal screen_width, screen_height                 : std_logic_vector(10 downto 0);
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
  signal pipe_top, pipe_bot                          : std_logic;
  signal pipe2_top, pipe2_bot                        : std_logic;
  signal pipe3_top, pipe3_bot                        : std_logic;
  signal gap_on                                      : std_logic;
  signal gap_half_width                              : integer := 60;
  signal gap_pos_cent1, gap_pos_cent2, gap_pos_cent3 : integer range 150 to 350;
  signal random_number                               : std_logic_vector(7 downto 0);
  signal speed                                       : integer := 5;

  component GaloisLFSR8 is
    port
    (
      clk, reset : in std_logic;
      lfsr_out   : out std_logic_vector(7 downto 0)
    );
  end component;

  component speed_control is
    port
    (
      clk, reset : in std_logic;
      speed      : out integer
    );
  end component;

begin
<<<<<<< HEAD
  -- Screen and pipe dimensiond
  pipe_width <= to_unsigned(pipe_width);
=======
  -- Screen and pipe dimensions
  screen_width  <= CONV_STD_LOGIC_VECTOR(639, 11); -- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(479, 11); -- 480 in binary
  pipe_width    <= CONV_STD_LOGIC_VECTOR(50, 11); -- 100 in binary
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1

  LFSR1 : GaloisLFSR8
  port map
  (
    clk      => clk,
    reset    => '0',
    lfsr_out => random_number
  );
  SPEED : speed_control
  port map
  (
    clk   => clk,
    reset => reset,
    speed => speed
  );

  -- Initialize pipe starting position on the right side of the screen
  --pipe_x_pos    <= screen_width + pipe_width; -- Start from the far right

  -- Process to set the difficulty level
  difficulty : process (easy_mode_out, medium_mode_out, hard_mode_out, impossible_mode_out)
  begin
    if (easy_mode_out = '1') then
      speed <= 2;
    elsif (medium_mode_out = '1') then
      speed <= 3;
    elsif (hard_mode_out = '1') then
      speed          <= 4;
      gap_half_width <= 40;
    elsif (impossible_mode_out = '1') then
      speed          <= 6;
      gap_half_width <= 35;
    end if;
  end process;

  -- Process to move the pipes
  pipe_movement : process (vert_sync, impossible_mode_out)
  begin
    if rising_edge(vert_sync) then
<<<<<<< HEAD
      if pipe_x_pos <= to_unsigned(0, 11) then
=======
      if pipe_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11) then
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
        pipe_x_pos    <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent1 <= conv_integer(random_number(7 downto 0)) mod 101 + 200;
      else
<<<<<<< HEAD
        pipe_x_pos <= pipe_x_pos - to_unsigned(speed, 11); -- movement of pipe 1 
      end if;

      if (impossible_mode_out = '1') then
        pipe2_x_pos <= to_unsigned(920, 11);
      end if;

      if pipe2_x_pos <= to_unsigned(0, 11) then
=======
        pipe_x_pos <= pipe_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- movement of pipe 1 
      end if;

      if (impossible_mode_out = '1') then
        pipe2_x_pos <= conv_std_logic_vector(920, 11);
      end if;

      if pipe2_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11) then
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
        pipe2_x_pos    <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent2  <= conv_integer(random_number(7 downto 0)) mod 101 + 200;
      else
<<<<<<< HEAD
        pipe2_x_pos <= pipe2_x_pos - to_unsigned(speed, 11); -- Movement of pipe 2
      end if;

      if pipe3_x_pos <= to_unsigned(0, 11) then
=======
        pipe2_x_pos <= pipe2_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- Movement of pipe 2
      end if;

      if pipe3_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11) then
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
        pipe3_x_pos    <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent3  <= conv_integer(random_number(7 downto 0)) mod 101 + 200;
      else
<<<<<<< HEAD
        pipe3_x_pos <= pipe3_x_pos - to_unsigned(speed, 11); -- Movement of pipe 3
=======
        pipe3_x_pos <= pipe3_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- Movement of pipe 3
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
      end if;
    end if;
  end process;

  -- Check if current pixel is in the bounds of the bottom pipe
<<<<<<< HEAD
  pipe_bot <= '1' when (to_unsigned('0' & pixel_column) <= pipe_x_pos and to_unsigned('0' & pixel_column) >= pipe_x_pos - pipe_width and to_unsigned('0' & pixel_row) >= to_unsigned((gap_pos_cent1 + gap_half_width), 11) and '0' & pixel_row < to_std_logic_vector(screen_height)) else
    '0';
  -- Check if current pixel is within bounds of the top pipe
  pipe_top <= '1' when (to_unsigned('0' & pixel_column) <= pipe_x_pos and to_unsigned('0' & pixel_column) >= pipe_x_pos - pipe_width and to_unsigned('0' & pixel_row) <= to_unsigned((gap_pos_cent1 - gap_half_width), 11) and '0' & pixel_row> to_std_logic_vector(0, 11)) else
    '0';

  -- Same thing but for the second pipe
  pipe2_bot <= '1' when (to_unsigned('0' & pixel_column) <= pipe2_x_pos and to_unsigned('0' & pixel_column) >= pipe2_x_pos - pipe_width and to_unsigned('0' & pixel_row) >= to_unsigned((gap_pos_cent2 + gap_half_width), 11) and '0' & pixel_row< to_std_logic_vector(screen_height)) else
    '0';
  pipe2_top <= '1' when (to_unsigned('0' & pixel_column) <= pipe2_x_pos and to_unsigned('0' & pixel_column) >= pipe2_x_pos - pipe_width and to_unsigned('0' & pixel_row) <= to_unsigned((gap_pos_cent2 - gap_half_width), 11) and '0' & pixel_row > to_std_logic_vector(0, 11)) else
    '0';

  -- Same for the third pipe  
  pipe3_bot <= '1' when (to_unsigned('0' & pixel_column) <= pipe3_x_pos and to_unsigned('0' & pixel_column) >= pipe3_x_pos - pipe_width and to_unsigned('0' & pixel_row) >= to_unsigned((gap_pos_cent3 + gap_half_width), 11) and '0' & pixel_row < screen_height) else
    '0';
  pipe3_top <= '1' when (to_unsigned('0' & pixel_column) <= pipe3_x_pos and to_unsigned('0' & pixel_column) >= pipe3_x_pos - pipe_width and to_unsigned('0' & pixel_row) <= to_unsigned((gap_pos_cent3 - gap_half_width), 11) and '0' & pixel_row > to_std_logic_vector(0, 11)) else
=======
  pipe_bot <= '1' when ('0' & pixel_column <= pipe_x_pos and '0' & pixel_column >= pipe_x_pos - pipe_width and pixel_row >= conv_std_logic_vector((conv_integer(gap_pos_cent1) + gap_half_width), 11) and '0' & pixel_row < screen_height) else
    '0';
  -- Check if current pixel is within bounds of the top pipe
  pipe_top <= '1' when ('0' & pixel_column <= pipe_x_pos and '0' & pixel_column >= pipe_x_pos - pipe_width and pixel_row <= conv_std_logic_vector((conv_integer(gap_pos_cent1) - gap_half_width), 11) and '0' & pixel_row > CONV_STD_LOGIC_VECTOR(0, 11)) else
    '0';

  -- Same thing but for the second pipe
  pipe2_bot <= '1' when ('0' & pixel_column <= pipe2_x_pos and '0' & pixel_column >= pipe2_x_pos - pipe_width and pixel_row >= conv_std_logic_vector((conv_integer(gap_pos_cent2) + gap_half_width), 11) and '0' & pixel_row < screen_height) else
    '0';
  pipe2_top <= '1' when ('0' & pixel_column <= pipe2_x_pos and '0' & pixel_column >= pipe2_x_pos - pipe_width and pixel_row <= conv_std_logic_vector((conv_integer(gap_pos_cent2) - gap_half_width), 11) and '0' & pixel_row > CONV_STD_LOGIC_VECTOR(0, 11)) else
    '0';

  -- Same for the third pipe  
  pipe3_bot <= '1' when ('0' & pixel_column <= pipe3_x_pos and '0' & pixel_column >= pipe3_x_pos - pipe_width and pixel_row >= conv_std_logic_vector((conv_integer(gap_pos_cent3) + gap_half_width), 11) and '0' & pixel_row < screen_height) else
    '0';
  pipe3_top <= '1' when ('0' & pixel_column <= pipe3_x_pos and '0' & pixel_column >= pipe3_x_pos - pipe_width and pixel_row <= conv_std_logic_vector((conv_integer(gap_pos_cent3) - gap_half_width), 11) and '0' & pixel_row > CONV_STD_LOGIC_VECTOR(0, 11)) else
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
    '0';

  pipe_on <= '1' when (((pipe_top = '1') or (pipe_bot = '1') or (pipe2_top = '1') or (pipe2_bot = '1') or (pipe3_top = '1' and impossible_mode_out = '1') or (pipe3_bot = '1' and impossible_mode_out = '1')) and (normal_mode = '1')) else
    '1' when (((pipe_top = '1') or (pipe_bot = '1') or (pipe2_top = '1') or (pipe2_bot = '1') or (pipe3_top = '1') or (pipe3_bot = '1')) and (training_mode = '1')) else
    '0';

<<<<<<< HEAD
  piped_pass <= '1' when (to_unsigned(150, 11) > pipe_x_pos) else -- bird x_position 
    '1' when (to_unsigned(150, 11) > pipe2_x_pos) else
    '1' when (to_unsigned(150, 11) > pipe3_x_pos and impossible_mode_out = '1') else
=======
  piped_pass <= '1' when (conv_std_logic_vector(150, 11) > pipe_x_pos) else -- bird x_position 
    '1' when (conv_std_logic_vector(150, 11) > pipe2_x_pos) else
    '1' when (conv_std_logic_vector(150, 11) > pipe3_x_pos and impossible_mode_out = '1') else
>>>>>>> e0aed0f47858783c14dca0db4496a3ee634f34a1
    '0';

end architecture;