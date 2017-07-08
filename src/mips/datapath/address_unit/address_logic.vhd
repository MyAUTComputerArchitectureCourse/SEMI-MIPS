
library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ADDRESS_LOGIC IS
    PORT (
        PCside: IN std_logic_vector (7 DOWNTO 0);
        Iside : IN std_logic_vector (7 DOWNTO 0);
        ALout : OUT std_logic_vector (7 DOWNTO 0);
        ResetPC, Im, PCplus1 : IN std_logic
    );
END ADDRESS_LOGIC;
ARCHITECTURE ADDRESS_LOGIC_ARCH of ADDRESS_LOGIC IS

BEGIN
    PROCESS (PCside, Iside, ResetPC,
            Im, PCplus1)
        VARIABLE temp : std_logic_vector (2 DOWNTO 0);
BEGIN
        temp := (ResetPC & Im & PCplus1);
        CASE temp IS
            WHEN "100" => ALout <= (OTHERS => '0');
            WHEN "010" => ALout <= Iside;
            WHEN "001" => ALout <= std_logic_vector(unsigned(PCside) + 1);
            WHEN OTHERS => ALout <= PCside;
        END CASE;
    END PROCESS;
END ADDRESS_LOGIC_ARCH;