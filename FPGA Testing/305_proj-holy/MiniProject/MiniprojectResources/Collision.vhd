Library IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE  IEEE.STD_LOGIC_ARITH.all;
USE  IEEE.STD_LOGIC_UNSIGNED.all;

entity collision_holder is
    Port ( clk : in  STD_LOGIC;
           ball_on, pipe_on : in  STD_LOGIC;
           output_collision : out  STD_LOGIC);
end collision_holder;

architecture Behavioral of collision_holder is
    signal pre_col : std_logic;
    signal curent_col : std_logic;

    begin
    process(clk)
    begin
        if rising_edge(clk) then
            if ball_on = '1' and pipe_on = '1' and pre_col = '0' then
                curent_col <= '1';
            else
                curent_col <= '0';
            end if;
        pre_col <= curent_col;
        end if;
        output_collision <= curent_col;
    end process;

end Behavioral;






