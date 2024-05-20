library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity score_display is
    port (
        clk: in std_logic;
        v_sync                 : in std_logic;
        training_mode           : in std_logic;
        normal_mode             : in std_logic;
        pixel_row, pixel_column : in std_logic_vector(9 downto 0);
        score                   : in integer range 0 to 9999;  
        text_out                : out std_logic_vector(6 downto 0)
    );
end score_display;

architecture behaviour of score_display is 
    component char_rom is
    port
    (
      character_address  : in std_logic_vector (5 downto 0);
      font_row, font_col : in std_logic_vector (2 downto 0);
      clock              : in std_logic;
      rom_mux_output     : out std_logic
    );
    end component;

    signal char_address : std_logic_vector(5 downto 0);
    signal u_font_row, u_font_col : std_logic_vector(2 downto 0);
    signal u_rom_mux_out     : std_logic;
    signal score_ones      : integer range 0 to 9;
    signal score_tens      : integer range 0 to 9;
    signal score_hundreds  : integer range 0 to 9;
    
begin
    
    char_rom_inst : char_rom
  port map
  (
    character_address => u_char_address,
    font_row          => u_font_row,
    font_col          => u_font_col,
    clock             => clk,
    rom_mux_output    => u_rom_mux_out
  );

    

  process (v_sync, training_mode, normal_mode, pixel_row, pixel_column, score)
  begin
    if (rising_edge(v_sync)) then
        if (training_mode = '1' or normal_mode = '1') then
            u_font_row <= pixel_row(3 downto 1);
            u_font_col <= pixel_column(3 downto 1);
            score_ones <= score mod 10;
            score_tens <= (score/10) mod 10;
            score_hundreds <= (score/100) mod 10;
            if (pixel_row >= 32 and pixel_row <= 47) then 
                if (pixel_column >= 304 and pixel_column <= 319) then
                    case score_hundreds is
                        when 0 => char_address <= "110000"; -- 0
                        when 1 => char_address <= "110001"; -- 1
                        when 2 => char_address <= "110010"; -- 2
                        when 3 => char_address <= "110011"; -- 3
                        when 4 => char_address <= "110100"; -- 4
                        when 5 => char_address <= "110101"; -- 5
                        when 6 => char_address <= "110110"; -- 6
                        when 7 => char_address <= "110111"; -- 7
                        when 8 => char_address <= "111000"; -- 8
                        when 9 => char_address <= "111001"; -- 9
                        when others => char_address <= "110000";
                    end case;
                elsif (pixel_column >= 320 and pixel_column <= 335) then
                    case score_tens is
                        when 0 => char_address <= "110000"; -- 0
                        when 1 => char_address <= "110001"; -- 1
                        when 2 => char_address <= "110010"; -- 2
                        when 3 => char_address <= "110011"; -- 3
                        when 4 => char_address <= "110100"; -- 4
                        when 5 => char_address <= "110101"; -- 5
                        when 6 => char_address <= "110110"; -- 6
                        when 7 => char_address <= "110111"; -- 7
                        when 8 => char_address <= "111000"; -- 8
                        when 9 => char_address <= "111001"; -- 9
                        when others => char_address <= "110000";
                    end case;
                elsif (pixel_column >= 336 and pixel_column <= 351) then
                    case score_ones is
                        when 0 => char_address <= "110000"; -- 0
                        when 1 => char_address <= "110001"; -- 1
                        when 2 => char_address <= "110010"; -- 2
                        when 3 => char_address <= "110011"; -- 3
                        when 4 => char_address <= "110100"; -- 4
                        when 5 => char_address <= "110101"; -- 5
                        when 6 => char_address <= "110110"; -- 6
                        when 7 => char_address <= "110111"; -- 7
                        when 8 => char_address <= "111000"; -- 8
                        when 9 => char_address <= "111001"; -- 9
                        when others => char_address <= "110000";
                    end case;
                end if;
            end if;
        end if;
    end if;
    end process;

    text_out <= u_rom_mux_out;
end behaviour;



