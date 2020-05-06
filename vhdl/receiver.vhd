LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY receiver IS
    PORT
    (
        rxd, reset, clk_baud : IN std_logic;
        --outputs
        test, rxvalid        : OUT std_logic;
        rxdata               : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY receiver;

-- When using the bit counter note that it is actually a sub-state of the reading state.
-- This is described in the code lock exercise step (5). You may use a counter di-
-- rectly, just remember that you will need to store the present_bit_cnt using
-- the state_register, as the output- and next state processes do not have a clock
-- at therefore will infer a latch to store a value (ex: bit_cnt <= bit_cnt + 1
-- must be bit_cnt_next <= bit_cnt_present + 1 in output process)


ARCHITECTURE three_processes OF receiver IS
    TYPE state IS (idle, reading, stopping, latchData);
    SIGNAL present_state, next_state : state;
    SIGNAL bit_cnt                   : unsigned(7 DOWNTO 0);
BEGIN
    -- State register
    state_reg : PROCESS (clk_baud, reset)
    BEGIN
        IF reset = '0' THEN
            present_state <= idle;
        ELSIF rising_edge(clk_baud) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    -- Output: rxvalid
    rxValidator_output : PROCESS (present_state)
        VARIABLE tempData : std_logic_vector(7 DOWNTO 0);
    BEGIN
        CASE present_state IS
            WHEN latchData =>
                rxvalid <= '1';
                rxdata  <= tempData;
            WHEN reading =>
                bit_cnt <= bit_cnt + 1;
                tempData := rxd & tempData(7 DOWNTO 1);
            WHEN OTHERS =>
                rxvalid <= '0';
        END CASE;
    END PROCESS;

    -- Next state
    next_state_proc : PROCESS (present_state, rxd)
    BEGIN
        next_state <= present_state; -- default decleration

        CASE present_state IS
            WHEN idle =>
                IF rxd = '0' THEN
                    next_state <= reading;
                END IF;
            WHEN reading =>
                IF bit_cnt > 7 THEN
                    next_state <= stopping;
                END IF;
            WHEN stopping =>
                IF rxd = '1' THEN
                    next_state <= latchData;
                ELSE
                    next_state <= idle;
                END IF;
            WHEN latchData =>
                next_state <= idle;
                -- defaults
            WHEN OTHERS =>
                next_state <= idle;
        END CASE;
    END PROCESS;

END three_processes;