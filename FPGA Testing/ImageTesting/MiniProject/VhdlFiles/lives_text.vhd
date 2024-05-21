library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lives_text is
  port
  (
    menu_mode               : in std_logic;
    training_mode           : in std_logic;
    normal_mode             : in std_logic;
    settings_mode           : in std_logic;
    pause_training_mode     : in std_logic;
    pause_normal_mode       : in std_logic;
    clk, pb2                : in std_logic;
    collisions_input        : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    text_lives_out          : out std_logic
  );
end lives_text;

architecture behaviour of lives_text is
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
  signal u_char_address    : std_logic_vector(5 downto 0);
  signal u_f_row, u_f_col  : std_logic_vector(2 downto 0);
  signal u_rom_mux_out     : std_logic;
  signal state_x           : std_logic_vector(3 downto 0);
  signal collision_counter : std_logic_vector(7 downto 0) := "00000000";

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

  collisions_to_lives : process (collisions_input)
  begin
    collision_counter <= collision_counter + collisions_input; -- increment collision counter when triggered
    if collision_counter > 151 then
      collision_counter <= "00000000";
    end if;
  end process;

  state_chooser : process (menu_mode, training_mode, normal_mode, settings_mode, pause_training_mode, pause_normal_mode, pixel_row, pixel_column, collision_counter)
  begin
    if (menu_mode = '1') then -- Menu Text - State 0
      if (pixel_row >= 159 and pixel_row          <= 190) then
        u_f_row                                     <= pixel_row(4 downto 2);
        u_f_col                                     <= pixel_column(4 downto 2);
        if (pixel_column >= 127 and pixel_column    <= 158) then
          u_char_address                              <= "000110"; -- F
        elsif (pixel_column >= 159 and pixel_column <= 190) then
          u_char_address                              <= "001100"; -- L
        elsif (pixel_column >= 191 and pixel_column <= 222) then
          u_char_address                              <= "000001"; -- A
        elsif (pixel_column >= 223 and pixel_column <= 254) then
          u_char_address                              <= "010000"; -- P
        elsif (pixel_column >= 255 and pixel_column <= 286) then
          u_char_address                              <= "010000"; -- P
        elsif (pixel_column >= 287 and pixel_column <= 318) then
          u_char_address                              <= "011001"; -- Y
        elsif (pixel_column >= 319 and pixel_column <= 350) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 351 and pixel_column <= 382) then
          u_char_address                              <= "000010"; -- B
        elsif (pixel_column >= 383 and pixel_column <= 414) then
          u_char_address                              <= "001001"; -- I
        elsif (pixel_column >= 415 and pixel_column <= 446) then
          u_char_address                              <= "010010"; -- R
        elsif (pixel_column >= 447 and pixel_column <= 478) then
          u_char_address                              <= "000100"; -- D
        else
          u_char_address <= "100000";
        end if;
      elsif (pixel_row >= 200 and pixel_row       <= 207) then -- CHOOSE MODE
        u_f_row                                     <= pixel_row(2 downto 0);
        u_f_col                                     <= pixel_column(2 downto 0);
        if (pixel_column >= 272 and pixel_column    <= 279) then
          u_char_address                              <= "000011"; -- C
        elsif (pixel_column >= 280 and pixel_column <= 287) then
          u_char_address                              <= "001000"; -- H
        elsif (pixel_column >= 288 and pixel_column <= 295) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 296 and pixel_column <= 303) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 304 and pixel_column <= 311) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 312 and pixel_column <= 319) then
          u_char_address                              <= "000101"; -- E
        elsif (pixel_column >= 320 and pixel_column <= 327) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 328 and pixel_column <= 335) then
          u_char_address                              <= "001101"; -- M
        elsif (pixel_column >= 336 and pixel_column <= 343) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 344 and pixel_column <= 351) then
          u_char_address                              <= "000100"; -- D
        elsif (pixel_column >= 352 and pixel_column <= 359) then
          u_char_address                              <= "000101"; -- E
        else
          u_char_address <= "100000";
        end if;
      elsif (pixel_row >= 216 and pixel_row       <= 223) then -- TRAINING MODE - SW0 DOWN
        u_f_row                                     <= pixel_row(2 downto 0);
        u_f_col                                     <= pixel_column(2 downto 0);
        if (pixel_column >= 224 and pixel_column    <= 231) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 232 and pixel_column <= 239) then
          u_char_address                              <= "010010"; -- R
        elsif (pixel_column >= 240 and pixel_column <= 247) then
          u_char_address                              <= "000001"; -- A
        elsif (pixel_column >= 248 and pixel_column <= 255) then
          u_char_address                              <= "001001"; -- I
        elsif (pixel_column >= 256 and pixel_column <= 263) then
          u_char_address                              <= "001110"; -- N
        elsif (pixel_column >= 264 and pixel_column <= 271) then
          u_char_address                              <= "001001"; -- I
        elsif (pixel_column >= 272 and pixel_column <= 279) then
          u_char_address                              <= "001110"; -- N
        elsif (pixel_column >= 280 and pixel_column <= 287) then
          u_char_address                              <= "000111"; -- G
        elsif (pixel_column >= 288 and pixel_column <= 295) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 296 and pixel_column <= 303) then
          u_char_address                              <= "001101"; -- M
        elsif (pixel_column >= 304 and pixel_column <= 311) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 312 and pixel_column <= 319) then
          u_char_address                              <= "000100"; -- D
        elsif (pixel_column >= 320 and pixel_column <= 327) then
          u_char_address                              <= "000101"; -- E
        elsif (pixel_column >= 328 and pixel_column <= 335) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 352 and pixel_column <= 359) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 360 and pixel_column <= 367) then
          u_char_address                              <= "010111"; -- W
        elsif (pixel_column >= 368 and pixel_column <= 375) then
          u_char_address                              <= "110000"; -- 0
        elsif (pixel_column >= 376 and pixel_column <= 383) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 384 and pixel_column <= 391) then
          u_char_address                              <= "000100"; -- D
        elsif (pixel_column >= 392 and pixel_column <= 399) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 400 and pixel_column <= 407) then
          u_char_address                              <= "010111"; -- W
        elsif (pixel_column >= 408 and pixel_column <= 415) then
          u_char_address                              <= "001110"; -- N
        else
          u_char_address <= "100000";
        end if;
      elsif (pixel_row >= 232 and pixel_row       <= 239) then -- NORMAL MODE - SW0 UP
        u_f_row                                     <= pixel_row(2 downto 0);
        u_f_col                                     <= pixel_column(2 downto 0);
        if (pixel_column >= 224 and pixel_column    <= 231) then
          u_char_address                              <= "001110"; -- N
        elsif (pixel_column >= 232 and pixel_column <= 239) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 240 and pixel_column <= 247) then
          u_char_address                              <= "010010"; -- R
        elsif (pixel_column >= 248 and pixel_column <= 255) then
          u_char_address                              <= "001101"; -- M
        elsif (pixel_column >= 256 and pixel_column <= 263) then
          u_char_address                              <= "000001"; -- A
        elsif (pixel_column >= 264 and pixel_column <= 271) then
          u_char_address                              <= "001100"; -- L
        elsif (pixel_column >= 272 and pixel_column <= 279) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 280 and pixel_column <= 287) then
          u_char_address                              <= "001101"; -- M
        elsif (pixel_column >= 288 and pixel_column <= 295) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 296 and pixel_column <= 303) then
          u_char_address                              <= "000100"; -- D
        elsif (pixel_column >= 304 and pixel_column <= 311) then
          u_char_address                              <= "000101"; -- E
        elsif (pixel_column >= 352 and pixel_column <= 359) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 360 and pixel_column <= 367) then
          u_char_address                              <= "010111"; -- W
        elsif (pixel_column >= 368 and pixel_column <= 375) then
          u_char_address                              <= "110001"; -- 1
        elsif (pixel_column >= 376 and pixel_column <= 383) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 384 and pixel_column <= 391) then
          u_char_address                              <= "000100"; -- D
        elsif (pixel_column >= 392 and pixel_column <= 399) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 400 and pixel_column <= 407) then
          u_char_address                              <= "010111"; -- W
        elsif (pixel_column >= 408 and pixel_column <= 415) then
          u_char_address                              <= "001110"; -- N
        else
          u_char_address <= "100000";
        end if;
      elsif (pixel_row >= 248 and pixel_row       <= 255) then -- SETTINGS MODE - SW1 DOWN
        u_f_row                                     <= pixel_row(2 downto 0);
        u_f_col                                     <= pixel_column(2 downto 0);
        if (pixel_column >= 224 and pixel_column    <= 231) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 232 and pixel_column <= 239) then
          u_char_address                              <= "000101"; -- E
        elsif (pixel_column >= 240 and pixel_column <= 247) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 248 and pixel_column <= 255) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 256 and pixel_column <= 263) then
          u_char_address                              <= "001001"; -- I
        elsif (pixel_column >= 264 and pixel_column <= 271) then
          u_char_address                              <= "001110"; -- N
        elsif (pixel_column >= 272 and pixel_column <= 279) then
          u_char_address                              <= "000111"; -- G
        elsif (pixel_column >= 280 and pixel_column <= 287) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 352 and pixel_column <= 359) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 360 and pixel_column <= 367) then
          u_char_address                              <= "010111"; -- W
        elsif (pixel_column >= 368 and pixel_column <= 375) then
          u_char_address                              <= "110011"; -- 3
        elsif (pixel_column >= 376 and pixel_column <= 383) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 384 and pixel_column <= 391) then
          u_char_address                              <= "000100"; -- D
        elsif (pixel_column >= 392 and pixel_column <= 399) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 400 and pixel_column <= 407) then
          u_char_address                              <= "010111"; -- W
        elsif (pixel_column >= 408 and pixel_column <= 415) then
          u_char_address                              <= "001110"; -- N
        else
          u_char_address <= "100000";
        end if;
      elsif (pixel_row >= 272 and pixel_row       <= 287) then
        u_f_row                                     <= pixel_row(3 downto 1);
        u_f_col                                     <= pixel_column(3 downto 1);
        if (pixel_column >= 208 and pixel_column    <= 223) then
          u_char_address                              <= "000011"; -- C
        elsif (pixel_column >= 224 and pixel_column <= 239) then
          u_char_address                              <= "001100"; -- L
        elsif (pixel_column >= 240 and pixel_column <= 255) then
          u_char_address                              <= "001001"; -- I
        elsif (pixel_column >= 256 and pixel_column <= 271) then
          u_char_address                              <= "000011"; -- C
        elsif (pixel_column >= 272 and pixel_column <= 287) then
          u_char_address                              <= "001011"; -- K
        elsif (pixel_column >= 288 and pixel_column <= 303) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 304 and pixel_column <= 319) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 320 and pixel_column <= 335) then
          u_char_address                              <= "001111"; -- O
        elsif (pixel_column >= 336 and pixel_column <= 351) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 352 and pixel_column <= 367) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 368 and pixel_column <= 383) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 384 and pixel_column <= 399) then
          u_char_address                              <= "000001"; -- A
        elsif (pixel_column >= 400 and pixel_column <= 415) then
          u_char_address                              <= "010010"; -- R
        elsif (pixel_column >= 416 and pixel_column <= 431) then
          u_char_address                              <= "010100"; -- T
        else
          u_char_address <= "100000";
        end if;
      else
        u_char_address <= "100000";
      end if;
    elsif (training_mode = '1') then -- Training Mode
      u_f_row <= pixel_row(3 downto 1);
      u_f_col <= pixel_column(3 downto 1);
      if (collision_counter > 0) then -- show three lives
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
      elsif (collision_counter >= 50 and collision_counter < 99) then -- show two lives
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
      elsif (collision_counter >= 100 and collision_counter < 150) then -- show one life
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
    elsif (normal_mode = '1') then --show one life only
      u_f_row <= pixel_row(3 downto 1);
      u_f_col <= pixel_column(3 downto 1);
      if (collision_counter = 0) then
        if (pixel_row >= 31 and pixel_row        <= 46) then
          if (pixel_column >= 527 and pixel_column <= 542) then
            u_char_address                           <= "000000"; -- 0
          else
            u_char_address <= "100000"; -- Space    
          end if;
        end if;
      end if;
    elsif (pause_training_mode = '1' or pause_normal_mode = '1') then
      u_f_row                                     <= pixel_row(3 downto 1);
      u_f_col                                     <= pixel_column(3 downto 1);
      if (pixel_row >= 128 and pixel_row          <= 143) then
        if (pixel_column >= 288 and pixel_column    <= 303) then
          u_char_address                              <= "010000"; -- P
        elsif (pixel_column >= 304 and pixel_column <= 319) then
          u_char_address                              <= "000001"; -- A
        elsif (pixel_column >= 320 and pixel_column <= 335) then
          u_char_address                              <= "010101"; -- U
        elsif (pixel_column >= 336 and pixel_column <= 351) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 352 and pixel_column <= 367) then
          u_char_address                              <= "010001"; -- E
        else
          u_char_address <= "100000"; -- Space
        end if;
      elsif (pixel_row >= 160 and pixel_row       <= 167) then
        if (pixel_column >= 272 and pixel_column    <= 279) then
          u_char_address                              <= "010010"; -- R
        elsif (pixel_column >= 280 and pixel_column <= 287) then
          u_char_address                              <= "010001"; -- E
        elsif (pixel_column >= 288 and pixel_column <= 295) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 296 and pixel_column <= 303) then
          u_char_address                              <= "010101"; -- U
        elsif (pixel_column >= 304 and pixel_column <= 311) then
          u_char_address                              <= "001101"; -- M
        elsif (pixel_column >= 312 and pixel_column <= 319) then
          u_char_address                              <= "010001"; -- E
        elsif (pixel_column >= 320 and pixel_column <= 327) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 328 and pixel_column <= 335) then
          u_char_address                              <= "101101"; -- -
        elsif (pixel_column >= 336 and pixel_column <= 343) then
          u_char_address                              <= "100000"; -- space
        elsif (pixel_column >= 344 and pixel_column <= 351) then
          u_char_address                              <= "001011"; -- K
        elsif (pixel_column >= 352 and pixel_column <= 359) then
          u_char_address                              <= "110011"; -- 3
        else
          u_char_address <= "100000"; -- Space
        end if;
      elsif (pixel_row >= 176 and pixel_row       <= 183) then
        if (pixel_column >= 272 and pixel_column    <= 279) then
          u_char_address                              <= "001101"; -- M
        elsif (pixel_column >= 280 and pixel_column <= 287) then
          u_char_address                              <= "000101"; -- E
        elsif (pixel_column >= 288 and pixel_column <= 295) then
          u_char_address                              <= "001110"; -- N
        elsif (pixel_column >= 296 and pixel_column <= 303) then
          u_char_address                              <= "010101"; -- U
        elsif (pixel_column >= 320 and pixel_column <= 327) then
          u_char_address                              <= "100000"; -- Space
        elsif (pixel_column >= 328 and pixel_column <= 335) then
          u_char_address                              <= "101101"; -- -
        elsif (pixel_column >= 336 and pixel_column <= 343) then
          u_char_address                              <= "100000"; -- space
        elsif (pixel_column >= 344 and pixel_column <= 351) then
          u_char_address                              <= "001011"; -- K
        elsif (pixel_column >= 352 and pixel_column <= 359) then
          u_char_address                              <= "110000"; -- 0
        else
          u_char_address <= "100000"; -- Space
        end if;
      else
        u_char_address <= "100000";
      end if;
    elsif (settings_mode = '1') then
      u_f_row                                     <= pixel_row(3 downto 1);
      u_f_col                                     <= pixel_column(3 downto 1);
      if (pixel_row >= 64 and pixel_row           <= 79) then
        if (pixel_column >= 288 and pixel_column    <= 303) then
          u_char_address                              <= "010011"; -- S
        elsif (pixel_column >= 304 and pixel_column <= 319) then
          u_char_address                              <= "000101"; -- E
        elsif (pixel_column >= 320 and pixel_column <= 335) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 336 and pixel_column <= 351) then
          u_char_address                              <= "010100"; -- T
        elsif (pixel_column >= 352 and pixel_column <= 367) then
          u_char_address                              <= "001001"; -- I
        elsif (pixel_column >= 368 and pixel_column <= 383) then
          u_char_address                              <= "001110"; -- N
        elsif (pixel_column >= 384 and pixel_column <= 399) then
          u_char_address                              <= "000111"; -- G
        elsif (pixel_column >= 400 and pixel_column <= 415) then
          u_char_address                              <= "010011"; -- S
        else
          u_char_address <= "100000"; -- Space
        end if;
      end if;
    else
      u_char_address <= "100000";
    end if;
end process;

text_lives_out <= u_rom_mux_out;
end behaviour;