library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
entity ground is
  port
  (
    vert_sync               : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    ground_on               : out std_logic;
    rgb_ground              : out std_logic_vector(12 downto 0)
  );
end entity ground;

architecture behavior of ground is
  component ground_rom is
    port
    (
      clock              : in std_logic;
      font_row, font_col : in std_logic_vector (4 downto 0);
      rom_output         : out std_logic_vector(12 downto 0) -- 1-bit alpha and 12-bit color
    );
  end
  component;

    signal u_f_row, u_f_col : std_logic_vector(4 downto 0);
    signal u_rom_mux_out    : std_logic_vector(12 downto 0); -- 1-bit alpha and 12-bit color

    signal ground_height               : std_logic_vector(10 downto 0);
    signal screen_width, screen_height : std_logic_vector(10 downto 0);
    signal ground_width                : std_logic_vector(10 downto 0);
    signal ground_x_pos                : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(319, 11);
    signal ground_y_pos                : std_logic_vector(9 downto 0)  := CONV_STD_LOGIC_VECTOR(460, 10);

  begin

    water : ground_rom
    port map
    (
      clock      => vert_sync,
      font_row   => u_f_row,
      font_col   => u_f_col,
      rom_output => u_rom_mux_out
    );

    process (pixel_row, pixel_column)
    begin
      -- Generate image on pixel row and column 16x16 in top left corner
      u_f_row                            <= pixel_row(4 downto 0);
      u_f_col                            <= pixel_column(4 downto 0);
      if (pixel_row >= 415 and pixel_row <= 479) then
        rgb_ground                         <= u_rom_mux_out;
        ground_on                          <= '1';
      else
        ground_on  <= '0';
        rgb_ground <= (others => '0');
      end if;
    end process;

  end behavior;