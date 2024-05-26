library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity powerups is
  port
  (
<<<<<<< HEAD
    normal_mode, training_mode, clk, reset, vert_sync                  : in std_logic;
    easy_mode_out, medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
    pixel_row, pixel_column                                            : in std_logic_vector(9 downto 0);
    powerup_on                                                         : out std_logic;
    powerup_type                                                       : out std_logic_vector(2 downto 0)
=======
    normal_mode, training_mode, clk, reset, vert_sync : in std_logic;
    easy_mode_out, medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    pipe_on : in std_logic;
    powerup_on : out std_logic;
    powerup_type : out std_logic_vector(2 downto 0)
>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f
  );
end entity;

architecture behaviour of powerups is
<<<<<<< HEAD
  signal powerup_on_int                          : std_logic;
  signal screen_width, screen_height, power_width : std_logic_vector(10 downto 0);
  signal powerup_type_int                        : std_logic_vector(2 downto 0);
  signal random_number                           : std_logic_vector(7 downto 0);
  signal speed                                   : integer range 0 to 6;
  signal powerup_x_pos, powerup_y_pos            : std_logic_vector(10 downto 0);
  
=======
  signal powerup_on_int : std_logic;
  signal screen_width, screen_height, power_width : std_logic_vector(10 downto 0);
  signal powerup_type_int : std_logic_vector(2 downto 0);
  signal random_number : std_logic_vector(7 downto 0);
  signal speed : integer range 0 to 6;
  signal powerup_x_pos, powerup_y_pos: std_logic_vector(10 downto 0);
>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f

  component GaloisLFSR8 is
    port
    (
      clk, reset : in std_logic;
      lfsr_out   : out std_logic_vector(7 downto 0)
    );
  end component;
<<<<<<< HEAD

begin
=======
  
  begin  
>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f

  -- Screen width and Width of the powerup
  screen_width  <= CONV_STD_LOGIC_VECTOR(639, 11); -- 640 in binary
  screen_height <= CONV_STD_LOGIC_VECTOR(479, 11); -- 480 in binary
<<<<<<< HEAD
  power_width   <= CONV_STD_LOGIC_VECTOR(8, 11); -- 100 in binary
=======
  power_width    <= CONV_STD_LOGIC_VECTOR(8, 11); -- 8 in binary
>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f

  LFSR1 : GaloisLFSR8
  port map
  (
    clk      => clk,
    reset    => '0',
    lfsr_out => random_number
  );

<<<<<<< HEAD
  -- Speed of powerup for each difficulty
=======
    -- Speed of powerup for each difficulty
>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f
  difficulty : process (easy_mode_out, medium_mode_out, hard_mode_out, impossible_mode_out)
  begin
    if (easy_mode_out = '1') then
      speed <= 2;
    elsif (medium_mode_out = '1') then
      speed <= 3;
    elsif (hard_mode_out = '1') then
<<<<<<< HEAD
      speed <= 4;
    elsif (impossible_mode_out = '1') then
      speed <= 6;
    else
      speed <= 5;
    end if;
  end process;

  -- Powerup generation
  powerup_movement : process (vert_sync)
  begin
    if rising_edge(vert_sync) then
      if powerup_x_pos <= CONV_STD_LOGIC_VECTOR(0, 11) then
        --if (pipe_on = '0' and pixel_column = screen_width) then
        powerup_x_pos    <= screen_width + power_width; -- Reset to the right side of the screen
        powerup_type_int <= CONV_STD_LOGIC_VECTOR(conv_integer(unsigned(random_number(7 downto 0))) mod 4, 3); -- Random powerup type
        --end if;
        powerup_y_pos <= CONV_STD_LOGIC_VECTOR(conv_integer(unsigned(random_number(7 downto 0))) mod 101 + 200, 11);
=======
      speed          <= 4;
    elsif (impossible_mode_out = '1') then
      speed          <= 6;
    else
      speed          <= 5;
    end if;
  end process;

    -- Powerup generation
  powerup_movement : process (vert_sync)
  begin
    if rising_edge(vert_sync) then
      if powerup_x_pos + CONV_STD_LOGIC(50, 11) <= CONV_STD_LOGIC_VECTOR(0, 11) then
        --if (pipe_on = '0' and pixel_column = screen_width) then
            powerup_x_pos    <= screen_width + power_width; -- Reset to the right side of the screen
            powerup_type_int <= CONV_STD_LOGIC_VECTOR(to_integer(unsigned(random_number(7 downto 0))) mod 4, 3); -- Random powerup type
        --end if;
        powerup_y_pos <= CONV_STD_LOGIC_VECTOR(to_integer(unsigned(random_number(7 downto 0))) mod 101 + 200, 11);
>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f
      else
        powerup_x_pos <= powerup_x_pos - CONV_STD_LOGIC_VECTOR(speed, 11); -- movement of powerup
      end if;
    end if;
  end process;

  powerup_type <= powerup_type_int;
<<<<<<< HEAD
  powerup_on <= '1' when (pixel_row <= powerup_y_pos and pixel_row >= powerup_y_pos - power_width and pixel_column <= powerup_x_pos and pixel_column >= powerup_x_pos - power_width) else
    '0';

end architecture behaviour;
=======
  powerup_on <= '1' when (pixel_row <= powerup_y_pos and pixel_row >= (powerup_y_pos - power_width) and pixel_column <= powerup_x_pos and pixel_column >= (powerup_x_pos - power_width)) else '0';

end architecture behaviour;




    


>>>>>>> c29d757d8fd7eca6e0c230be9a41ad0095bb4e0f
