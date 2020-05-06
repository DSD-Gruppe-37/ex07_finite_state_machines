LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RegisterEnt IS
    PORT
    (
        inA, inB : IN std_logic;
        RegOut   : OUT std_logic
    );
END RegisterEnt;

ARCHITECTURE OutputRegister OF RegisterEnt IS

BEGIN

    -- flip some flop ? 
END OutputRegister; -- OutputRegister