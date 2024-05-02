library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  use IEEE.std_logic_unsigned.all;

entity BCD_counter is
  port (
    Clk_BCD : in STD_LOGIC;
    Enable : in STD_LOGIC;
    direction : in STD_LOGIC;
    init : in STD_LOGIC;
    Q_Out : out STD_LOGIC_VECTOR(3 downto 0)
  );
end entity;

architecture Behavioral of BCD_counter is
  signal Q : UNSIGNED(3 downto 0);
begin
  process (Clk_BCD)
  begin
    if rising_edge(Clk_BCD) then
      if (init = '1') then
        if (direction = '0') then
          Q <= "0000"; -- Initialize to 0 for up counter
        else
          Q <= "1001"; -- Initialize to 9 for down counter
        end if;
      elsif (Enable = '1') then
        if (direction = '0') then
          if Q = "1001" then -- If Q is 9, reset to 0
            Q <= "0000";
          else
            Q <= Q + 1; -- Up counter
          end if;
        else
          if Q = "0000" then -- If Q is 0, reset to 9
            Q <= "1001";
          else
            Q <= Q - 1; -- Down counter
          end if;
        end if;
      end if;
    end if;
  end process;
  Q_Out <= STD_LOGIC_VECTOR(Q);

end architecture;