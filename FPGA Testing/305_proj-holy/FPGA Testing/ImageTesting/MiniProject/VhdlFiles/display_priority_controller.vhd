library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display_priority_controller is
  port
  (
    clk, ball_on, pipe_on, ground_on, score_text_on, image_on, static_text_on, lives_on, powerups_on : in std_logic;
    rgb_image_on                                                                                     : in std_logic_vector(12 downto 0);
    pixel_row, pixel_column                                                                          : in std_logic_vector(9 downto 0);
    red, green, blue                                                                                 : out std_logic_vector(3 downto 0)
  );
end entity display_priority_controller;

architecture behaviour of display_priority_controller is

begin
  process (clk)
  begin
    if rising_edge(clk) then
      -- Your display controller logic here, using image_data as input for generating VGA signals
      -- Example:
      if (image_on = '1') then
        -- Assuming image_data is in RGB444 format (4 bits Red, 4 bits Green, 4 bits Blue)
        red   <= rgb_image_on(11 downto 8);
        green <= rgb_image_on(7 downto 4);
        blue  <= rgb_image_on(3 downto 0);
      elsif (score_text_on = '1' or static_text_on = '1') then -- white
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
        red   <= rgb_image_on(11 downto 8);
        green <= rgb_image_on(7 downto 4);
        blue  <= rgb_image_on(3 downto 0);
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