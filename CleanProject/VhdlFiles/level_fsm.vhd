library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity level_fsm is
  port
  (
    clk                 : in std_logic;
    score               : in integer range 0 to 500;
    reset               : in std_logic;
    menu_state          : in std_logic;
    end_game_state      : in std_logic;
    easy_mode_out       : out std_logic;
    medium_mode_out     : out std_logic;
    hard_mode_out       : out std_logic;
    impossible_mode_out : out std_logic
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
    if (reset = '0' or menu_state = '1') then -- reset is SW[9]
      state <= easy; -- s0
    elsif (rising_edge(clk)) then
      state <= next_state;
    end if;
  end process;

  NextState : process (state, score)
  begin

    case (state) is

        -- state 0 --
      when easy =>
        if (score >= 10) then
          next_state <= medium; -- move to medium mode after 10 points
        else
          next_state <= easy;
        end if;
      when medium =>
        if (score >= 25) then
          next_state <= hard; -- move to hard mode after 25 points
        else
          next_state <= medium;
        end if;
        -- state 2 --
      when hard =>
        if (score >= 50) then
          next_state <= impossible; -- move to impossible mode after 50 points
        else
          next_state <= hard; -- s2
        end if;
      when impossible =>
        if (end_game_state = '1') then
          next_state <= easy;
        else
          next_state <= impossible; -- stay impossible
        end if;

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