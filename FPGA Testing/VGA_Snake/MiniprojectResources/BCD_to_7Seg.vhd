-- Morteza (March 2023)
-- VHDL code for BCD to 7-Segment conversion
-- In this case, LED is on when it is '0'   
library IEEE;
use IEEE.std_logic_1164.all;   

entity BCD_to_SevenSeg is
     port (BCD_digit : in std_logic_vector(3 downto 0);
           SevenSeg_out : out std_logic_vector(6 downto 0));
end entity;

architecture arc1 of BCD_to_SevenSeg  is
begin
     SevenSeg_out   <=  "1111001"  when BCD_digit = "0001"  else		-- 1
						"0100100"  when BCD_digit = "0010"  else		-- 2
						"0110000"  when BCD_digit = "0011"  else 		-- 3
						"0011001"  when BCD_digit = "0100"  else		-- 4
						"0010010"  when BCD_digit = "0101"  else		-- 5
						"0000010"  when BCD_digit = "0110"  else		-- 6
						"1111000"  when BCD_digit = "0111"  else		-- 7
						"0000000"  when BCD_digit = "1000"  else		-- 8
						"0010000"  when BCD_digit = "1001"  else		-- 9
						"1000000"  when BCD_digit = "0000"  else		-- 0
						"1111111";
end architecture arc1; 
