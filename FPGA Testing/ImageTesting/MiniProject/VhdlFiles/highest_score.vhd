library ieee;
  use ieee.std_logic_1164.all;
  use ieee.std_logic_arith.all;
  use ieee.std_logic_unsigned.all;

entity highest_score is
  port (
    clk               : in  std_logic;
    reset             : in  std_logic;
    collision_counter : in  integer range 0 to 3;
    score             : in  integer range 0 to 1000;
    highest           : out std_logic_vector(7 downto 0)
  );
end entity;

architecture Behavioral of highest_score is
  variable highest_score : integer range 0 to 1000;
begin
  process (clk)
  begin
    if (rising_edge(clk) and (collision_counter = 3)) then
      if score > highest_score then
        highest_score := score;
      end if;
    end if;
    highest <= highest_score;
  end process;
end architecture;



