LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RegisterEnt IS
    PORT
    (
        inData   : IN std_logic_vector(7 DOWNTO 0);
        inValid  : IN std_logic;
        RegOut   : OUT std_logic_vector(7 DOWNTO 0)
    );
END RegisterEnt;

ARCHITECTURE OutputRegister OF RegisterEnt IS

BEGIN
    RegisterHold : PROCESS (inValid)
    BEGIN
            IF inValid = '1' THEN
                RegOut <= inData;
            -- ELSE
            --     RegOut <= (OTHERS => '0');
            END IF;
    END PROCESS;        -- RegisterHold
END OutputRegister; -- OutputRegister