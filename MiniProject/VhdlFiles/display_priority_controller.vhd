--creating the priority for colours here just before VGA

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity display_priority_controller is
  port
  (
    ball_on, pipe_on, ground_on, text_on, clk : in std_logic;
    pixel_row, pixel_column                   : in std_logic_vector(9 downto 0);
    red, green, blue                          : out std_logic
  );
end entity display_priority_controller;

architecture behaviour of display_priority_controller is

begin

  process (clk)
  begin
    if (rising_edge(clk)) then
      if (ball_on = '1') then
        red   <= '1';
        green <= '0';
        blue  <= '0';
         elsif (text_on = '1') then
             red   <= '1';
             green <= '1';
             blue  <= '0';
        elsif (ground_on = '1') then
        red   <= '0';
        green <= '0';
        blue  <= '1';
        elsif (pipe_on = '1') then
        red   <= '0';
        green <= '1';
        blue  <= '0';
        else --background;
        red   <= '1';
        green <= '1';
        blue  <= '1';
      end if;
    end if;
  end process;

end architecture behaviour;