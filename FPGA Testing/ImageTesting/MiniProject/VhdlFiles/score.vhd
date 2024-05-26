library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
entity score is
  port
  (
    clk, menu_state, pipe_passed : in std_logic;
    output_collision             : in std_logic;
    score                        : out integer range 0 to 500
  );
end entity;

architecture rtl of score is

begin

  process (menu_state, pipe_passed, output_collision)
    variable score_V : integer range 0 to 500;
  begin
    if (rising_edge(pipe_passed) and output_collision = '0') then
      score_V := score_V + 1;
    end if;
    if output_collision = '1' then
      score_V := score_V;
    end if;
    if (menu_state = '1') then
      score_V := 0;
    end if;
    score <= score_V;
  end process;
end architecture;