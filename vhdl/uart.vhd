LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE work.ALL;

ENTITY uart IS
    PORT
    (
        -- inputs
        clk, reset, rxd, txvalid : IN std_logic;
        txdata                   : IN std_logic_vector(7 DOWNTO 0);
        -- outputs
        txd, rxvalid             : OUT std_logic;
        rxdata                   : OUT std_logic_vector(7 DOWNTO 0)
        -- test                     : OUT std_logic_vector(7 DOWNTO 0)
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

    ReceiverEnt : ENTITY receiver
        PORT
        MAP
        (
        --inputs
        rxd      => rxd,
        reset    => reset,
        clk_baud => clk_baud,
        --outputs
        -- test     => test(7 DOWNTO 0),
        rxdata   => rxdata,
        rxvalid  => rxvalid
        );

    TransmitterEnt : ENTITY transmitter
        PORT
        MAP
        (
        --inputs
        reset    => reset,
        txdata   => txdata,
        txvalid  => txvalid,
        clk_baud => clk_baud,
        -- outputs
        -- test     => test(7 DOWNTO 0),
        txd      => txd
        );

END ARCHITECTURE rtl;