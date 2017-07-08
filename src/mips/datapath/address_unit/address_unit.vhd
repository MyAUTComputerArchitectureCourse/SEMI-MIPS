
library IEEE;

use IEEE.std_logic_1164.all;

ENTITY ADDRESS_UNIT IS
    PORT (
        Iside : IN std_logic_vector (7 DOWNTO 0);
        Address : OUT std_logic_vector (7 DOWNTO 0);
        clk, ResetPC, Im, PCplus1 : IN std_logic;
        EnablePC : IN std_logic
    );
END ADDRESS_UNIT;
ARCHITECTURE ADDRESS_UNIT_ARCH OF ADDRESS_UNIT IS
	COMPONENT PROGRAM_COUNTER is
		PORT (
	        EnablePC : IN std_logic;
	        input: IN std_logic_vector (7 DOWNTO 0);
	        clk : IN std_logic;
	        output: OUT std_logic_vector (7 DOWNTO 0)
	    );
    END COMPONENT;
    COMPONENT ADDRESS_LOGIC is
    	PORT (
        PCside: IN std_logic_vector (7 DOWNTO 0);
        Iside : IN std_logic_vector (7 DOWNTO 0);
        ALout : OUT std_logic_vector (7 DOWNTO 0);
        ResetPC, Im, PCplus1 : IN std_logic
    );
    END COMPONENT;
    SIGNAL pcout : std_logic_vector (7 DOWNTO 0);
    SIGNAL AddressSignal : std_logic_vector (7 DOWNTO 0);
BEGIN
    Address <= AddressSignal;
    l1 : PROGRAM_COUNTER PORT MAP (EnablePC, AddressSignal, clk, pcout);
    l2 : ADDRESS_LOGIC PORT MAP
        (pcout, Iside, AddressSignal,
        ResetPC, Im, PCplus1);
END ADDRESS_UNIT_ARCH;