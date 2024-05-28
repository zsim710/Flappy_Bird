library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity collisions is
  port
  (
    clk, menu_state  : in std_logic;
    bird_on, pipe_on : in std_logic;
    output_collision : out std_logic
  );
end collisions;

architecture Behavioral of collisions is
  signal high_signal          : std_logic := '0';
  signal count_high           : integer   := 0;
  signal count_low            : integer   := 0;
  constant debounce_threshold : integer   := 16; -- Adjust this value based on debounce requirement
begin

  process (clk, menu_state, bird_on, pipe_on)
  begin
    if (menu_state = '1') then
      high_signal <= '0';
      count_high  <= 0;
      count_low   <= 0;
    elsif rising_edge(clk) then
      if bird_on = '1' and pipe_on = '1' then
        count_low <= 0;
        if count_high < debounce_threshold then
          count_high <= count_high + 1;
        end if;
        if count_high = debounce_threshold then
          high_signal <= '1';
        end if;
      else
        count_high <= 0; -- Reset high counter
        if count_low < debounce_threshold then
          count_low <= count_low + 1;
        end if;
        if count_low = debounce_threshold then
          high_signal <= '0';
        end if;
      end if;
    end if;
  end process;

  output_collision <= high_signal;

end Behavioral;