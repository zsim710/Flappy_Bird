library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_SIGNED.all;

entity score is
  port (
    clk, reset, vert_sync   : in  std_logic;
    pipe_passed, ball_on, collison_counter, output_collision : in  std_logic;
    score                 : integer std_logic
  );
end entity;

architecture rtl of score is

    signal score_booleen : std_logic;

    begin

        process(clk)
        variable score_V : integer range 0 to 500;
        begin
            if(rising_edge(pipe_passed) and output_collision = '0' ) then
                    score_V := score_V + 1;
            end if;
            score <= score_S;
            end process;

end architecture;
