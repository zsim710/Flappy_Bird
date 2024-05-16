library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity collision_holder is
  port
  (
    vert_sync              : in std_logic;
    ball_on, pipe_on : in std_logic;
    output_collision : out std_logic);
end collision_holder;

architecture Behavioral of collision_holder is
  signal pre_col    : std_logic;
  signal current_col : std_logic;

begin
  process (vert_sync)
  begin
    if rising_edge(vert_sync) then
      if ball_on = '1' and pipe_on = '1' and pre_col = '0' then
        current_col <= '1';
      elsif ball_on = '1' and pipe_on = '1' and pre_col = '1' then
        current_col <= '1';
		else 
			current_col <= '0';
      end if;
    end if;
	 pre_col <= current_col;
    output_collision <= current_col;
  end process;

end Behavioral;