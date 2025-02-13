library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity powerups is
  port
  (
    normal_mode, training_mode, clk, reset, vert_sync : in std_logic;
    easy_mode_out, medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    pipe_on : in std_logic;
    powerup_active : in std_logic;
    powerup_on : out std_logic;
    powerup_type : out std_logic_vector(2 downto 0)
  );
end entity;

architecture behaviour of powerups is
  signal powerup_on_int : std_logic;
  signal screen_width, screen_height, power_width : std_logic_vector(10 downto 0);
  signal powerup_type_int : std_logic_vector(2 downto 0);
  signal random_number : std_logic_vector(7 downto 0);
  signal speed : integer;
  signal powerup_x_pos, powerup_y_pos: std_logic_vector(10 downto 0);

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

  -- Screen width and Width of the powerup
  screen_width  <= CONV_STD_LOGIC_VECTOR(639, 11); -- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(479, 11); -- 480 in binary
  power_width    <= CONV_STD_LOGIC_VECTOR(8, 11); -- 8 in binary

  LFSR1 : GaloisLFSR8
  port map
  (
    clk      => clk,
    reset    => '0',
    lfsr_out => random_number
  );

    -- Speed of powerup for each difficulty
    SPEED_CHANGER : speed_control
  port
  map (
  medium_mode_out, hard_mode_out, impossible_mode_out, speed
  );

  -- Powerup generation
  powerup_movement : process (vert_sync)
  begin
    if rising_edge(vert_sync) then
      if powerup_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11) then
        --if (pipe_on = '0' and pixel_column = screen_width) then
        powerup_x_pos    <= screen_width; -- Reset to the right side of the screen
        powerup_type_int <= CONV_STD_LOGIC_VECTOR(conv_integer(unsigned(random_number(7 downto 0))) mod 5, 3); -- Random powerup type
        --end if;
        powerup_y_pos <= CONV_STD_LOGIC_VECTOR(conv_integer(unsigned(random_number(7 downto 0))) mod 101 + 200, 11);
      else
        powerup_x_pos <= powerup_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- movement of powerup
      end if;
    end if;
  end process;



  powerup_type <= powerup_type_int;
  powerup_on <= '0' when powerup_active = '1' else
                '1' when (pixel_row <= powerup_y_pos and pixel_row >= (powerup_y_pos - power_width) and pixel_column <= (powerup_x_pos + power_width) and pixel_column >= powerup_x_pos - power_width) else 
                '0';

end architecture behaviour;




    


