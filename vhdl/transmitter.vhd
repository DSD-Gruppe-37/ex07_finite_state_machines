LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY transmitter IS
    PORT
    (
        txvalid, reset, clk_baud : IN std_logic;
        txdata                   : IN std_logic_vector(7 DOWNTO 0);
        --outputs
        -- test                     : OUT std_logic_vector(7 DOWNTO 0);
        txd                      : OUT std_logic
    );
END ENTITY transmitter;

-- When using the bit counter note that it is actually a sub-state of the reading state.
-- This is described in the code lock exercise step (5). You may use a counter di-
-- rectly, just remember that you will need to store the present_bit_cnt using
-- the state_register, as the output- and next state processes do not have a clock
-- at therefore will infer a latch to store a value (ex: bit_cnt <= bit_cnt + 1
-- must be bit_cnt_next <= bit_cnt_present + 1 in output process)

ARCHITECTURE three_processes OF transmitter IS
    TYPE state IS (idle, transmit, stopping, latchData);
    SIGNAL present_state, next_state              : state;
    SIGNAL present_bit_cnt, next_bit_cnt, bit_cnt : unsigned(7 DOWNTO 0);
BEGIN
    -- State register
    state_reg : PROCESS (clk_baud, reset)
    BEGIN
        IF reset = '0' THEN
            present_state   <= idle;
            present_bit_cnt <= (OTHERS => '0'); -- set count to zero...
        ELSIF rising_edge(clk_baud) THEN
            present_state   <= next_state;
            present_bit_cnt <= next_bit_cnt; -- set count to next value (???)
        END IF;
    END PROCESS;

    -- Output: txvalid
    txValidator_output : PROCESS (present_state)
        VARIABLE tempData : std_logic_vector(7 DOWNTO 0);
    BEGIN
        CASE present_state IS
            WHEN latchData =>
                txd <= '0';
                tempData := txdata;
            WHEN transmit =>
                -- bit_cnt <= bit_cnt + 1;
                next_bit_cnt <= present_bit_cnt + 1;--- According to JK 
                -- tempData := txd & tempData(7 DOWNTO 1);
                txd  <= tempData(to_integer(present_bit_cnt));
            WHEN stopping =>
                txd <= '1';
            WHEN OTHERS =>

        END CASE;
    END PROCESS;

    -- Next state
    next_state_proc : PROCESS (present_state, txvalid)
    BEGIN
        next_state <= present_state; -- default decleration
        CASE present_state IS
            WHEN idle =>
                IF txvalid = '0' THEN
                    next_state <= latchData;
                END IF;
            WHEN transmit =>
                IF present_bit_cnt > 7 THEN
                    next_state <= stopping;
                END IF;
            WHEN stopping =>
                next_state <= idle;
            WHEN latchData =>
                next_state <= transmit;
                -- defaults
            WHEN OTHERS =>
                next_state <= idle;
        END CASE;
    END PROCESS;

END three_processes;