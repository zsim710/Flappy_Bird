library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity testImage is
  port
  (
    clk                     : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    image_out               : out std_logic
  );
end testImage;

architecture behaviour of testImage is

  component image_rom is
    port
    (
      character_address    : in std_logic_vector (7 downto 0); -- maybe change
      font_row, font_col: in std_logic_vector (3 downto 0);
      clock                : in std_logic;
      rom_output           : out std_logic -- 12-bit pixel value
    );
  end component;

  signal u_char_address   : std_logic_vector(7 downto 0);
  signal u_f_row, u_f_col : std_logic_vector(3 downto 0);
  signal u_rom_mux_out    : std_logic;

begin

  image_rom_inst : image_rom
  port map
  (
    character_address => u_char_address,
    font_row         => u_f_row,
    font_col         => u_f_col,
    clock             => clk,
    rom_output        => u_rom_mux_out
  );

  process (pixel_row, pixel_column)
  begin
    -- Generate image on pixel row and column 16x16 in top left corner
    u_f_row                                 <= pixel_row(4 downto 1);
    u_f_col                                 <= pixel_column(4 downto 1);
    if (pixel_row >= 31 and pixel_row       <= 46) then
      if (pixel_column >= 31 and pixel_column <= 46) then
        u_char_address                          <= "11111111";
      else
        u_char_address <= "00000000";
      end if;
    end if;
  end process;

  image_out <= u_rom_mux_out;

end behaviour;