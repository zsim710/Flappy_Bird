library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.numeric_std.all;

entity collision_module is
  port
  (
    clk, menu_state               : in std_logic;
    bird_on, pipe_on, pipe_passed : in std_logic;
    collision_counter             : out std_logic_vector(1 downto 0);
    output_collision              : out std_logic
  );
end collision_module;

architecture behaviour of collision_module is
  signal pre_col             : std_logic;
  signal current_col         : std_logic;
  signal collision_flag      : std_logic := '0'; -- Initialize collision flag
  signal v_collision_counter : integer   := 0; -- Initialize collision counter variable

begin
  collision_detection : process (clk)
  begin
    if rising_edge(clk) then
      -- Detect collision
      if bird_on = '1' and pipe_on = '1' and pre_col = '0' then
        current_col <= '1'; -- Collision detected
        if (collision_flag = '0') then
          collision_flag      <= '1'; -- Set collision flag
          v_collision_counter <= v_collision_counter + 1; -- Increment collision counter
          if v_collision_counter = 3 then
            v_collision_counter <= 0; -- Reset collision counter
          end if;
        end if;
        -- Update previous collision status
      else
        current_col <= '0'; -- No collision detected
      end if;
      pre_col <= current_col;
    end if;

    if pipe_passed = '1' then-- and pre_col = '1' and current_col = '0' then
      collision_flag <= '0'; -- Reset collision flag
    end if;
    output_collision  <= collision_flag; -- Output collision flag
    collision_counter <= std_logic_vector(to_unsigned(v_collision_counter, 2));
  end process collision_detection;

  -- Output collision counter

end behaviour;