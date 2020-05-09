LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY uart_tester IS
    PORT
    (
        CLOCK_50 : IN std_logic;
        KEY      : IN std_logic_vector(3 DOWNTO 2);
        SW       : IN std_logic_vector(7 DOWNTO 0);
        LEDR     : OUT std_logic_vector(7 DOWNTO 0);
        LEDG     : OUT std_logic_vector(0 DOWNTO 0);
        HEX0     : OUT std_logic_vector(6 DOWNTO 0);
        GPIO_0   : OUT std_logic_vector(7 DOWNTO 0);
        GPIO_1   : INOUT std_logic_vector(2 DOWNTO 1)
    );
END ENTITY uart_tester;

ARCHITECTURE rtl OF uart_tester IS
    SIGNAL rxData  : std_logic_vector(7 DOWNTO 0);
    SIGNAL rxValid : std_logic;
BEGIN
    uartBlock : ENTITY uart
        PORT MAP
        (
            -- INPUTS
            clk     => CLOCK_50,
            reset   => KEY(2),
            rxd     => GPIO_1(1),
            txdata  => SW,
            txvalid => KEY(3),
            -- OUTPUTS
            -- test    => GPIO_0,
            -- txd     => ledg(0),
            txd     => GPIO_1(2),
            rxdata  => rxData,
            rxvalid => rxValid
        );

    RegisterBlock : ENTITY RegisterEnt
        PORT
        MAP(
        inData   => rxData,
        inValid  => rxValid,
        RegOut   => LEDR
        );
END ARCHITECTURE rtl;