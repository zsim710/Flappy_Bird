library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity image_rom is
  port
  (
    character_address  : in std_logic_vector (7 downto 0);
    font_row, font_col : in std_logic_vector (3 downto 0);
    clock              : in std_logic;
    rom_output         : out std_logic -- 12-bit pixel value
  );
end image_rom;

architecture Behavioral of image_rom is

  signal rom_data    : std_logic_vector(11 downto 0); -- 12-bit pixel value
  signal rom_address : std_logic_vector(11 downto 0); -- 8-bit address for 16x16 image

  component altsyncram
    generic
    (
      address_aclr_a         : string  := "NONE";
      clock_enable_input_a   : string  := "BYPASS";
      clock_enable_output_a  : string  := "BYPASS";
      init_file              : string  := "og_flappy_bird.mif"; -- specify the mif file
      intended_device_family : string  := "Cyclone III";
      lpm_hint               : string  := "ENABLE_RUNTIME_MOD=NO";
      lpm_type               : string  := "altsyncram";
      numwords_a             : natural := 256; -- 16 * 16 = 256
      operation_mode         : string  := "ROM";
      outdata_aclr_a         : string  := "NONE";
      outdata_reg_a          : string  := "UNREGISTERED";
      widthad_a              : natural := 8; -- address width
      width_a                : natural := 12; -- data width (RGB444)
      width_byteena_a        : natural := 1
    );
    port
    (
      clock0    : in std_logic;
      address_a : in std_logic_vector (11 downto 0);
      q_a       : out std_logic_vector (11 downto 0)
    );
  end component;

begin

  altsyncram_inst : altsyncram
  generic
  map
  (
  address_aclr_a         => "NONE",
  clock_enable_input_a   => "BYPASS",
  clock_enable_output_a  => "BYPASS",
  init_file              => "og_flappy_bird.mif", -- specify the mif file
  intended_device_family => "Cyclone III",
  lpm_hint               => "ENABLE_RUNTIME_MOD=NO",
  lpm_type               => "altsyncram",
  numwords_a             => 256, -- 16 * 16 = 256
  operation_mode         => "ROM",
  outdata_aclr_a         => "NONE",
  outdata_reg_a          => "UNREGISTERED",
  widthad_a              => 8, -- address width
  width_a                => 12, -- data width (RGB444)
  width_byteena_a        => 1
  )
  port map
  (
    clock0    => clock,
    address_a => rom_address,
    q_a       => rom_data
  );

  rom_address <= character_address & font_row;
  rom_output  <= rom_data (CONV_INTEGER(not font_col(2 downto 0)));

end Behavioral;