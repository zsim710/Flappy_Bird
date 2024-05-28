library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity game_fsm is
  port
  (
    clk, reset, right_click, pb0, pb1, pb2, pb3                                           : in std_logic;
    witch0, witch1, witch2                                                                : in std_logic;
    left_click                                                                            : in std_logic;
    output_collision                                                                      : in std_logic;
    menu_state, training_state, normal_state, settings_state, pause_state, end_game_state : out std_logic
  );
end game_fsm;

architecture Behavioral of game_fsm is
  type state_type is (Menu, Training, Normal, Settings, pause_game, dead);
  signal state      : state_type := Menu;
  signal next_state : state_type;

begin
  sync : process (clk)
  begin
    if (reset = '0') then -- reset is SW[9]
      state <= Menu; --Go to menu state
    elsif (rising_edge(clk)) then
      state <= next_state;
    end if;
  end process;
  NextState : process (state, witch0, witch1, left_click, right_click, output_collision, pb0, pb1, pb2, pb3)
  begin

    case (state) is
      when Menu =>
        if (witch0 = '0' and left_click = '0' and witch1 = '1' and witch2 = '1') then
          next_state <= Training; --state 1 training mode
        elsif (witch1 = '0' and left_click = '0' and witch0 = '1' and witch2 = '1') then
          next_state <= Normal; -- state 2 normal mode
        elsif (witch2 = '0' and left_click = '0' and witch0 = '1' and witch1 = '1') then
          next_state <= Settings; -- s3
        else
          next_state <= Menu; -- s0
        end if;

      when Training =>
        if (right_click = '0') then
          next_state <= pause_game;
        else
          next_state <= Training; -- s1
        end if;
      when Normal =>
        if (output_collision = '1') then
          next_state <= dead; -- s6
        elsif (right_click = '0') then
          next_state <= pause_game; -- s4
        else
          next_state <= Normal; -- s2
        end if;
      when Settings =>
        if (pb0 = '0') then
          next_state <= Menu; -- s0 --> return to menu
        else
          next_state <= Settings;
        end if;
        -- state 4 --// pause training mode state
      when pause_game => -- state 4 --> 0100
        if (pb3 = '0' and witch0 = '0' and witch1 = '1' and witch2 = '1') then
          next_state <= Training; -- s1 --> return back to playing training mode
        elsif (pb3 = '0' and witch1 = '0' and witch0 = '1' and witch2 = '1') then
          next_state <= Normal; -- s2 --> return back to playing normal mode
        elsif (pb0 = '0') then
          next_state <= Menu; -- s0 --> return to menu
        else
          next_state <= pause_game; -- s4 --> stay in pause training mode

        end if;
        -- state 6 -- // end game state
      when dead => -- state 5 --> 0110
        if (pb0 = '0') then -- go back to menu 
          next_state <= Menu; -- return to menu to start a new game 
        else
          next_state <= dead; -- stay in dead state
        end if;
      when others =>
        next_state <= Menu;

    end case;

  end process;

  output_state : process (state) -- output state
  begin

    menu_state     <= '0'; -- menu state
    training_state <= '0'; -- training mode
    normal_state   <= '0'; -- normal mode
    settings_state <= '0'; -- settings mode
    pause_state    <= '0'; -- pause normal mode
    end_game_state <= '0'; -- end game

    menu_state <= '0'; -- menu state
    case (state) is
      when Menu => -- menu state
        menu_state <= '1';
      when Training => -- training mode playing state
        training_state <= '1';
      when Normal => -- normal mode playing state
        normal_state <= '1';
      when Settings => -- settings mode state
        settings_state <= '1';
      when pause_game => -- pause training mode state
        pause_state <= '1';
      when dead => -- end game state
        end_game_state <= '1';
      when others =>
        menu_state <= '1';
    end case;
  end process;

end Behavioral;