LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE WORK.ALL;
ENTITY code_lock IS
    PORT
    (
        clk, reset, enter : IN std_logic;
        code              : IN std_logic_vector(3 DOWNTO 0);
        lock              : OUT std_logic;
        err_event         : OUT std_logic;
        states            : OUT std_logic_vector(3 DOWNTO 0)
    );
END code_lock;

ARCHITECTURE three_processes OF code_lock IS
    TYPE state IS (
        idle,           -- 0
        eval_code_1,    -- 1
        getting_code_2, -- 2
        eval_code_2,    -- 3
        going_idle,     -- 4
        unlocked,       -- 5
        wrong_code,     -- 6
        perma_locked    -- 7
    );
    SIGNAL present_state, next_state : state;
    SIGNAL err_signal                : std_logic;
    SIGNAL fail_signal               : std_logic;
    SIGNAL state_signal              : INTEGER;
    CONSTANT code_1                  : std_logic_vector(3 DOWNTO 0) := "1010";
    CONSTANT code_2                  : std_logic_vector(3 DOWNTO 0) := "0101";
BEGIN

    -- Visning af state via. HEX Display
    state_signal <= state'pos(present_state);
    states       <= std_logic_vector(to_unsigned(state_signal, 4));

    -- State register
    state_reg : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN
            present_state <= idle;
        ELSIF rising_edge(clk) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    -- Output: lock
    lock_output : PROCESS (present_state)
    BEGIN
        CASE present_state IS
            WHEN unlocked =>
                lock <= '0';
            WHEN OTHERS =>
                lock <= '1';
        END CASE;
    END PROCESS;

    -- Output: Mealy output
    err_output : PROCESS (present_state)
    BEGIN
        CASE present_state IS
            WHEN wrong_code =>
                err_signal <= '1';
                err_event  <= '0';
            WHEN perma_locked =>
                err_event <= '1';
                err_signal <= '0';
            WHEN OTHERS =>
                err_event  <= '0';
                err_signal <= '0';
        END CASE;
    END PROCESS;
    -- Next state
    next_state_proc : PROCESS (present_state, enter, code, fail_signal)
    BEGIN
        next_state <= present_state; -- default decleration

        CASE present_state IS
            WHEN idle =>
                IF enter = '0' THEN
                    next_state <= eval_code_1;
                END IF;
            WHEN eval_code_1 =>
                IF enter = '1' AND code = code_1 THEN
                    next_state <= getting_code_2;
                ELSIF enter = '1' AND code /= code_1 THEN
                    next_state <= wrong_code;
                END IF;
            WHEN getting_code_2 =>
                IF enter = '0' THEN
                    next_state <= eval_code_2;
                END IF;
            WHEN eval_code_2 =>
                IF enter = '1' AND code = code_2 THEN
                    next_state <= unlocked;
                ELSIF enter = '1' AND code /= code_2 THEN
                    next_state <= wrong_code;
                END IF;
            WHEN going_idle =>
                IF enter = '1' THEN
                    next_state <= idle;
                END IF;
            WHEN unlocked =>
                IF enter = '0' THEN
                    next_state <= going_idle;
                END IF;
            WHEN wrong_code =>
                IF enter = '0' THEN
                    IF fail_signal = '1' THEN
                        next_state <= perma_locked;
                    ELSIF fail_signal = '0' THEN
                        next_state <= going_idle;
                    END IF;
                END IF;

            WHEN perma_locked =>
                next_state <= perma_locked;
                -- default branch
            WHEN OTHERS =>
                next_state <= idle;
        END CASE;
    END PROCESS;

    wrong_codeEnt : ENTITY wrongCode
        PORT MAP
        (
            clk    => err_signal,
            reset  => reset,
            failed => fail_signal
        );

END three_processes;