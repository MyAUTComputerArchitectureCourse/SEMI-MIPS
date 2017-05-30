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
	signal CLK : std_logic := '1';
	
	
	component FLAGS is
		port(
			CLK			:	in	std_logic;						--	Clock signal
			C_IN		:	in	std_logic;						--	Carry in
			Z_IN		:	in	std_logic;						--	Zero in
			C_SET		:	in	std_logic;						--	Carry Flag set
			C_RESET		:	in 	std_logic;						--	Carry Flag reset
			Z_SET		:	in	std_logic;						--	Zero Flag set
			Z_RESET		:	in 	std_logic;						--	Zero Flag reset
			IL_ENABLE	:	in	std_logic;						--	Imediate Load enable	
			C_OUT		:	out	std_logic;						--	Carry out
			Z_OUT		:	out	std_logic						--	Zero out
		);
	end component;
	
	signal C_IN, Z_IN, C_SET, C_RESET, Z_SET, Z_RESET, IL_ENABLE, C_OUT, Z_OUT : std_logic;
	
begin
	FLAGS_inst : component FLAGS
		port map(
			CLK       => CLK,
			C_IN      => C_IN,
			Z_IN      => Z_IN,
			C_SET     => C_SET,
			C_RESET   => C_RESET,
			Z_SET     => Z_SET,
			Z_RESET   => Z_RESET,
			IL_ENABLE => IL_ENABLE,
			C_OUT     => C_OUT,
			Z_OUT     => Z_OUT
		);
	
		
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
		C_SET		<= '0';
		Z_SET		<= '0';
		IL_ENABLE	<= '0';
		C_IN		<= '0';
		Z_IN		<= '0';
		C_RESET 	<= '1';
		Z_RESET 	<= '1';
		wait for 150 ns;
		
		C_SET		<= '0';
		Z_SET		<= '0';
		IL_ENABLE	<= '1';
		C_IN		<= '1';
		Z_IN		<= '0';
		C_RESET 	<= '0';
		Z_RESET 	<= '0';
		wait for 300 ns;
		
		C_SET		<= '0';
		Z_SET		<= '0';
		IL_ENABLE	<= '0';
		C_IN		<= '0';
		Z_IN		<= '0';
		C_RESET 	<= '1';
		Z_RESET 	<= '0';
		wait for 100 ns;
		wait for 200 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end CLOCK_TB_ARCH;
