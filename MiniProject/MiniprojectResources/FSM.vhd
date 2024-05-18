Library IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity fsm is 
port (clk,reset,right_click, back:in std_logic;
      collison_counter : in integer range 0 to 3;
      witch0,witch1, pb0:in std_logic;
      left_click : in std_logic;
      output_state : out std_logic_vector(3 downto 0));
end fsm;

-- states: 
-- s0: menu state
-- s1: training mode
-- s2: normal mode
-- s3: settings(not done)
-- s4: pause training mode
-- s5: pause normal mode 
-- s6: end game 


architecture Behavioral of fsm is


signal state : std_logic_vector(3 downto 0) := "0000"; -- s0

begin
sync : process(clk)
begin 
    if rising_edge(clk) then
        if(reset = '1') then 
            state <= "0000"; -- s0
        else 
            state <= state;
        end if;
    end if;
end process;

output: process(state, pb0,witch0, witch1, left_click, right_click, back, collison_counter)
begin 
case (state) is 

   -- state 0 --
    when "0000" => -- menu state -> default state 
    if(witch0 = '0' and left_click = '1') then
        state <= "0001";
    elsif(witch0 = '1' and left_click = '1') then
        state <= "0010"; -- state 2
    elsif(witch0 = '1' and witch1 = '1') then
        state <= "0011"; -- s3
    else
    state <= "0000"; -- s0
    end if;
    
    -- state 1 -- // training mode playing state
    when "0001" => -- state 1 -> 0001
    if(collison_counter >= 3) then
        state <= "0110"; -- s0
    elsif(right_click) then
        state <= "0100"; -- s4
    else
        state <= "0001"; -- s1
    end if;
    

    -- state 2 --// normal mode playing state
    when "0010" => -- state 2 --> 0010
    if(collison_counter >= 3) then
        state <= "0110"; -- s0
    elsif(right_click) then
        state <= "0101"; -- s4
    else
        state <= "0010"; -- s1  
    end if;


    -- state 3 -- // settings mode state
    when "0011" => -- state 3 --> 0011
    if(left_click = '0') then
        state <= "0000"; -- s0 --> return to menu
    end if;


    -- state 4 --// pause training mode state
    when "0100" => -- state 4 --> 0100
        if(right_click = '0') then
            state <= "0001"; -- return back to playing training mode
        elsif(back) then
            state <= "0000"; -- s0 --> return to menu
        else
            state <= "0100"; -- s4 --> stay in pause training mode

        end if;
    

    -- state 5 -- // pause normal mode state
    when "0101" => -- state 5 --> 0101
    if(right_click = '0') then
        state <= "0010"; -- s5 --> return back to playing normal mode
    elsif(back) then
        state <= "0000"; -- s0 --> return to menu
    else
        state <= "0101"; -- s4 --> stay in pause normal mode
    end if;


    -- state 6 -- // end game state
    when "0110" => -- state 6 --> 0110
    if(right_click = '0') then
        state <= "0000"; -- return to menu to start a new game 
    else
        state <= "0110"; -- s6 --> stay in end game state
    end if;

    end case;

end process;

output_state <= state;


end Behavioral;

