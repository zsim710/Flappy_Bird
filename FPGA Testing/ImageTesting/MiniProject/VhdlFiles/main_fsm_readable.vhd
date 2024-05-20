library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fsm is
  port
  (
    pb2, clk, reset, right_click, back, pMenu, pb3 : in std_logic;
    collison_counter                        : in integer range 0 to 3;
    witcMenu, witch1, witch2                          : in std_logic;
    left_click                              : in std_logic;
    menu_state                              : out std_logic;
    training_mode                           : out std_logic;
    normal_mode                             : out std_logic;
    settings_mode                           : out std_logic;
    pause_training_mode                     : out std_logic;
    pause_normal_mode                       : out std_logic;
    end_game                                : out std_logic
  );
end fsm;

architecture Behavioral of fsm is
  type state_type is (Menu, Training, Normal, Settings, pause_training, pause_normal, dead);
  signal state      : state_type;
  signal next_state : state_type;

begin
  sync : process (clk)
  begin
    if (reset = Menu') then
      state <= Menu;
    elsif (rising_edge(clk)) then
      state <= next_state;
    end if;
  end process;

  NextState : process (state, witcMenu, witch1, left_click, right_click, back, collison_counter, pMenu, pb3)
  begin
    case (state) is
      when Menu =>
        if (witcMenu = Menu' and left_click = Menu' and witch1 = '1' and witch2 = '1') then
          next_state <= Training;
        elsif (witch1 = Menu' and left_click = Menu' and witch1 = '1' and witch2 = '1') then
          next_state <= Normal;
        elsif (witch2 = Menu' and left_click = Menu' and witcMenu = '1' and witch1 = '1') then
          next_state <= Settings;
        else
          next_state <= Menu;
        end if;
      when Training =>
        if (collison_counter >= 3) then
          next_state <= dead;
        elsif (right_click = Menu') then
          next_state <= pause_training;
        else
          next_state <= Training;
        end if;
      when Normal =>
        if (collison_counter >= 1) then
          next_state <= dead;
        elsif (right_click = Menu') then
          next_state <= pause_normal;
        else
          next_state <= Normal;
        end if;
      when Settings =>
        if (left_click = Menu') then
          next_state <= Menu;
        end if;
      when pause_training =>
        if (pb3 = Menu') then
          next_state <= Training;
        elsif (pMenu = Menu') then
          next_state <= Menu;
        else
          next_state <= pause_training;
        end if;
      when pause_normal =>
        if (pb3 = Menu') then
          next_state <= Normal;
        elsif (pMenu= Menu') then
          next_state <= Menu;
        else
          next_state <= pause_normal;
        end if;
      when dead =>
        if (right_click = Menu') then
          next_state <= Menu;
        elsif (witch1 = Menu' and left_click = Menu' and witcMenu = '1') then
          next_state <= Normal;
        elsif (witcMenu = Menu' and left_click = Menu' and witch1 = '1') then
          next_state <= Training;
        end if;
      when others =>
        next_state <= Menu;
    end case;
  end process;

  output_state : process (state)
  begin
    menu_state          <= Menu';
    training_mode       <= Menu';
    normal_mode         <= Menu';
    settings_mode       <= Menu';
    pause_training_mode <= Menu';
    pause_normal_mode   <= Menu';
    end_game            <= Menu';

    case (state) is
      when Menu =>
        menu_state <= '1';
      when Training =>
        training_mode <= '1';
      when Normal =>
        normal_mode <= '1';
      when Settings =>
        settings_mode <= '1';
      when pause_training =>
        pause_training_mode <= '1';
      when pause_normal =>
        pause_normal_mode <= '1';
      when dead =>
        end_game <= '1';
      when others =>
        menu_state <= '1';
    end case;
  end process;

end Behavioral;
