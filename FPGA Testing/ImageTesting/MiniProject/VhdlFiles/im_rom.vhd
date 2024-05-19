library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity image_rom is
  port
  (
    image_address : in std_logic_vector (3 downto 0); -- 16 images, needs 4 bits
    pixel_row     : in std_logic_vector (5 downto 0); -- 64 rows, needs 6 bits
    pixel_col     : in std_logic_vector (5 downto 0); -- 64 columns, needs 6 bits
    clock         : in std_logic;
    rom_output    : out std_logic_vector (7 downto 0) -- 8-bit pixel value
  );
end image_rom;

architecture Behavioral of image_rom is

  signal rom_data    : std_logic_vector(7 downto 0);
  signal rom_address : std_logic_vector(8 downto 0);

  component altsyncram
    generic
    (
      address_aclr_a         : string  := "NONE";
      clock_enable_input_a   : string  := "BYPASS";
      clock_enable_output_a  : string  := "BYPASS";
      init_file              : string  := "og_flappy_bird.bin"; -- Use the binary file directly
      intended_device_family : string  := "Cyclone III";
      lpm_hint               : string  := "ENABLE_RUNTIME_MOD=NO";
      lpm_type               : string  := "altsyncram";
      numwords_a             : natural := 4096;
      operation_mode         : string  := "ROM";
      outdata_aclr_a         : string  := "NONE";
      outdata_reg_a          : string  := "UNREGISTERED";
      widthad_a              : natural := 12;
      width_a                : natural := 8;
      width_byteena_a        : natural := 1
    );
    port
    (
      clock0    : in std_logic;
      address_a : in std_logic_vector (11 downto 0);
      q_a       : out std_logic_vector (7 downto 0)
    );
  end component;

begin

  rom_address <= image_address & pixel_row & pixel_col;

  altsyncram_inst : altsyncram
  generic
  map
  (
  address_aclr_a         => "NONE",
  clock_enable_input_a   => "BYPASS",
  clock_enable_output_a  => "BYPASS",
  init_file              => "og_flappy_bird.bin", -- Specify the binary file here
  intended_device_family => "Cyclone III",
  lpm_hint               => "ENABLE_RUNTIME_MOD=NO",
  lpm_type               => "altsyncram",
  numwords_a             => 4096,
  operation_mode         => "ROM",
  outdata_aclr_a         => "NONE",
  outdata_reg_a          => "UNREGISTERED",
  widthad_a              => 12,
  width_a                => 8,
  width_byteena_a        => 1
  )
  port map
  (
    clock0    => clock,
    address_a => rom_address,
    q_a       => rom_data
  );

  rom_output <= rom_data;

end Behavioral;