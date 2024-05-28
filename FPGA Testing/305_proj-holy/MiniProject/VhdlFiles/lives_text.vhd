library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity lives_text is
  port
  (
    clk, pb2                : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    text_out                : out std_logic);
end lives_text;

architecture behaviour of lives_text is
  component char_rom is
    port
    (
      character_address  : in std_logic_vector (5 downto 0);
      font_row, font_col : in std_logic_vector (2 downto 0);
      clock              : in std_logic;
      rom_mux_output     : out std_logic);
  end component;

  signal u_char_address   : std_logic_vector(5 downto 0);
  signal u_f_row, u_f_col : std_logic_vector(2 downto 0);
  signal u_rom_mux_out    : std_logic;
  signal text_on          : std_logic;
  signal char_size        : std_logic_vector(9 downto 0);
  signal char_y           : std_logic_vector(9 downto 0);
  signal l_x              : std_logic_vector(9 downto 0);
  signal i_x              : std_logic_vector(9 downto 0);
  signal v_x              : std_logic_vector(9 downto 0);
  signal e_x              : std_logic_vector(9 downto 0);
  signal s_x              : std_logic_vector(9 downto 0);
  signal colon_x          : std_logic_vector(9 downto 0);
  signal three_x          : std_logic_vector(9 downto 0);

  function letter_range(letter : std_logic_vector(9 downto 0); size : std_logic_vector(9 downto 0); pixel_col : std_logic_vector(9 downto 0); pixel_r : std_logic_vector(9 downto 0); c_y : std_logic_vector(9 downto 0)) return boolean is
  begin
    return (('0' & letter <= pixel_col + (size - 1)) and ('0' & pixel_col <= letter + (size - 1))
    and ('0' & c_y <= pixel_r + size) and ('0' & pixel_r <= c_y + size));
  end function;
begin
  chracters : char_rom
  port map
  (
    character_address => u_char_address,
    font_row          => u_f_row,
    font_col          => u_f_col,
    clock             => clk,
    rom_mux_output    => u_rom_mux_out);

  char_size <= conv_std_logic_vector(4, 10); -- radius of character region
  char_y    <= conv_std_logic_vector(55, 10);
  l_x       <= conv_std_logic_vector(300, 10);
  i_x       <= conv_std_logic_vector(310, 10);
  v_x       <= conv_std_logic_vector(330, 10);
  e_x       <= conv_std_logic_vector(340, 10);
  s_x       <= conv_std_logic_vector(350, 10);
  colon_x   <= conv_std_logic_vector(360, 10);
  three_x   <= conv_std_logic_vector(370, 10);

  -- L
  --  u_char_address <= "001100"
  --    when letter_range(l_x, char_size, pixel_column, pixel_row, char_y) else
  --    "001001"
  --    when letter_range(i_x, char_size, pixel_column, pixel_row, char_y) else
  --    "010110"
  --    when letter_range(v_x, char_size, pixel_column, pixel_row, char_y) else
  --    "000101"
  --    when letter_range(e_x, char_size, pixel_column, pixel_row, char_y) else
  --    "010011"
  --    when letter_range(s_x, char_size, pixel_column, pixel_row, char_y) else
  --    "101101"
  --    when letter_range(colon_x, char_size, pixel_column, pixel_row, char_y) else
  --    "110011"
  --    when letter_range(three_x, char_size, pixel_column, pixel_row, char_y)
  --    else
  --    "100000";
  process (pb2)
  begin
    if (pb2 = '0') then
      u_f_row                                     <= pixel_row(3 downto 1);
      u_f_col                                     <= pixel_column(3 downto 1);
      if (pixel_row >= 31 and pixel_row           <= 46) then
        if (pixel_column >= 527 and pixel_column    <= 542) then
          u_char_address                              <= "001100";
        elsif (pixel_column >= 543 and pixel_column <= 558) then
          u_char_address                              <= "001001";
        elsif (pixel_column >= 559 and pixel_column <= 574) then
          u_char_address                              <= "010110";
        elsif (pixel_column >= 575 and pixel_column <= 590) then
          u_char_address                              <= "000101";
        elsif (pixel_column >= 591 and pixel_column <= 606) then
          u_char_address                              <= "010011";
        else
          u_char_address <= "100000";
        end if;
      else
        u_char_address <= "100000";
      end if;
    else
      u_f_row                                     <= pixel_row(2 downto 0);
      u_f_col                                     <= pixel_column(2 downto 0);
      if (pixel_row >= 31 and pixel_row           <= 38) then
        if (pixel_column >= 527 and pixel_column    <= 534) then
          u_char_address                              <= "001100";
        elsif (pixel_column >= 535 and pixel_column <= 542) then
          u_char_address                              <= "001001";
        elsif (pixel_column >= 543 and pixel_column <= 550) then
          u_char_address                              <= "010110";
        elsif (pixel_column >= 551 and pixel_column <= 558) then
          u_char_address                              <= "000101";
        elsif (pixel_column >= 559 and pixel_column <= 566) then
          u_char_address                              <= "010011";
        else
          u_char_address <= "100000";
        end if;
      else
        u_char_address <= "100000";
      end if;
    end if;
  end process;
  text_out <= u_rom_mux_out;
end behaviour;