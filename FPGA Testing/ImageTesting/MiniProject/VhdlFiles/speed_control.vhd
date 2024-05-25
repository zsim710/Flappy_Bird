library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity speed_control is
  port (medium_mode_out, hard_mode_out, impossible_mode_out : in std_logic;
        speed : out integer);
end speed_control;

architecture rtl of speed_control is

begin

difficulty : process (medium_mode_out, hard_mode_out, impossible_mode_out)
begin
 if (medium_mode_out = '1') then
    speed <= 4;
  elsif (hard_mode_out = '1') then
    speed          <= 5;
    gap_half_width <= 40;
  elsif (impossible_mode_out = '1') then
    speed          <= 6;
    gap_half_width <= 35;
  end if;
end process;

end rtl;

