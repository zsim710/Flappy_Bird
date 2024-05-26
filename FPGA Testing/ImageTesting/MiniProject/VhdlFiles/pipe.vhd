library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

entity pipe_pipe_pipe is
  port
  (
    normal_mode, training_mode, clk, reset, vert_sync   : in std_logic;
    pause_training_state, pause_normal_state            : in std_logic;
    medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
    pixel_row, pixel_column                             : in std_logic_vector(9 downto 0);
    pipe_on, piped_pass                                 : out std_logic
  );
end entity;

architecture behavior of pipe_pipe_pipe is
  constant screen_width                              : unsigned              := to_unsigned(639, 11); -- 640 in binary
  constant screen_height                             : unsigned              := to_unsigned(479, 11); -- 480 in binary
  constant pipe_width_int                            : integer               := 50; -- 100 in binary
  constant pipe_spacing                              : integer               := 345;
  constant pipe_spacing_hard                         : integer               := 230;
  signal pipe_x_pos                                  : unsigned(10 downto 0) := to_unsigned(639 + pipe_width_int, 11);
  signal pipe2_x_pos                                 : unsigned(10 downto 0) := to_unsigned(639 + pipe_width_int + pipe_spacing, 11);
  signal pipe3_x_pos                                 : unsigned(10 downto 0) := to_unsigned(689 + pipe_width_int + pipe_spacing_hard + pipe_spacing_hard, 11);
  signal pipe_width                                  : unsigned(10 downto 0);
  signal pipe_top, pipe_bot                          : std_logic;
  signal pipe2_top, pipe2_bot                        : std_logic;
  signal pipe3_top, pipe3_bot                        : std_logic;
  signal gap_on                                      : std_logic;
  signal gap_half_width                              : integer := 60;
  signal gap_pos_cent1, gap_pos_cent2, gap_pos_cent3 : integer range 150 to 350;
  signal random_number                               : std_logic_vector(7 downto 0);
  signal speed                                       : integer := 3;

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
      medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
      speed                                               : out integer
    );
  end component;

begin
  -- Screen and pipe dimensiond
  pipe_width <= std_logic_vector(to_unsigned(pipe_width_int, 11));

  LFSR1 : GaloisLFSR8
  port map
  (
    clk      => clk,
    reset    => '0',
    lfsr_out => random_number
  );
  SPEED_CHANGER : speed_control
  port
  map (
  medium_mode_out, hard_mode_out, impossible_mode_out, speed
  );

  -- Initialize pipe starting position on the right side of the screen
  --pipe_x_pos    <= screen_width + pipe_width; -- Start from the far right
  -- Process to set the difficulty level
  -- Process to move the pipes

  pipe_movement : process (vert_sync, impossible_mode_out)
    variable prev_x1, prev_x2, prev_x3 : std_logic_vector(10 downto 0);
  begin
    if rising_edge(vert_sync) then
      if pipe_x_pos <= to_unsigned(0, 11) then
        pipe_x_pos    <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent1 <= to_integer(unsigned(random_number)) mod 101 + 200;
      else
        pipe_x_pos <= pipe_x_pos - to_unsigned(speed, 11); -- movement of pipe 1 
      end if;

      if (impossible_mode_out = '1') then
        pipe2_x_pos <= to_unsigned(920, 11);
      end if;

      if pipe2_x_pos <= to_unsigned(0, 11) then
        pipe2_x_pos    <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent2  <= to_integer(unsigned(random_number)) mod 101 + 200;
      else
        pipe2_x_pos <= pipe2_x_pos - to_unsigned(speed, 11); -- Movement of pipe 2
      end if;

      if pipe3_x_pos <= to_unsigned(0, 11) then
        pipe3_x_pos    <= screen_width + pipe_width; -- Reset to the right side of the screen
        gap_pos_cent3  <= to_integer(unsigned(random_number)) mod 101 + 200;
      elsif impossible_mode_out = '1' then
        pipe3_x_pos <= pipe3_x_pos - to_unsigned(speed, 11); -- Movement of pipe 3
      end if;
    end if;
  end process;

  -- Check if current pixel is in the bounds of the bottom pipe
  pipe_bot <= '1' when (std_logic_vector('0' & pixel_column) >= pipe_x_pos and std_logic_vector('0' & pixel_column) <= pipe_x_pos + pipe_width and std_logic_vector('0' & pixel_row) >= std_logic_vector(to_unsigned(gap_pos_cent1 + gap_half_width, 11)) and std_logic_vector('0' & pixel_row) < screen_height) else
    '0';
  -- Check if current pixel is within bounds of the top pipe
  pipe_top <= '1' when (std_logic_vector('0' & pixel_column) >= pipe_x_pos and std_logic_vector('0' & pixel_column) <= pipe_x_pos + pipe_width and std_logic_vector('0' & pixel_row) <= std_logic_vector(to_unsigned((gap_pos_cent1 - gap_half_width), 11)) and std_logic_vector('0' & pixel_row) > std_logic_vector(to_unsigned(0, 11))) else
    '0';

  pipe2_bot <= '1' when (std_logic_vector('0' & pixel_column) >= pipe2_x_pos and std_logic_vector('0' & pixel_column) <= pipe2_x_pos + pipe_width and std_logic_vector('0' & pixel_row) >= std_logic_vector(to_unsigned((gap_pos_cent2 + gap_half_width), 11)) and std_logic_vector('0' & pixel_row) < screen_height) else
    '0';

  pipe2_top <= '1' when (std_logic_vector('0' & pixel_column) >= pipe2_x_pos and std_logic_vector('0' & pixel_column) <= pipe2_x_pos + pipe_width and std_logic_vector('0' & pixel_row) <= std_logic_vector(to_unsigned((gap_pos_cent2 - gap_half_width), 11)) and std_logic_vector('0' & pixel_row) > std_logic_vector(to_unsigned(0, 11))) else
    '0';

  pipe3_bot <= '1' when (std_logic_vector('0' & pixel_column) >= pipe3_x_pos and std_logic_vector('0' & pixel_column) <= pipe3_x_pos + pipe_width and std_logic_vector('0' & pixel_row) >= std_logic_vector(to_unsigned((gap_pos_cent3 + gap_half_width), 11)) and std_logic_vector('0' & pixel_row) < screen_height) else
    -- Same for the third pipe  
    pipe3_bot <= '1' when (impossible_mode_out = '1') and (unsigned('0' & pixel_column) <= pipe3_x_pos and unsigned('0' & pixel_column) >= pipe3_x_pos - pipe_width and unsigned('0' & pixel_row) >= to_unsigned((gap_pos_cent3 + gap_half_width), 11) and '0' & pixel_row < std_logic_vector(screen_height)) else
    '0';

  pipe3_top <= '1' when (std_logic_vector('0' & pixel_column) >= pipe3_x_pos and std_logic_vector('0' & pixel_column) <= pipe3_x_pos + pipe_width and std_logic_vector('0' & pixel_row) <= std_logic_vector(to_unsigned((gap_pos_cent3 - gap_half_width), 11)) and std_logic_vector('0' & pixel_row) > std_logic_vector(to_unsigned(0, 11))) else
    pipe3_top <= '1' when (impossible_mode_out = '1') and (unsigned('0' & pixel_column) <= pipe3_x_pos and unsigned('0' & pixel_column) >= pipe3_x_pos - pipe_width and unsigned('0' & pixel_row) <= to_unsigned((gap_pos_cent3 - gap_half_width), 11) and '0' & pixel_row > std_logic_vector(to_unsigned(0, 11))) else
    '0';

  pipe_on <= '1' when (((pipe_top = '1') or (pipe_bot = '1') or (pipe2_top = '1') or (pipe2_bot = '1') or (pipe3_top = '1') or (pipe3_bot = '1')) and (normal_mode = '1')) else
    '1' when (((pipe_top = '1') or (pipe_bot = '1') or (pipe2_top = '1') or (pipe2_bot = '1') or (pipe3_top = '1') or (pipe3_bot = '1')) and (training_mode = '1')) else
    '1' when (((pipe_top = '1') or (pipe_bot = '1') or (pipe2_top = '1') or (pipe2_bot = '1') or (pipe3_top = '1') or (pipe3_bot = '1')) and (training_mode = '1')) else
    '0';

  piped_pass <= '1' when (std_logic_vector(to_unsigned(150, 11)) > pipe_x_pos) else -- bird x_position 
    '1' when (std_logic_vector(to_unsigned(150, 11)) > pipe2_x_pos) else
    '1' when (std_logic_vector(to_unsigned(150, 11)) > pipe3_x_pos and impossible_mode_out = '1') else
    '0';

end architecture;