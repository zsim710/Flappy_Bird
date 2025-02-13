library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity powerup_collision is
  port
  (
    clk                 : in std_logic;
    powerup_on, bird_on : in std_logic;
    powerup_type        : in std_logic_vector(2 downto 0);
    score               : in integer range 0 to 500;
    powerup_active      : out std_logic;
    active_powerup_type : out std_logic_vector(2 downto 0)
  );
end powerup_collision;

architecture behaviour of powerup_collision is
  signal powerup_active_temp      : std_logic;
  signal score_at_collision       : integer := 0;
  signal active_powerup_type_temp : std_logic_vector(2 downto 0);
begin
  process (clk)
  begin
    if rising_edge(clk) then
      if powerup_on = '1' and bird_on = '1' then
        powerup_active_temp      <= '1';
        score_at_collision       <= score; -- store score at time of collision
        active_powerup_type_temp <= powerup_type;
      elsif score - score_at_collision >= 5 then -- check if score has increased by 5
        powerup_active_temp <= '0';
      end if;
    end if;
  end process;

  powerup_active      <= powerup_active_temp;
  active_powerup_type <= active_powerup_type_temp;
end behaviour;