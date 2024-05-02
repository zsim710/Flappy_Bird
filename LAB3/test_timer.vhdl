library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity timer_tb is
end timer_tb;

architecture Behavioral of timer_tb is
    
    signal clk    : std_logic := '0';
    signal start  : std_logic := '0';
    signal Data_In : std_logic_vector(9 downto 0) := "0100100110";
    signal Timer_Out : std_logic;
    signal DISPLAY_ones, DISPLAY_tens, DISPLAY_mins  : std_logic_vector(6 downto 0);
    constant clk_period : time := 10 ns;
    
    component timer is
        port (  
            clk    : in  std_logic;
            start  : in  std_logic;
            Data_In : in  std_logic_vector(9 downto 0);
            Timer_Out : out std_logic;
            DISPLAY_ones, DISPLAY_tens, DISPLAY_mins  : out std_logic_vector(6 downto 0)
        );
    end component;
    
begin
    -- Instantiate the unit under test (UUT)
    uut: timer port map (
        clk => clk,
        start => start,
        Data_In => Data_In,
        Timer_Out => Timer_Out,
        DISPLAY_ones => DISPLAY_ones,
        DISPLAY_tens => DISPLAY_tens,
        DISPLAY_mins => DISPLAY_mins
    );

    -- Clock process definitions
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period;
        clk <= '1';
        wait for clk_period;
    end process;
   
    start <= '0', '1' after 30ns, '0' after 40ns;

end Behavioral;