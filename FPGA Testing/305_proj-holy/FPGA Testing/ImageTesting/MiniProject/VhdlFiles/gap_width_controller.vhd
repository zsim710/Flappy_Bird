library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity gap_width_control is
  port (medium_mode_out, hard_mode_out, impossible_mode_out, normal_state : in std_logic;
      gap_half_width : out integer);
end gap_width_control;

architecture rtl of gap_width_control is

begin

difficulty : process (medium_mode_out, hard_mode_out, impossible_mode_out, normal_state)
begin
if(normal_state = '1') then
 if (medium_mode_out = '1') then
  gap_half_width <= 58;
  elsif (hard_mode_out = '1') then
    gap_half_width          <= 54;
  elsif (impossible_mode_out = '1') then
    gap_half_width          <= 50;
  end if;
  else
  gap_half_width <= 60;
  end if;
end process;

end rtl;

