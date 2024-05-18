-- Add the damn libraries up here
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
--Entity begins here
entity BCD_Counter is
  port
  (
    Clk       : in std_logic;
    Direction : in std_logic;
    Init      : in std_logic;
    Enable    : in std_logic;
    Q_Out     : out integer
  );
end entity BCD_Counter;

--Architecture will begin here
architecture behaviour of BCD_Counter is
begin
  process (Clk) is
    --      Create a dummy variable v_Q_Out
    variable v_Q_Out          : integer := 9;
    variable tens_condition_met : integer;
    --      The whole thing works if 'ENABLE' is 1, so check it 1st

  begin
    if (rising_edge(Clk)) then
      if (Enable = '1') then
        --              If it don't, just keep reading the current value
        --          Next, check the DIRECTION. If it reads '0', it is a down counter
        if (Direction = '1') then
          if (Init = '1' or v_Q_Out = 0) then --              If INIT reads '1' as well, then set value to '9'
            v_Q_Out := 9;
          else
            v_Q_Out := v_Q_Out - 1;
          end if;
        elsif (Direction = '0') then --          If DIRECTION reads '1', it is an up counter
          if (Init = '1' or v_Q_Out = 9) then --              If INIT reads '1' as well, then set value to '9'
            v_Q_Out := 0;
          else
            v_Q_Out := v_Q_Out + 1;
          end if; --              If INIT reads' 1' asw, then set value to '0'
        end if;
      end if;
    end if;
    Q_Out <= v_Q_Out; --      update the Q_Out value using v_Q_Out
  
  end process;

end architecture behaviour; --  end process;