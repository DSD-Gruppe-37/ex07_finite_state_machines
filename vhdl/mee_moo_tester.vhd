LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY mee_moo_tester IS
    PORT (
        KEY  : IN std_logic_vector(1 DOWNTO 0);
        SW   : IN std_logic_vector(1 DOWNTO 0);
        LEDR : OUT std_logic_vector(1 DOWNTO 0)
    );
END ENTITY mee_moo_tester;

ARCHITECTURE rtl OF mee_moo_tester IS

BEGIN

    uut : ENTITY mee_moo
        PORT MAP(
            clk     => KEY(0),
            reset   => KEY(1),
            a       => SW(0),
            b       => SW(1),
            moo_out => LEDR(0),
            mee_out => LEDR(1)
        );

END ARCHITECTURE rtl;