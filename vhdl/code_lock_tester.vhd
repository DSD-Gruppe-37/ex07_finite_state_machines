LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY code_lock_tester IS
    PORT (
        CLOCK_50 : IN std_logic;
        KEY      : IN std_logic_vector(3 DOWNTO 2);
        SW       : IN std_logic_vector(3 DOWNTO 0);
        LEDG     : OUT std_logic_vector(0 DOWNTO 0)
    );
END ENTITY code_lock_tester;

ARCHITECTURE rtl OF code_lock_tester IS

BEGIN

    uut : ENTITY code_lock
        PORT MAP(
            -- INPUTS
            clk   => CLOCK_50,
            reset => KEY(2),
            code  => SW,
            enter => KEY(3),
            -- OUTPUTS
            lock => LEDG(0)
        );

END ARCHITECTURE rtl;