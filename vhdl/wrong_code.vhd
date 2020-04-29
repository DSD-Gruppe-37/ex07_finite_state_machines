LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY wrongCode IS
    PORT
    (
        clk    : IN std_logic;
        reset  : IN std_logic;
        failed : OUT std_logic
    );
END wrongCode;

ARCHITECTURE stateMachine OF wrongCode IS
    TYPE state IS (
        Err_0,
        Err_1,
        Err_2,
        Err_3
    );
    SIGNAL present_state, next_state : state;

BEGIN

    -- State register
    state_reg : PROCESS (clk, reset)
    BEGIN
        IF reset = '0' THEN
            present_state <= Err_0;
        ELSIF rising_edge(clk) THEN
            present_state <= next_state;
        END IF;
    END PROCESS;

    -- Output: Moore output
    failed_output : PROCESS (present_state)
    BEGIN
        CASE present_state IS
            WHEN Err_3 =>
                failed <= '1';
            WHEN OTHERS =>
                failed <= '0';
        END CASE;
    END PROCESS;

    -- Next state
    next_state_proc : PROCESS (present_state, clk)
    BEGIN
        next_state <= present_state; -- default decleration
        CASE present_state IS
            WHEN Err_0 =>
                next_state <= Err_1;
            WHEN Err_1 =>
                next_state <= Err_2;
            WHEN Err_2 =>
                next_state <= Err_3;
            WHEN Err_3 =>
                next_state <= present_state;
        END CASE;
    END PROCESS;

END stateMachine; -- wrongCode