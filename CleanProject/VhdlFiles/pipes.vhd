library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
entity pipes is
  port
  (
    clk, reset, vert_sync                                     : in std_logic;
    normal_state, training_state, pause_state, end_game_state : in std_logic;
    medium_mode_out, hard_mode_out, impossible_mode_out       : in std_logic;
    score                                                     : in integer range 0 to 500;
    powerup_active                                            : in std_logic;
    active_powerup_type                                       : in std_logic_vector(2 downto 0);
    pixel_row, pixel_column                                   : in std_logic_vector(9 downto 0);
    pipe_on, piped_pass                                       : out std_logic;
    rgb_pipe                                                  : out std_logic_vector(12 downto 0)
  );
end entity pipes;

architecture behaviour of pipes is

  constant screen_width                              : std_logic_vector              := std_logic_vector(to_unsigned(639, 11)); -- 640 in binary
  constant screen_height                             : std_logic_vector              := std_logic_vector(to_unsigned(479, 11)); -- 480 in binary
  signal pipe_width_int                              : integer                       := 50; -- 100 in binary
  constant pipe_spacing                              : integer                       := 300;
  constant pipe_spacing_hard                         : integer                       := 117;
  signal pipe_x_pos                                  : std_logic_vector(10 downto 0) := screen_width;
  signal pipe2_x_pos                                 : std_logic_vector(10 downto 0) := screen_width + std_logic_vector(to_unsigned(pipe_spacing + pipe_width_int, 11));
  signal pipe3_x_pos                                 : std_logic_vector(10 downto 0) := pipe2_x_pos + std_logic_vector(to_unsigned(pipe_spacing_hard + pipe_width_int, 11));
  signal pipe_width                                  : std_logic_vector(10 downto 0);
  signal pipe_top, pipe_bot                          : std_logic;
  signal pipe2_top, pipe2_bot                        : std_logic;
  signal pipe3_top, pipe3_bot                        : std_logic;
  signal gap_on                                      : std_logic;
  signal gap_half_width                              : integer := 60;
  signal gap_pos_cent1, gap_pos_cent2, gap_pos_cent3 : integer range 100 to 350;
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
      medium_mode_out, hard_mode_out, impossible_mode_out, normal_state : in std_logic;
      speed                                                             : out integer
    );
  end component;

  component gap_width_control is
    port
    (
      medium_mode_out, hard_mode_out, impossible_mode_out, normal_state : in std_logic;
      gap_half_width                                                    : out integer);
  end component gap_width_control;

begin
  -- Screen and pipe dimensiond
  pipe_width_int <= 20 when powerup_active = '1' and active_powerup_type = "011" else
    50;
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
  map
  (
  medium_mode_out     => medium_mode_out,
  hard_mode_out       => hard_mode_out,
  impossible_mode_out => impossible_mode_out,
  normal_state        => normal_state,
  speed               => speed
  );

  GAP_WIDTH : gap_width_control
  port
  map
  (
  medium_mode_out     => medium_mode_out,
  hard_mode_out       => hard_mode_out,
  impossible_mode_out => impossible_mode_out,
  normal_state        => normal_state,
  gap_half_width      => gap_half_width
  );
  -- Initialize pipe starting position on the right side of the screen
  --pipe_x_pos    <= screen_width + pipe_width; -- Start from the far right
  -- Process to set the difficulty level
  -- Process to move the pipes
  pipe_movement : process (clk, vert_sync, random_number, pause_state, end_game_state, normal_state, training_state)
    variable prev_x1, prev_x2, prev_x3 : std_logic_vector(10 downto 0);
  begin
    if rising_edge(vert_sync) then
      if (pause_state = '1' or end_game_state = '1') then
        pipe_x_pos  <= prev_x1;
        pipe2_x_pos <= prev_x2;
        -- pipe3_x_pos <= prev_x3;
      elsif (normal_state = '1' or training_state = '1') then
        if pipe_x_pos <= - pipe_width_int then
          pipe_x_pos    <= screen_width; -- Reset to the right side of the screen
          if (to_integer(unsigned(random_number)) < 100) then
            gap_pos_cent1 <= 100;
          else
            gap_pos_cent1 <= to_integer(unsigned(random_number));
          end if;
        else
          pipe_x_pos <= pipe_x_pos - std_logic_vector(to_unsigned(speed, 11)); -- movement of pipe 1 
          prev_x1 := pipe_x_pos;
        end if;

        if pipe2_x_pos <= - pipe_width_int then
          pipe2_x_pos    <= pipe_x_pos + std_logic_vector(to_unsigned(pipe_spacing + pipe_width_int, 11)); -- Reset to a position that's a certain distance from the first pipe
          if (to_integer(unsigned(random_number)) < 100) then
            gap_pos_cent2 <= 100;
          else
            gap_pos_cent2 <= to_integer(unsigned(random_number));
          end if;
        else
          pipe2_x_pos <= pipe2_x_pos - std_logic_vector(to_unsigned(speed, 11)); -- Movement of pipe 2
          prev_x2 := pipe2_x_pos;
        end if;

        -- if pipe3_x_pos <= - pipe_width_int then
        --   pipe3_x_pos    <= pipe2_x_pos + std_logic_vector(to_unsigned(pipe_spacing + pipe_width_int, 11)); -- Reset to a position that's a certain distance from the second pipe
        --   if  (to_integer(unsigned(random_number)) < 100) then
        --     gap_pos_cent3 <= 100;
        --   else
        --     gap_pos_cent3 <= to_integer(unsigned(random_number));
        --   end if;
        -- else
        --   pipe3_x_pos <= pipe3_x_pos - std_logic_vector(to_unsigned(speed, 11)); -- Movement of pipe 3
        --   prev_x3     := pipe3_x_pos;
        --end if;
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

  -- pipe3_bot <= '1' when (std_logic_vector('0' & pixel_column) >= pipe3_x_pos and std_logic_vector('0' & pixel_column) <= pipe3_x_pos + pipe_width and std_logic_vector('0' & pixel_row) >= std_logic_vector(to_unsigned((gap_pos_cent3 + gap_half_width), 11)) and std_logic_vector('0' & pixel_row) < screen_height) else
  --   '0';

  -- pipe3_top <= '1' when (std_logic_vector('0' & pixel_column) >= pipe3_x_pos and std_logic_vector('0' & pixel_column) <= pipe3_x_pos + pipe_width and std_logic_vector('0' & pixel_row) <= std_logic_vector(to_unsigned((gap_pos_cent3 - gap_half_width), 11)) and std_logic_vector('0' & pixel_row) > std_logic_vector(to_unsigned(0, 11))) else
  --   '0';

  pipe_on <= '1' when (((pipe_top = '1') or (pipe_bot = '1') or (pipe2_top = '1') or (pipe2_bot = '1') or (pipe3_top = '1') or (pipe3_bot = '1'))) else
    '0';

  piped_pass <= '1' when (std_logic_vector(to_unsigned(160, 11)) > pipe_x_pos or std_logic_vector(to_unsigned(460, 11)) > pipe_x_pos) else
    '0';

  rgb_pipe <= "0001111100011";

end architecture;