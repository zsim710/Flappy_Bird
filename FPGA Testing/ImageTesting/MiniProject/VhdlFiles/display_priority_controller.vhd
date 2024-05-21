--creating the priority for colours here just before VGA

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display_priority_controller is
  port
  (
    ball_on, pipe_on, ground_on, text_on, score_text_on, clk, pb2 : in std_logic;
    pixel_row, pixel_column                                       : in std_logic_vector(9 downto 0);
    red, green, blue                                              : out std_logic_vector(3 downto 0);
    led_out                                                       : out std_logic
  );
end entity display_priority_controller;

architecture behaviour of display_priority_controller is

begin

  process (clk)
  begin
    if (rising_edge(clk)) then
      if (score_text_on = '1') then --white
        red   <= "1111";
        green <= "1111";
        blue  <= "1111";
      elsif (text_on = '1') then --red
        red   <= "1111";
        green <= "0001";
        blue  <= "0001";
      elsif (ball_on = '1' and pb2 = '1') then --darker red
        red   <= "1010";
        green <= "0111";
        blue  <= "0000";

        --TODO : Remove later, this was for interim
      elsif (ball_on = '1' and pb2 = '0') then --another color
        red   <= "1111";
        green <= "0001";
        blue  <= "0001";
      elsif (ground_on = '1') then -- sea blue
        red   <= "0000";
        green <= "0110";
        blue  <= "1011";
      elsif (pipe_on = '1') then
        red   <= "0110";
        green <= "1100";
        blue  <= "0000";
      else --background;
        red   <= "0110";
        green <= "1011";
        blue  <= "1111";
      end if;
    end if;
  end process;

end architecture behaviour;