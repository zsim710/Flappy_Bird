library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_SIGNED.all;
entity ground is
  port
  (
    vert_sync               : in std_logic;
    pixel_row, pixel_column : in std_logic_vector(9 downto 0);
    ground_on               : out std_logic
  );
end entity ground;

architecture behavior of ground is
  signal ground_height               : std_logic_vector(10 downto 0);
  signal screen_width, screen_height : std_logic_vector(10 downto 0);
  signal ground_x_pos                : std_logic_vector(10 downto 0) := CONV_STD_LOGIC_VECTOR(319, 11);
  signal ground_y_pos                : std_logic_vector(9 downto 0)  := CONV_STD_LOGIC_VECTOR(239, 10);

begin
  -- Screen and pipe dimensions
  screen_width  <= CONV_STD_LOGIC_VECTOR(640, 11);
  screen_height <= CONV_STD_LOGIC_VECTOR(480, 11);
  ground_height <= CONV_STD_LOGIC_VECTOR(30, 11);

  ground_on <= '1' when ('0' & ground_x_pos <= '0' & pixel_column + screen_width) and ('0' & pixel_column <= '0' & ground_x_pos + screen_width) -- x_pos - size <= pixel_column <= x_pos + size
    and ('0' & ground_y_pos <= pixel_row + ground_height) and ('0' & pixel_row <= ground_y_pos + ground_height) else -- y_pos - size <= pixel_row <= y_pos + size
    '0';
  -- Set the output colors, pipe in red, background in black
end behavior;