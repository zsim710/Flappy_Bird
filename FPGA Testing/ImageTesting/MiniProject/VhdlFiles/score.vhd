library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_SIGNED.all;

entity score is
  port (
    clk, reset, vert_sync   : in  std_logic;
    pipe_passed, ball_on, output_collision : in  std_logic;
    score                 : out integer range 0 to 9999
  );
end entity;

architecture rtl of score is

    begin

        process(clk)
        variable score_V : integer range 0 to 9999;
        begin
            if(rising_edge(pipe_passed) and output_collision = '0' ) then
                    score_V := score_V + 1;
            end if;
            score <= score_V;
            end process;

end architecture;
