--------------------------------------------------------------------------------
-- Author:		Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:   	07-04-2017
-- Package Name:	register
-- Module Name:   	REGISTER_FILE
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity CLOCK_TB is
end CLOCK_TB;

architecture CLOCK_TB_ARCH of CLOCK_TB is
	
	signal CLK_COUNTER	: integer := 0;
	signal CLK_COUNT	: integer := 20;
	signal CLK : std_logic := '1';
	
	
	component REGISTER_FILE is
		generic(
			REGESTER_SIZE 	: integer := 16;											-- Size of each register in the register file
			ADDRESS_SIZE 	: integer := 6												-- Size of the address that can lead to the number of registers
			);
		
		port(
			IDATA		: in std_logic_vector(REGESTER_SIZE - 1 downto 0);						--	STD logic vector for input data
			CLK			: in std_logic;															--	Clock input
			WP_IN		: in std_logic_vector(ADDRESS_SIZE - 1 downto 0);						--	Select signal for addressing to registers
			RF_L_WRITE	: in std_logic;															--	Write enable signal for low significant bit
			RF_H_WRITE	: in std_logic;															--	Write enable signal for high significant bit
			SELECTOR	: in std_logic_vector(3 downto 0);
			LEFT_OUT	: out std_logic_vector(REGESTER_SIZE - 1 downto 0);						--	Output number 1
			RIGHT_OUT	: out std_logic_vector(REGESTER_SIZE - 1 downto 0)						--	Output number 2
			);
	end component;

	
	signal INPUT		: 	std_logic_vector(15 downto 0);
	signal L_OUTPUT		: 	std_logic_vector(15 downto 0);
	signal R_OUTPUT		: 	std_logic_vector(15 downto 0);
	signal LW			:	std_logic;
	signal HW			:	std_logic;
	signal SELECTOR		: 	std_logic_vector(3 downto 0);
	signal WP			: 	std_logic_vector(5 downto 0);
	
begin
	REG : REGISTER_FILE
		generic map(16, 6)
		port map(INPUT, CLK, WP, LW, HW, SELECTOR, L_OUTPUT, R_OUTPUT);
		
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
		INPUT	<=	"0000000000000000";
		WP		<=	"000000";
		LW		<=	'0';
		HW		<=	'0';
		wait for 90 ns;
		
		INPUT	<=	"0000001100110000";
		WP		<=	"000000";
		LW		<=	'1';
		HW		<=	'1';
		
		wait for 90 ns;
		
		INPUT	<=	"0000000000000000";
		WP		<=	"000000";
		LW		<=	'0';
		HW		<=	'0';
		
		wait for 40 ns;
		
		INPUT	<=	"0000000000000000";
		WP		<=	"000000";
		LW		<=	'0';
		HW		<=	'0';
		SELECTOR<=	"0000";
		
		wait for 200 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end CLOCK_TB_ARCH;
