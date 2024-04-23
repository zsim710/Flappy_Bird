library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_unsigned.all;

entity timer is
  port (  clk    : in  STD_LOGIC;
         start  : in  STD_LOGIC;
         Data_In : in  std_logic_vector(9 downto 0);
         Timer_Out : out STD_LOGIC;
         DISPLAY_ones, DISPLAY_tens, DISPLAY_mins  : out STD_LOGIC_VECTOR(6 downto 0)
  );
end entity;

architecture Behavioral of timer is

  -- Component to convert BCD to Seven Segment
  component BCD_counter is
    port (
      Clk_BCD : in STD_LOGIC;
      Enable : in STD_LOGIC;
      direction : in STD_LOGIC;
      init : in STD_LOGIC;
      Q_Out : out STD_LOGIC_VECTOR(3 downto 0)
    );
  end component;

  -- Component to convert BCD to Seven Segment
  component BCD_to_SevSeg is
    port (
      BCD_digit : in  STD_LOGIC_VECTOR(3 downto 0);
      SevenSeg_out : out STD_LOGIC_VECTOR(6 downto 0)
    );
  end component;

  signal onesCnt       : std_logic_vector(3 downto 0);
  signal tensCnt       : std_logic_vector(3 downto 0);
  signal minsCnt       : std_logic_vector(3 downto 0);

  signal enableonestimer : STD_LOGIC             := '1'; -- Enable the ones counter
  signal enabletenstimer : STD_LOGIC             := '0'; -- Enable the tens timer
  signal enableminstimer : STD_LOGIC             := '0'; -- Enable the mins timer
  signal direction_hard       : STD_LOGIC             := '0'; -- Direction of the counter
  signal init_tenstimer : STD_LOGIC;
  signal Timer_Out_test : STD_LOGIC := '0'; -- Output of the timer

begin
  -- Clock divider process
  Timer_Out_test <= '1' when (minsCnt(1 downto 0) & tensCnt & onesCnt) = Data_In else '0'; -- Output a pulse when the timer reaches 0

  process(Timer_Out_test, tensCnt, onesCnt)
  begin 
  if Timer_Out_test = '1' then
    enabletenstimer <= '0';
    enableonestimer <= '0';
    enableminstimer <= '0';
  elsif tensCnt = "0101" and onesCnt= "1001" then
      enableminstimer <= '1';
      init_tenstimer <= '1' or start;
  elsif onesCnt = "1001" then
    enabletenstimer <= '1';
  else 
    enableminstimer <= '0';
    enabletenstimer <= '0';
    init_tenstimer <= '0' or start;
  end if;
  end process;

  BCD_CounterOnes: BCD_counter
  port map (
    Clk_BCD       => clk, 
    init      => start, -- route the start signal to the init signal of the BCD counter, only need to initialise it once
    enable    => enableonestimer, -- route the enable signal to the enable signal of the BCD counter
    direction => direction_hard, -- route the direction signal to the direction signal of the BCD counter
    Q_Out     => onesCnt
  );

  BCD_CounterTens: BCD_counter
    port map (
      Clk_BCD       => clk, -- Use the synchronized slow clock
      init      => init_tenstimer,
      enable    => enabletenstimer,
      direction => direction_hard,
      Q_Out     => tensCnt
    );

  BCD_Countermins: BCD_counter
    port map (
      Clk_BCD       => clk,
      init      => start,
      enable    => enableminstimer,
      direction => direction_hard,
      Q_Out     => minsCnt
    );


  BCD_to_SevenSegment_ones: BCD_to_SevSeg
    port map (
      BCD_digit => std_logic_vector(onesCnt),-- this is routing the output of the BCD counter to the input for the BCD to 7 segment converter
      SevenSeg_out => DISPLAY_ones -- this is routing the output of the converter to the output LED display of timer entity
    );
    BCD_to_SevenSegment_tens: BCD_to_SevSeg
    port map (
      BCD_digit => std_logic_vector(tensCnt),
      SevenSeg_out => DISPLAY_tens
    );
    BCD_to_SevenSegment_mins: BCD_to_SevSeg
    port map (
      BCD_digit => std_logic_vector(minsCnt),
      SevenSeg_out => DISPLAY_mins
    );

    Timer_Out <= Timer_Out_test;

end architecture;
