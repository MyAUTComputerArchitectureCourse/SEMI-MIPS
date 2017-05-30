library IEEE;

use IEEE.std_logic_1164.all;

entity TB is
end TB;

architecture TB_ARCH of TB is
	component ADDRESS_UNIT is
		PORT (
        Rside : IN std_logic_vector (15 DOWNTO 0);
        Iside : IN std_logic_vector (7 DOWNTO 0);
        Address : OUT std_logic_vector (15 DOWNTO 0);
        clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
        RplusI, Rplus0, EnablePC : IN std_logic
    );
	end component;
	
	signal rs, adr : std_logic_vector(15 downto 0);
	signal iss : std_logic_vector(7 downto 0);
	
begin


	process
	begin
		
		wait for 1 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end TB_ARCH;