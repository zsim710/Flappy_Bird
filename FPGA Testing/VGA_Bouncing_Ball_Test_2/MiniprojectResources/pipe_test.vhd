LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY pipe_tb IS
END pipe_tb;

ARCHITECTURE behavior OF pipe_tb IS
    -- Signals for interfacing with the pipe
    SIGNAL clk, vert_sync : std_logic := '0';
    SIGNAL pixel_row, pixel_column : std_logic_vector(9 DOWNTO 0) := (others => '0');
    SIGNAL red, green, blue : std_logic;

    -- Component declaration of the pipe
    COMPONENT pipe
        PORT(
            clk, vert_sync : IN std_logic;
            pixel_row, pixel_column : IN std_logic_vector(9 DOWNTO 0);
            red, green, blue : OUT std_logic
        );
    END COMPONENT;

    -- Instantiate the pipe
    BEGIN
        uut: pipe PORT MAP(
            clk => clk,
            vert_sync => vert_sync,
            pixel_row => pixel_row,
            pixel_column => pixel_column,
            red => red,
            green => green,
            blue => blue
        );

        -- Clock generation (simulate a 25 MHz clock, period = 40 ns)
        clk_process: PROCESS
        BEGIN
            clk <= '1';
            WAIT FOR 20 ns;
            clk <= '0';
            WAIT FOR 20 ns;
        END PROCESS;

        -- Simulate the vertical sync signal (assuming 60 Hz refresh rate, period = 16.67 ms)
        vert_sync_process: PROCESS
        BEGIN
            vert_sync <= '1';
            WAIT FOR 833.5 us; -- High for half the period
            vert_sync <= '0';
            WAIT FOR 833.5 us; -- Low for the other half
        END PROCESS;

        -- Test stimulus to scan through all pixel columns and rows
        pixel_scan_process: PROCESS
        BEGIN
            FOR x IN 0 TO 639 LOOP -- Assuming screen width 640
                FOR y IN 0 TO 479 LOOP -- Assuming screen height 480
                    -- BEGIN: ed8c6549bwf9
                    pixel_column <= std_logic_vector(to_unsigned(x, 10));
                    -- END: ed8c6549bwf9
                    pixel_row <= std_logic_vector(to_unsigned(y, 10));
                    WAIT FOR 40 ns; -- Wait one clock cycle
                END LOOP;
            END LOOP;
            WAIT;
        END PROCESS;
END behavior;
