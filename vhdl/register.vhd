LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY REGISTER IS
    PORT
    (
        inA, inB : IN std_logic;
        RegOut   : OUT std_logic
    );
END REGISTER;