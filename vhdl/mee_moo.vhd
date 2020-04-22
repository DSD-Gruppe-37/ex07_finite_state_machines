LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY mee_moo IS
    PORT (
        clk, reset, a, b : IN std_logic;
        moo_out, mee_out : OUT std_logic
    );
END mee_moo;

ARCHITECTURE three_processes OF mee_moo IS
    TYPE state IS (idle, init, active);
    SIGNAL present_state, next_state : state;
BEGIN

    -- State register
    state_reg : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN
            present_state <= idle;
        ELSIF rising_edge(clk) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    -- Output: Moore output
    moore_output : PROCESS (present_state)
    BEGIN
        CASE present_state IS
            WHEN idle =>
                moo_out <= '0';
            WHEN init | active =>
                moo_out <= '1';
                -- default branch
            WHEN OTHERS =>
                moo_out <= '0';
        END CASE;
    END PROCESS;

    -- Output: Mealy output
    mealy_output : PROCESS (present_state, a, b)
    BEGIN
        CASE present_state IS
            WHEN idle | active =>
                mee_out <= '0';
            WHEN init =>
                IF a = '1' AND b = '1' THEN
                    mee_out <= '1';
                ELSE
                    mee_out <= '0';
                END IF;
                -- default branch
            WHEN OTHERS =>
                mee_out <= '0';

        END CASE;
    END PROCESS;

    -- Next state
    next_state_proc : PROCESS (present_state, a, b)
    BEGIN
        next_state <= present_state; -- default decleration

        CASE present_state IS
            WHEN active =>
                next_state <= idle;
            WHEN idle =>
                IF a = '1' THEN
                    next_state <= init;
                ELSE
                    next_state <= idle;
                END IF;
            WHEN init =>
                IF a = '0' AND b = '0' THEN
                    next_state <= idle;
                ELSIF a = '0' AND b = '1' THEN
                    next_state <= active;
                ELSE
                    next_state <= init;
                END IF;
                -- default branch
            WHEN OTHERS =>
                next_state <= idle;
        END CASE;
    END PROCESS;

END three_processes;