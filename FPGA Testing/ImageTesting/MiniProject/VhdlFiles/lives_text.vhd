library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lives_display is
  port
  (
    clk, training_state, normal_state, pause_training_state, pause_normal_state : in std_logic;
    collision_counter                                                           : in std_logic_vector(1 downto 0);
    pixel_row, pixel_column                                                     : in std_logic_vector(9 downto 0);
    lives_out                                                                   : out std_logic
  );
end lives_display;

architecture behaviour of lives_display is
  --char_rom initialised here
  component char_rom is
    port
    (
      character_address  : in std_logic_vector (5 downto 0);
      font_row, font_col : in std_logic_vector (2 downto 0);
      clock              : in std_logic;
      rom_mux_output     : out std_logic
    );
  end component;

  --variables and signals declared here
  signal u_char_address   : std_logic_vector(5 downto 0);
  signal u_f_row, u_f_col : std_logic_vector(2 downto 0);
  signal u_rom_mux_out    : std_logic;

begin
  char_rom_inst : char_rom
  port map
  (
    character_address => u_char_address,
    font_row          => u_f_row,
    font_col          => u_f_col,
    clock             => clk,
    rom_mux_output    => u_rom_mux_out
  );

  state_chooser : process (training_state, normal_state, pause_training_state, pause_normal_state, pixel_row, pixel_column, collision_counter)
  begin
    if (training_state = '1') then -- Training state
      u_f_row <= pixel_row(3 downto 1);
      u_f_col <= pixel_column(3 downto 1);
      if (collision_counter = "00") then -- show three lives
        if (pixel_row >= 31 and pixel_row           <= 46) then
          if (pixel_column >= 527 and pixel_column    <= 542) then
            u_char_address                              <= "000000"; -- 0
          elsif (pixel_column >= 543 and pixel_column <= 558) then
            u_char_address                              <= "100000"; -- Space
          elsif (pixel_column >= 559 and pixel_column <= 574) then
            u_char_address                              <= "000000"; -- 0
          elsif (pixel_column >= 575 and pixel_column <= 590) then
            u_char_address                              <= "100000"; -- Space
          elsif (pixel_column >= 591 and pixel_column <= 606) then
            u_char_address                              <= "000000"; -- 0
          else
            u_char_address <= "100000"; -- Space
          end if;
        end if;
      elsif (collision_counter = "01") then -- show two lives
        u_f_row                                     <= pixel_row(3 downto 1);
        u_f_col                                     <= pixel_column(3 downto 1);
        if (pixel_row >= 31 and pixel_row           <= 46) then
          if (pixel_column >= 527 and pixel_column    <= 542) then
            u_char_address                              <= "000000"; -- 0
          elsif (pixel_column >= 543 and pixel_column <= 558) then
            u_char_address                              <= "100000"; -- Space
          elsif (pixel_column >= 559 and pixel_column <= 574) then
            u_char_address                              <= "000000"; -- 0
          else
            u_char_address <= "100000"; -- Space
          end if;
        end if;
      elsif (collision_counter = "10") then -- show one life
        u_f_row                                  <= pixel_row(3 downto 1);
        u_f_col                                  <= pixel_column(3 downto 1);
        if (pixel_row >= 31 and pixel_row        <= 46) then
          if (pixel_column >= 527 and pixel_column <= 542) then
            u_char_address                           <= "000000"; -- 0
          else
            u_char_address <= "100000"; -- Space
          end if;
        end if;
      end if;
    elsif (normal_state = '1') then --show one life only
      u_f_row <= pixel_row(3 downto 1);
      u_f_col <= pixel_column(3 downto 1);
      if (collision_counter = "00") then
        if (pixel_row >= 31 and pixel_row        <= 46) then
          if (pixel_column >= 527 and pixel_column <= 542) then
            u_char_address                           <= "000000"; -- 0
          else
            u_char_address <= "100000"; -- Space    
          end if;
        end if;
      end if;
    else
      u_char_address <= "100000";
    end if;
  end process;

  lives_out <= u_rom_mux_out;
end behaviour;