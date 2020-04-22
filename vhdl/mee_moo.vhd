LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

-- We’ll start out with a basic state machine that implements both a Mealy and a Moore state
-- machine. Bear in mind that it is only the output process that differ between the two. The
-- “next state” process handling the state transitions is the same!
--
-- Hint! Start with just looking at the Moore output (Moo_out) and implement the
-- state machine to do this. When it works, create a Mealy output process to generate
-- the Mealy output (Mea_out). In VHDL, create a new “state” type to reflect the
-- three states: “idle”, “init” and “active (See section 10.4 in the book). This will make
-- your code more readable and state names will be visible in the simulation waveform
-- tool.
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
    state_reg : PROCESS (clk)
    BEGIN
        IF reset_bar = '0' THEN
            present_state <= idle;
        ELSIF rising_edge(clk) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    -- Output: Moorly output
    moo_out : PROCESS (present_state)
    BEGIN
        CASE present_state IS
            WHEN idle =>
                moo_out <= '0';
            WHEN init =>
                moo_out <= '1';
            WHEN active =>
                moo_out <= '1';
                -- default branch
            WHEN OTHERS =>
                moo_out <= '0';
        END CASE;
    END PROCESS;

    -- Output: Mealy output
    mee_out : PROCESS (present_state, a, b)
    BEGIN
        CASE present_state IS
            WHEN idle =>
                mee_out <= '0';
            WHEN init =>
                IF (a, b) = "11" THEN
                    mee_out <= '1';
                ELSE
                    mee_out <= '0';
                END IF;
            WHEN active =>
                mee_out <= '0';
                -- default branch
            WHEN OTHERS =>
                mee_out <= '0';

        END CASE;
    END PROCESS;

    -- Next state
    next_state : PROCESS (present_state, a, b)
    BEGIN
        next_state_inner <= present_state; -- default decleration

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
                IF (a, b) = "00" THEN
                    next_state <= idle;
                ELSIF (a, b) = "01" THEN
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