LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY clock_gen IS
    PORT
    (
        -- inputs
        clk     : IN std_logic;
        reset   : IN std_logic;
        speed   : IN std_logic;
        -- outputs
        clk_out : OUT std_logic
    );
END ENTITY clock_gen;
ARCHITECTURE ClockDivider OF clock_gen IS

    -- Signals to be used:
    SIGNAL ClkDivCounter : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0'); -- For clock divisons.
    SIGNAL ClkDiv        : std_logic                     := '0';             -- Positive vs negat   ive period

BEGIN

    ClockDivider : PROCESS (clk, reset)
        VARIABLE speedSelector : INTEGER;
    BEGIN
        -- speed selection  
        CASE (speed) IS
            WHEN '0'    => speedSelector    := 25e6; -- 0.5 sec clock   
            WHEN '1'    => speedSelector    := 50e6; -- 1.0 sec clock
            WHEN OTHERS => speedSelector := 100e6;   -- 2.0  sec clock for errors
        END CASE;

        -- reset on speed limit
        IF rising_edge(clk) THEN
            IF (to_integer(unsigned(ClkDivCounter)) >= speedSelector) THEN --50MHz clock counting to sel. speed.
                ClkDivCounter <= (OTHERS => '0');                              --Reset clock when limit is reached.
                ClkDiv        <= '1';                                          --Set output hi
            ELSE
                ClkDivCounter <= std_logic_vector(unsigned(ClkDivCounter) + 1); --Increment - else keep counting
                ClkDiv        <= '0';                                           -- with a low output
            END IF;

        END IF;
        --hard reset -- 
        IF (reset = '0' OR ClkDiv = '1') THEN
            ClkDivCounter <= (OTHERS => '0'); -- reset counter to 0..
            ClkDiv        <= '0';             -- with a low output
        END IF;
    END PROCESS;
    clk_out <= ClkDiv; -- assign the clock to clock output.
END ARCHITECTURE ClockDivider;