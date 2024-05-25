library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity level_fsm is
  port
  (
    clk, reset : in std_logic;
    score                   : in integer range 0 to 500;
    easy_mode_out           : out std_logic;
    medium_mode_out         : out std_logic;
    hard_mode_out           : out std_logic;
    impossible_mode_out     : out std_logic
    );
end level_fsm;

-- states: 
-- s0: easy mode
-- s1: medium mode
-- s2: hard mode
architecture Behavioral of level_fsm is
  type state_type is (easy, medium, hard, impossible);
  signal state      : state_type;
  signal next_state : state_type;

begin
  sync : process (clk)
  begin
    if (reset = '0') then -- reset is SW[9]
      state <= easy; -- s0
    elsif (rising_edge(clk)) then
      state <= next_state;
    end if;
  end process;

  NextState : process (state, score)
  begin

    case (state) is

        -- state 0 --
      when easy => -- menu state -> default state 
        if (score >= 5) then -- sw = 1 = down = training -- 30 is the score to go to medium mode
          next_state <= medium; --state 1 training mode
        else
          next_state <= easy; -- s0
        end if;

        -- state 1 -- // training mode playing state
      when medium => -- state 1 -> 0001
        if (score >= 10) then -- sw = 0 = up = normal -- 60 is the score to go to hard mode
        next_state <= hard; -- state 2 normal mode
        else
          next_state <= medium; -- s1
        end if;
        -- state 2 --// normal mode playing state
      when hard => -- state 2 --> 0010
        if (score >= 50) then -- 120 is the score to go to impossible mode
          next_state <= impossible; -- state 3 settings mode
        else
          next_state <= hard; -- s2
        end if;
        -- state 3 -- // settings mode state
      when impossible => -- state 3 --> 0011
          next_state <= impossible; -- s0 --> return to menu

    end case;

  end process;

  output_state : process (state) -- output state
  begin

    easy_mode_out       <= '0'; -- settings mode
    medium_mode_out     <= '0'; -- pause training mode
    hard_mode_out       <= '0'; -- pause normal mode
    impossible_mode_out <= '0'; -- end game

    case (state) is
      when easy => -- menu state
        easy_mode_out <= '1';
      when medium => -- training mode playing state
        medium_mode_out <= '1';
      when hard => -- normal mode playing state
        hard_mode_out <= '1';
      when impossible => -- settings mode state
        impossible_mode_out <= '1';
      when others =>
        easy_mode_out <= '1';
    end case;
  end process;

end Behavioral;