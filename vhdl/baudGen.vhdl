LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY baudGen IS
    PORT
    (
        -- inputs
        clk, reset : IN std_logic;
        -- outputs
        clk_baud   : OUT std_logic
    );
END ENTITY baudGen;
ARCHITECTURE ClockDivider OF baudGen IS

    -- Signals to be used:
    SIGNAL ClkDivCounter : std_logic_vector(31 DOWNTO 0) := (OTHERS => '0'); -- For clock divisons.
    SIGNAL ClkDiv        : std_logic                     := '0';             -- Positive vs negat   ive period

BEGIN

    ClockDivider : PROCESS (clk, reset)
    BEGIN

        -- reset on speed limit
        IF rising_edge(clk) THEN
            IF (to_integer(unsigned(ClkDivCounter)) >= 434) THEN --50MHz clock counting to sel. speed. (input rate/Target rate)= x
                ClkDivCounter <= (OTHERS => '0');                    --Reset clock when limit is reached.
                ClkDiv        <= '1';                                --Set output hi
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