library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lives_text is
  port
  (
    state                   : in std_logic_vector(3 downto 0);
    clk, pb2                : in std_logic;
    collisions_input        : in integer;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    text_out                : out std_logic
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
  signal u_char_address : std_logic_vector(5 downto 0);
  signal u_f_row, u_f_col     : std_logic_vector(2 downto 0);
  signal u_rom_mux_out        : std_logic;
  signal state_x              : std_logic_vector(3 downto 0);
  signal collision_counter    : integer := 0;

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

  state_chooser : process (state, pixel_row, pixel_column, collision_counter)
  begin
    collision_counter <= collision_counter + collisions_input;
    case state is
      when "0000" => -- Menu Text - State 0
        u_f_row                                     <= pixel_row(4 downto 2);
        u_f_col                                     <= pixel_column(4 downto 2);
        if (pixel_row >= 151 and pixel_row          <= 182) then -- MAIN TITLE
          if (pixel_column >= 145 and pixel_column    <= 176) then
            u_char_address                              <= "000110"; -- F
          elsif (pixel_column >= 177 and pixel_column <= 208) then
            u_char_address                              <= "001100"; -- L
          elsif (pixel_column >= 209 and pixel_column <= 240) then
            u_char_address                              <= "000001"; -- A
          elsif (pixel_column >= 241 and pixel_column <= 272) then
            u_char_address                              <= "010000"; -- P
          elsif (pixel_column >= 273 and pixel_column <= 304) then
            u_char_address                              <= "010000"; -- P
          elsif (pixel_column >= 305 and pixel_column <= 336) then
            u_char_address                              <= "011001"; -- Y
          elsif (pixel_column >= 337 and pixel_column <= 368) then
            u_char_address                              <= "100000"; -- Space
          elsif (pixel_column >= 369 and pixel_column <= 400) then
            u_char_address                              <= "000010"; -- B
          elsif (pixel_column >= 401 and pixel_column <= 432) then
            u_char_address                              <= "001001"; -- I
          elsif (pixel_column >= 433 and pixel_column <= 464) then
            u_char_address                              <= "010010"; -- R
          elsif (pixel_column >= 465 and pixel_column <= 496) then
            u_char_address                              <= "000100"; -- D
          else
            u_char_address <= "100000"; -- Space
          end if;
        elsif (pixel_row >= 201 and pixel_row       <= 208) then -- TRAINING BUTTON
          if (pixel_column >= 289 and pixel_column    <= 296) then
            u_char_address                              <= "010100"; -- T
          elsif (pixel_column >= 297 and pixel_column <= 304) then
            u_char_address                              <= "010010"; -- R
          elsif (pixel_column >= 305 and pixel_column <= 312) then
            u_char_address                              <= "000001"; -- A
          elsif (pixel_column >= 313 and pixel_column <= 320) then
            u_char_address                              <= "001001"; -- I
          elsif (pixel_column >= 321 and pixel_column <= 328) then
            u_char_address                              <= "001110"; -- N
          elsif (pixel_column >= 329 and pixel_column <= 336) then
            u_char_address                              <= "001001"; -- I
          elsif (pixel_column >= 337 and pixel_column <= 344) then
            u_char_address                              <= "001110"; -- N
          elsif (pixel_column >= 345 and pixel_column <= 352) then
            u_char_address                              <= "000111"; -- G
          else
            u_char_address <= "100000"; -- Space
          end if;
        elsif (pixel_row >= 215 and pixel_row       <= 222) then -- PLAY BUTTON
          if (pixel_column >= 305 and pixel_column    <= 312) then
            u_char_address                              <= "010000"; -- P
          elsif (pixel_column >= 313 and pixel_column <= 320) then
            u_char_address                              <= "001100"; -- L
          elsif (pixel_column >= 321 and pixel_column <= 328) then
            u_char_address                              <= "000001"; -- A
          elsif (pixel_column >= 329 and pixel_column <= 336) then
            u_char_address                              <= "011001"; -- Y
          else
            u_char_address <= "100000"; -- Space
          end if;
        elsif (pixel_row >= 231 and pixel_row       <= 238) then -- SETTINGS BUTTON
          if (pixel_column >= 296 and pixel_column    <= 303) then
            u_char_address                              <= "010011"; -- S
          elsif (pixel_column >= 304 and pixel_column <= 311) then
            u_char_address                              <= "000101"; -- E
          elsif (pixel_column >= 312 and pixel_column <= 319) then
            u_char_address                              <= "010100"; -- T
          elsif (pixel_column >= 320 and pixel_column <= 327) then
            u_char_address                              <= "010100"; -- T
          elsif (pixel_column >= 328 and pixel_column <= 335) then
            u_char_address                              <= "001001"; -- I
          elsif (pixel_column >= 336 and pixel_column <= 343) then
            u_char_address                              <= "001110"; -- N
          elsif (pixel_column >= 344 and pixel_column <= 351) then
            u_char_address                              <= "000111"; -- G
          elsif (pixel_column >= 352 and pixel_column <= 359) then
            u_char_address                              <= "010011"; -- S
          else
            u_char_address <= "100000"; -- Space
          end if;
        else
          u_char_address <= "100000"; -- Space
        end if;

      when "0001" => -- Training Mode
        u_f_row <= pixel_row(3 downto 1);
        u_f_col <= pixel_column(3 downto 1);
        if collision_counter = 0 then
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
        elsif collision_counter = 1 then
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
        elsif collision_counter = 2 then
          if (pixel_row >= 31 and pixel_row        <= 46) then
            if (pixel_column >= 527 and pixel_column <= 542) then
              u_char_address                           <= "000000"; -- 0
            else
              u_char_address <= "100000"; -- Space
            end if;
          end if;
        end if;
      when others =>
        u_char_address <= "100000"; -- Space
    end case;
  end process;

  text_out <= u_rom_mux_out;
end behaviour;