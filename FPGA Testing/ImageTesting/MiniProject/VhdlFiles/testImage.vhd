library ieee;
use ieee.std_logic_1164.all;

entity file_io is
    port (
        clk:    in  std_logic;
        Data:   out std_logic_vector(7 downto 0);
        done:   out boolean
 );
 end entity;

architecture foo of file_io is
    use ieee.numeric_std.all;
begin

File_reader:
    process (clk)
        -- ""C:\Users\deven\Documents\305\305_proj\FPGA Testing\ImageTesting\MiniProject\VhdlFiles\original_flappy_bird.png"";
        constant filename:  string := "original_flappy_bird.png"; -- local to sim
        variable char_val:  character;
        variable status: FILE_OPEN_STATUS;
        variable openfile:  boolean;  -- FALSE by default
        type f is file of character;
        file ffile: f;
        variable char_count:    natural := 0;
    begin
        if rising_edge (clk) then
            if not openfile then
                file_open (status, ffile, filename, READ_MODE);
                if status /= OPEN_OK then
                    report "FILE_OPEN_STATUS = " & 
                            FILE_OPEN_STATUS'IMAGE(status)
                    severity FAILURE;
                end if;
                report "FILE_OPEN_STATUS = " & FILE_OPEN_STATUS'IMAGE(status);
                openfile := TRUE;
            else 
                if not endfile(ffile) then
                    read(ffile, char_val);
                    -- report "char_val = " & character'image(char_val);
                    char_count := char_count + 1;
                    Data  <= std_logic_vector (
                             to_unsigned(character'pos(char_val),
                             Data'length) );
                 end if;
                 if endfile(ffile) then  -- can occur after last character
                    report "ENDFILE, read " & 
                          integer'image(char_count) & "characters";
                    done <= TRUE;
                    FILE_CLOSE(ffile);
                end if;
            end if;
        end if;
    end process;
end architecture foo;

library ieee;
use ieee.std_logic_1164.all;

entity file_io_test is 
end file_io_test;

architecture behavior of file_io_test is
    signal clk:         std_logic := '0';
    signal data:        std_logic_vector(7 downto 0);
    signal done:        boolean;
    constant clk_period: time := 10 ns;
begin
uut:
    entity work.file_io(foo)
        port map (
           clk => clk,
           data => data,
           done => done
        );
        
clk_process:
    process
    begin
        if not done then
             clk <= '1';
             wait for clk_period/2;
              clk <= '0';
             wait for clk_period/2;
         else
             wait;
         end if;
     end process;
end architecture behavior;  