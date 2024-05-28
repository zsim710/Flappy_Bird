library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity bird is
  port
  (
    clk, left_click, menu_state, pause_state, end_game_state : in std_logic;
    powerup_active                                           : in std_logic;
    active_powerup_type                                      : in std_logic_vector(2 downto 0);
    pixel_row, pixel_column                                  : in std_logic_vector(9 downto 0);
    bird_on                                                  : out std_logic;
    rgb_bird                                                 : out std_logic_vector(12 downto 0)
  );
end entity bird;

architecture behaviour of bird is

  signal size          : std_logic_vector(9 downto 0)  := conv_std_logic_vector(8, 10);
  signal bird_y_pos    : std_logic_vector(9 downto 0)  := "0011110000";
  signal bird_x_pos    : std_logic_vector(10 downto 0) := conv_std_logic_vector(150, 11);
  signal bird_y_motion : std_logic_vector(9 downto 0)  := "0000000010";
  signal bird_x_motion : std_logic_vector(10 downto 0) := "00000000010";
  signal v_bird_on     : std_logic;

  --   component image_rom is
  --     port
  --     (
  --       clock              : in std_logic;
  --       font_row, font_col : in std_logic_vector (3 downto 0);
  --       rom_output         : out std_logic_vector(12 downto 0) -- 1-bit alpha and 12-bit color
  --     );
  --   end component;

  signal u_f_row, u_f_col : std_logic_vector(3 downto 0);
  signal u_rom_mux_out    : std_logic_vector(12 downto 0); -- 1-bit alpha and 12-bit color

begin

  --   image_rom_inst : image_rom
  --   port map
  --   (
  --     clock      => clk,
  --     font_row   => u_f_row,
  --     font_col   => u_f_col,
  --     rom_output => u_rom_mux_out
  --   );

  size <= conv_std_logic_vector(4, 10) when powerup_active = '1' and active_powerup_type = "010" else
    conv_std_logic_vector(16, 10) when powerup_active = '1' and active_powerup_type = "000" else
    conv_std_logic_vector(8, 10);

  Move_bird : process (clk, left_click)
    variable previousYbirdMotion : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);
    variable left_click_pressed  : std_logic                    := '0';
  begin
    -- Move bird once every vert_sync
    if (pause_state = '1' or end_game_state = '1') then
      bird_y_motion <= "0000000000";
    elsif (menu_state = '1') then
      bird_y_pos    <= "0011110000";
      bird_y_motion <= - CONV_STD_LOGIC_VECTOR(1, 10);
    else
      if (bird_y_motion = "0000000000" and previousYbirdMotion /= "0000000000") then
        previousYbirdMotion := previousYbirdMotion; --remember motion if paused
      end if;
      if (rising_edge(clk)) then
        -- Apply gravity effect
        if (left_click_pressed = '0' and left_click = '1') then -- Check if left click is pressed
          bird_y_motion <= previousYbirdMotion + conv_std_logic_vector(1, 10); -- Increase downward motion
          if (bird_y_motion = conv_std_logic_vector(15, 10)) then
            bird_y_motion <= conv_std_logic_vector(15, 10);
          end if;

          -- Check if left click is active (jump)
        elsif (left_click = '0' and left_click_pressed = '0') then
          -- Apply upward impulse for a short duration
          bird_y_motion <= - CONV_STD_LOGIC_VECTOR(7, 10); -- Set initial upward motion

        elsif (left_click = '1') then
          left_click_pressed := '0';
        end if;

        --Condition if bird hits ground
        if (('0' & bird_y_pos >= CONV_STD_LOGIC_VECTOR(450, 10) - size)) then
          bird_y_motion           <= - CONV_STD_LOGIC_VECTOR(1, 10);
        elsif ('0' & bird_y_pos <= size + 8) then
          bird_y_motion           <= CONV_STD_LOGIC_VECTOR(1, 10);
        end if;

        -- Update bird position
        bird_y_pos <= bird_y_pos + bird_y_motion;

        -- Update previous motion for next iteration
        previousYbirdMotion := bird_y_motion;
      end if;
    end if;
  end process;

  SPRITE : process (v_bird_on, pixel_column, pixel_row)
    variable temp_c    : unsigned(10 downto 0) := (others => '0');
    variable temp_r    : unsigned(9 downto 0)  := (others => '0');
    variable half_size : std_logic_vector(8 downto 0);
  begin

    -- Displaying the position of bird for priority_controller to draw
    if ('0' & bird_x_pos <= '0' & pixel_column + size) and ('0' & pixel_column <= '0' & bird_x_pos + size) and
      ('0' & bird_y_pos <= pixel_row + size) and ('0' & pixel_row <= bird_y_pos + size) then
      v_bird_on <= '1';
    else
      v_bird_on <= '0';
    end if;

    half_size := size(8 downto 1) & '0';
    if (v_bird_on = '1') then
      temp_c := unsigned(pixel_column) - unsigned(bird_x_pos) - unsigned(half_size);
      temp_r := unsigned(pixel_row) - unsigned(bird_y_pos) - unsigned(half_size);
    else
      temp_c := (others => '0');
      temp_r := (others => '0');
    end if;

    u_f_row <= std_logic_vector(temp_r(3 downto 0));
    u_f_col <= std_logic_vector(temp_c(3 downto 0));
  end process;

  bird_on  <= v_bird_on;
  rgb_bird <= "0111100000000";
end behaviour;