library IEEE;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity ground_rom is
  port
  (
    clock              : in std_logic;
    font_row, font_col : in std_logic_vector (4 downto 0);
    rom_output         : out std_logic_vector(12 downto 0) -- 1-bit alpha and 12-bit color
  );
end entity ground_rom;

architecture Behavioral of ground_rom is

  signal rom_data    : std_logic_vector(12 downto 0); -- 1-bit alpha and 12-bit color
  signal rom_address : std_logic_vector(9 downto 0); -- 8-bit address for 16x16 image

  component altsyncram
    generic
    (
      address_aclr_a         : string;
      clock_enable_input_a   : string;
      clock_enable_output_a  : string;
      init_file              : string;
      intended_device_family : string;
      lpm_hint               : string;
      lpm_type               : string;
      numwords_a             : natural;
      operation_mode         : string;
      outdata_aclr_a         : string;
      outdata_reg_a          : string;
      widthad_a              : natural;
      width_a                : natural;
      width_byteena_a        : natural
    );
    port
    (
      clock0    : in std_logic;
      address_a : in std_logic_vector (9 downto 0);
      q_a       : out std_logic_vector (12 downto 0) -- 1-bit alpha and 12-bit color
    );
  end
  component;

  begin

    altsyncram_inst :
    altsyncram
    generic
    map
    (
    address_aclr_a         => "NONE",
    clock_enable_input_a   => "BYPASS",
    clock_enable_output_a  => "BYPASS",
    init_file              => "water.mif",
    intended_device_family => "Cyclone III",
    lpm_hint               => "ENABLE_RUNTIME_MOD=NO",
    lpm_type               => "altsyncram",
    numwords_a             => 1024, -- 16 * 16 = 256
    operation_mode         => "ROM",
    outdata_aclr_a         => "NONE",
    outdata_reg_a          => "UNREGISTERED",
    widthad_a              => 10, -- address width
    width_a                => 13, -- data width (RGB444)
    width_byteena_a        => 1
    )
    port map
    (
      clock0    => clock,
      address_a => rom_address,
      q_a       => rom_data
    );

    rom_address <= font_row & font_col;
    rom_output  <= rom_data;

  end
  Behavioral;