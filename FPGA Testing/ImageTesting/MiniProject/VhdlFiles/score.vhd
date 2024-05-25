library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity score is
  port
  (
    clk, menu_state, pipe_passed             : in std_logic;
	 collision_counter : in std_logic_vector(1 downto 0);
    score                                                    : out integer range 0 to 500
  );
end entity;

architecture rtl of score is

begin

  process (clk, menu_state, pipe_passed, collision_counter)
    variable score_V : integer range 0 to 500;
  begin
    if (rising_edge(pipe_passed) and collision_counter < 5) then
      score_V := score_V + 1;
    end if;
    if (menu_state = '1') then
      score_V := 0;
    end if;
    score <= score_V;
  end process;

end architecture;