--------------------------------------------------------------------------------
-- Author:		SeyedMostafa Meshkati
--------------------------------------------------------------------------------
-- Create Date:   	13-04-2017
-- Package Name:	address_unit_testbench
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity CLOCK_TB is
end CLOCK_TB;

architecture CLOCK_TB_ARCH of CLOCK_TB is
	
	signal CLK_COUNTER	: integer := 0;
	signal CLK_COUNT	: integer := 50;
	signal CLK : std_logic := '0';
	
	
	component ADDRESS_UNIT is
		PORT (
        Rside : IN std_logic_vector (15 DOWNTO 0);
        Iside : IN std_logic_vector (7 DOWNTO 0);
        Address : OUT std_logic_vector (15 DOWNTO 0);
        clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
        RplusI, Rplus0, EnablePC : IN std_logic
    );
	end component;

	
	signal rs		: 	std_logic_vector(15 downto 0);
	signal iss		: 	std_logic_vector(7 downto 0);
	signal adr		: 	std_logic_vector(15 downto 0);
	signal resPC, pcI, pc1, rpi, rp0, epc:	std_logic := '0';
	
begin
	REG : ADDRESS_UNIT
		port map(rs, iss, adr, CLK, resPC, pcI, pc1, rpi, rp0, epc);
		
	CLOCK_GEN : process is
	begin
		loop
			CLK <= not CLK;
			wait for 100 ns;
			CLK <= not CLK;
			wait for 100 ns;
			
			CLK_COUNTER <= CLK_COUNTER + 1;
			
			if(CLK_COUNTER = CLK_COUNT) then
				assert false report "Reached end of the clock generation";
				wait;
			end if;
			
		end loop;
		
	end process CLOCK_GEN;
	
	TEST_BENCH:process
	begin
		resPC <= '1';
		wait for 200 ns;
		resPC <= '0';
		iss <= "00010111";
		pcI <= '1';
		epc <= '1';
		wait for 200 ns; 
		wait for 200 ns;	-- wait for clock
		epc <= '0';
		pcI <= '0';
		pc1 <= '1';
		wait for 200 ns;
		epc <= '1';
		wait for 200 ns;
		wait for 200 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end CLOCK_TB_ARCH;
