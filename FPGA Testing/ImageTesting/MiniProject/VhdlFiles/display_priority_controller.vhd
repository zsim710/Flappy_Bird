library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display_priority_controller is
  port
  (
    clk, ball_on, pipe_on, ground_on, score_text_on, image_on, static_text_on, lives_on, powerups_on : in std_logic;
    pixel_row, pixel_column                                                             : in std_logic_vector(9 downto 0);
    red, green, blue                                                                    : out std_logic_vector(3 downto 0)
  );
end entity display_priority_controller;

architecture behaviour of display_priority_controller is

  signal image_data : std_logic_vector(11 downto 0); -- 12-bit pixel data

  -- Instantiate the ROM
  component image_rom is
    port
    (
      character_address  : in std_logic_vector (7 downto 0);
    font_row, font_col : in std_logic_vector (3 downto 0);
    clock              : in std_logic;
    rom_output         : out std_logic -- 12-bit pixel value
    );
  end component;

  signal u_char_address   : std_logic_vector(7 downto 0);
  signal u_f_row, u_f_col : std_logic_vector(3 downto 0);
  signal u_rom_mux_out    : std_logic;
  
begin

  rom_inst : image_rom
  port map
  (
    character_address => u_char_address,
    font_row => u_f_row,
	 font_col => u_f_col,
    clock => clk,
    rom_output => u_rom_mux_out
  );

  process (clk)
  begin
    if rising_edge(clk) then
      -- Your display controller logic here, using image_data as input for generating VGA signals
      -- Example:
		--if (image_on = '1') then
        -- Assuming image_data is in RGB444 format (4 bits Red, 4 bits Green, 4 bits Blue)
        --red   <= image_data(11 downto 8);
        --green <= image_data(7 downto 4);
        --blue  <= image_data(3 downto 0);
      if (score_text_on = '1' or static_text_on = '1') then -- white
        red   <= "1111";
        green <= "1111";
        blue  <= "1111";
      elsif (lives_on = '1') then -- red
        red   <= "1111";
        green <= "0001";
        blue  <= "0001";
		elsif (powerups_on = '1') then
        red   <= "1111";
        green <= "1111";
        blue  <= "0000";
      elsif (ball_on = '1') then -- red
        red   <= "1010";
        green <= "1010";
        blue  <= "0001";
      elsif (ground_on = '1') then
        red   <= "0010";
        green <= "0010";
        blue  <= "1111";
      elsif (pipe_on = '1') then -- green
        red   <= "0001";
        green <= "1111";
        blue  <= "0001";
        -- Add other conditions as needed
      else -- background
        red   <= "0110";
        green <= "1011";
        blue  <= "1111";
      end if;
    end if;
  end process;

end architecture behaviour;