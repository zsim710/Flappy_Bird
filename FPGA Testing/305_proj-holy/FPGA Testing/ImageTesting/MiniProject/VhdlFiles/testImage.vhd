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
    image_out               : out std_logic;
    rbg_image_on            : out std_logic_vector(12 downto 0) -- 1-bit alpha and 12-bit color
  );
end testImage;

architecture behaviour of testImage is

  component image_rom is
    port
    (
      clock              : in std_logic;
      font_row, font_col : in std_logic_vector (3 downto 0);
      rom_output         : out std_logic_vector(12 downto 0) -- 1-bit alpha and 12-bit color
    );
  end component;

  signal u_char_address   : std_logic_vector(7 downto 0);
  signal u_f_row, u_f_col : std_logic_vector(3 downto 0);
  signal u_rom_mux_out    : std_logic_vector(12 downto 0); -- 1-bit alpha and 12-bit color

begin

  image_rom_inst : image_rom
  port map
  (
    clock      => clk,
    font_row   => u_f_row,
    font_col   => u_f_col,
    rom_output => u_rom_mux_out
  );

  process (pixel_row, pixel_column)
  begin
    -- Generate image on pixel row and column 16x16 in top left corner
    u_f_row                                 <= pixel_row(6 downto 3);
    u_f_col                                 <= pixel_column(6 downto 3);
    if (pixel_row >= 30 and pixel_row       <= 150) then
      if (pixel_column >= 30 and pixel_column <= 150) then
        image_out                               <= '1';
        rbg_image_on                            <= u_rom_mux_out;
      else
        image_out    <= '0';
        rbg_image_on <= (others => '0');

      end if;
    end if;
  end process;

end behaviour;