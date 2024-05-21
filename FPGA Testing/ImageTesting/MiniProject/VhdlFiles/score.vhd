library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity score is
  port
  (
    menu_state, clk, reset, vert_sync                        : in std_logic;
    pipe_passed, ball_on, collison_counter, output_collision : in std_logic;
    score                                                    : integer std_logic
  );
end entity;

architecture rtl of score is

begin

  process (clk)
    variable score_V : integer range 0 to 9999;
  begin
    if (rising_edge(pipe_passed) and output_collision = '0') then
      score_V := score_V + 1;
    elsif (menu_state = '1') then
      score_V := 0;
    end if;
    score <= score_V;
  end process;

end architecture;