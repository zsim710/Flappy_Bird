library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity level_fsm is
  port
  (
    clk, reset, right_click: in std_logic;
    score                        : in integer range 0 to 3;                 
    easy_mode_out                     : out std_logic;
    medium_mode_out                       : out std_logic;
    hard_mode_out                              : out std_logic;
    impossible_mode_out                       : out std_logic
    );
end level_fsm;

-- states: 
-- s0: easy mode
-- s1: medium mode
-- s2: hard mode
architecture Behavioral of fsm is
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

  NextState : process (state, witch0, witch1, left_click, right_click, back, collison_counter, pb0, pb3)
  begin

    case (state) is

        -- state 0 --
      when "0000" => -- menu state -> default state 
        if (witch0 = '0' and left_click = '0' and witch1 = '1' and witch2 = '1') then -- sw = 1 = down = training
          next_state <= "0001"; --state 1 training mode
        elsif (witch1 = '0' and left_click = '0' and witch1 = '1' and witch2 = '1') then -- sw = 0 = up = normal
          next_state <= "0010"; -- state 2 normal mode
        elsif (witch2 = '0' and left_click = '0' and witch0 = '1' and witch1 = '1') then
          next_state <= "0011"; -- s3
        else
          next_state <= "0000"; -- s0
        end if;

        -- state 1 -- // training mode playing state
      when "0001" => -- state 1 -> 0001
        if (collison_counter >= 3) then
          next_state <= "0110"; -- s6
        elsif (right_click = '0') then
          next_state <= "0100"; -- s4
        else
          next_state <= "0001"; -- s1
        end if;
        -- state 2 --// normal mode playing state
      when "0010" => -- state 2 --> 0010
        if (collison_counter >= 1) then
          next_state <= "0110"; -- s6
        elsif (right_click = '0') then
          next_state <= "0101"; -- s5
        else
          next_state <= "0010"; -- s2
        end if;
        -- state 3 -- // settings mode state
      when "0011" => -- state 3 --> 0011
        if (left_click = '0') then
          next_state <= "0000"; -- s0 --> return to menu
        end if;
        -- state 4 --// pause training mode state
      when "0100" => -- state 4 --> 0100
        if (pb3 = '0') then
          next_state <= "0001"; -- s1 --> return back to playing training mode
        elsif (pb0 = '0') then
          next_state <= "0000"; -- s0 --> return to menu
        else
          next_state <= "0100"; -- s4 --> stay in pause training mode

        end if;
        -- state 5 -- // pause normal mode state
      when "0101" => -- state 5 --> 0101
        if (pb3 = '0') then
          next_state <= "0010"; -- s2 --> return back to playing normal mode
        elsif (pb0= '0') then
          next_state <= "0000"; -- s0 --> return to menu
        else
          next_state <= "0101"; -- s5 --> stay in pause normal mode
        end if;
        -- state 6 -- // end game state
      when "0110" => -- state 6 --> 0110
        if (right_click = '0') then -- go back to menu 
          next_state <= "0000"; -- return to menu to start a new game 
        elsif(witch1 = '0' and left_click = '0' and witch0 = '1') then -- play again to whatever mode they were in 
          next_state <= "0010"; -- s2 --> go back to normal mode state
        elsif(witch0 = '0' and left_click = '0' and witch1 = '1') then 
          next_state <= "0001"; -- s1 --> go to back training mode 
        end if;
      when others =>
        next_state <= "0000";

    end case;

  end process;

  output_state : process (state) -- output state
  begin

    menu_state          <= '0'; -- menu state
    training_mode       <= '0'; -- training mode
    normal_mode         <= '0'; -- normal mode
    settings_mode       <= '0'; -- settings mode
    pause_training_mode <= '0'; -- pause training mode
    pause_normal_mode   <= '0'; -- pause normal mode
    end_game            <= '0'; -- end game

    menu_state <= '0'; -- menu state
    case (state) is
      when "0000" => -- menu state
        menu_state <= '1';
      when "0001" => -- training mode playing state
        training_mode <= '1';
      when "0010" => -- normal mode playing state
        normal_mode <= '1';
      when "0011" => -- settings mode state
        settings_mode <= '1';
      when "0100" => -- pause training mode state
        pause_training_mode <= '1';
      when "0101" => -- pause normal mode state
        pause_normal_mode <= '1';
      when "0110" => -- end game state
        end_game <= '1';
      when others =>
        menu_state <= '1';
    end case;
  end process;

end Behavioral;