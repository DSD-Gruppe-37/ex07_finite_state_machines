LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY uart IS
    PORT
    (
        -- inputs
        clk, reset, rxd, txvalid : IN std_logic;
        txdata                   : IN std_logic_vector(7 DOWNTO 0);
        -- outputs
        txd, rxvalid, test       : OUT std_logic;
        rxdata                   : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY uart;

ARCHITECTURE rtl OF uart IS

    SIGNAL clk_baud : std_logic;

BEGIN

    baudRateGen : ENTITY baudGen
        PORT MAP
        (
            -- INPUTS
            clk      => clk,
            reset    => reset,
            -- OUTPUTS
            clk_baud => clk_baud

        );

    ReceiverEnt : ENTITY reciver
        PORT
        MAP
        (

        );

    TransmitterEnt : ENTITY transmitter
        PORT
        MAP
        (

        );

END ARCHITECTURE rtl;