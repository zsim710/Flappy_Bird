library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity collision_module is
  port
  (
    clk              : in std_logic;
    ball_on, pipe_on : in std_logic;
    output_collision : out std_logic
	 
	 );
end collision_module;

architecture Behavioral of collision_module is
  signal pre_col     : std_logic;
  signal current_col : std_logic;

begin
  process (clk)
  begin
    if rising_edge(clk) then
      -- if pipe and ball is on, and no previous collision then collision is one
      if ball_on = '1' and pipe_on = '1' and pre_col = '0' then
        current_col <= '1';
        --if ball is in pipe, hold the collision for now
        --TODO : Change to a pulse, aka. current_col <= '0', for an incremental counter
      elsif ball_on = '1' and pipe_on = '1' and pre_col = '1' then
        current_col <= '1';
      else
        current_col <= '0';
      end if;
    end if;
    --set current collision status to variable for next occurence
    pre_col          <= current_col;
    output_collision <= current_col;
  end process;

end Behavioral;