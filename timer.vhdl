library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.std_logic_unsigned.all;

entity timer is
  port
  (
    Clk                                      : in std_logic;
    Start                                    : in std_logic;
    Data_In                                  : in std_logic_vector(9 downto 0);
    Timer_Out                                : out std_logic;
    DISPLAY_ones, DISPLAY_tens, DISPLAY_mins : out std_logic_vector(6 downto 0) --For testbench
  );
end entity;

architecture Behavioral of timer is

  -- Component to iterate counter for segments
  component BCD_counter is
    port
    (
      Clk_BCD   : in std_logic;
      Enable    : in std_logic;
      direction : in std_logic;
      init      : in std_logic;
      Q_Out     : out std_logic_vector(3 downto 0)
    );
  end component;

  -- Component to convert BCD to Seven Segment
  component BCD_to_SevSeg is
    port
    (
      BCD_digit    : in std_logic_vector(3 downto 0);
      SevenSeg_out : out std_logic_vector(6 downto 0)
    );
  end component;

  --Clock divider to get new frequency
  component Clock_Divider is
    port
    (
      Clk_in  : in std_logic;
      divider : in integer;
      clk_out : out std_logic
    );
  end component;

  signal onesCnt : std_logic_vector(3 downto 0);
  signal tensCnt : std_logic_vector(3 downto 0);
  signal minsCnt : std_logic_vector(3 downto 0);

  signal enableonestimer : std_logic := '1'; -- Enable the ones counter
  signal enabletenstimer : std_logic := '0'; -- Enable the tens timer
  signal enableminstimer : std_logic := '0'; -- Enable the mins timer
  signal direction_hard  : std_logic := '0'; -- Hard set direction counter to go up
  signal init_tenstimer  : std_logic; --Initialise the tens timer
  signal v_Timer_Out     : std_logic := '0'; -- Output of the timer
  signal clk_1hz         : std_logic; -- 1Hz clock signal

begin
  -- Makes sure the timer is off until it reaches the Data_In value
  v_Timer_Out <= '1' when (minsCnt(1 downto 0) & tensCnt & onesCnt) = Data_In else
    '0';

  divide_clock : Clock_Divider
  port map
  (
    Clk_in  => Clk,
    divider => 50000000, -- 1Hz 
    clk_out => clk_1hz
  );

  BCD_CounterOnes : BCD_counter
  port
  map (
  Clk_BCD   => Clk,
  init      => Start, -- route the start signal to the init signal of the BCD counter, only need to initialise it once
  enable    => enableonestimer, -- route the enable signal to the enable signal of the BCD counter
  direction => direction_hard, -- route the direction signal to the direction signal of the BCD counter
  Q_Out     => onesCnt
  );

  enabletenstimer <= '1' when onesCnt = "1001" else
    '0';

  BCD_CounterTens : BCD_counter
  port
  map (
  Clk_BCD   => Clk, -- Use the synchronized slow clock
  init      => init_tenstimer,
  enable    => enabletenstimer,
  direction => direction_hard,
  Q_Out     => tensCnt
  );

  -- init tens when time is 59 seconds
  init_tenstimer <= '1' when (tensCnt = "0101" and onesCnt = "1001") else
    '0';

  -- roll time over to next minute at 59 seconds
  enableminstimer <= '1' when (tensCnt = "0101" and onesCnt = "1001") else
    '0';

  BCD_Countermins : BCD_counter
  port
  map (
  Clk_BCD   => Clk,
  init      => start,
  enable    => enableminstimer,
  direction => direction_hard,
  Q_Out     => minsCnt
  );
  BCD_to_SevenSegment_ones : BCD_to_SevSeg
  port
  map (
  BCD_digit    => std_logic_vector(onesCnt), -- this is routing the output of the BCD counter to the input for the BCD to 7 segment converter
  SevenSeg_out => DISPLAY_ones -- this is routing the output of the converter to the output LED display of timer entity
  );
  BCD_to_SevenSegment_tens : BCD_to_SevSeg
  port
  map (
  BCD_digit    => std_logic_vector(tensCnt),
  SevenSeg_out => DISPLAY_tens
  );
  BCD_to_SevenSegment_mins : BCD_to_SevSeg
  port
  map (
  BCD_digit    => std_logic_vector(minsCnt),
  SevenSeg_out => DISPLAY_mins
  );

  Timer_Out <= v_Timer_Out;

end architecture;