library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use IEEE.STD_LOGIC_SIGNED.all;

entity score is
  port (
    normal_mode, training_mode, clk, reset, vert_sync   : in  std_logic;
    gap_on, ball_on : in  std_logic;
    score                 : integer std_logic
  );
end entity;

architecture rtl of score is

    signal score_booleen : std_logic;
    signal score_S : integer := 0;

    component collision_holder is
        Port ( clk : in  STD_LOGIC;
               ball_on, pipe_on : in  STD_LOGIC;
               output_collision : out  STD_LOGIC);
    end component;


    begin

        collision_with_exit: collision_holder
        port map (
        clk      => clk,
        ball_on => ball_on,
        pipe_on => gap_on,
        output_collision => score_booleen
        );

        process(vert_sync)
        begin
            if(rising_edge(vert_sync)) then
                if(score_booleen = '1') then
                    score_S <= score_S + 1;
                end if;
            end if;
            end process;
            score <= score_S;



end architecture;
