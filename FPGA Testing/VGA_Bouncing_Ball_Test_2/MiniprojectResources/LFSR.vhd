LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;

entity lfsr is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           lfsr_out : out  STD_LOGIC_VECTOR (3 downto 0));
end lfsr;

architecture Behavioral of LFSR_RNG is
    signal lfsr_reg : std_logic_vector(7 downto 0) := "11001101"; -- Initial seed, non-zero
begin
    process(CLK, Rst)
    begin
        if Rst = '1' then
            lfsr_reg <= (others => '1'); -- Reset to all ones or any non-zero value
        elsif rising_edge(CLK) then
            lfsr_reg <= lfsr_reg(6 downto 0) & (lfsr_reg(7) xor lfsr_reg(5) xor lfsr_reg(4) xor lfsr_reg(3));
        end if;
    end process;

    Random_Out <= lfsr_reg; -- Output the current value of the LFSR
end Behavioral;
