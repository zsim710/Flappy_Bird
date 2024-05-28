library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GaloisLFSR8 is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           lfsr_out : out STD_LOGIC_VECTOR(7 downto 0));
end GaloisLFSR8;

architecture Behavioral of GaloisLFSR8 is
    signal lfsr : STD_LOGIC_VECTOR(7 downto 0) := "00000001";  -- initial seed
begin
    process(clk, reset)
    begin
        if reset = '1' then
            lfsr <= "00000001";  -- reset to initial seed
        elsif rising_edge(clk) then
            -- Compute feedback from taps at 8th, 6th, 5th, and 4th bits
            -- Note: VHDL vector index starts from 0, so adjust accordingly
            lfsr(7 downto 1) <= lfsr(6 downto 0);
            lfsr(0) <= lfsr(7) xor lfsr(5) xor lfsr(4) xor lfsr(3);
        end if;
    end process;

    lfsr_out <= lfsr;
end Behavioral;
