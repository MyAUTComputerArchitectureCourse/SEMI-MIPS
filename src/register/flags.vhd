--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         13-04-2017
-- Package Name:        register
-- Module Name:         FLAGS
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity FLAGS is
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
end entity;

architecture FLAGS_ARCH of FLAGS is
	component REGISTER_S is
		port(
			CLK		: in	std_logic;										--	Clock signal
			IDATA	: in	std_logic;										--	Input data for loading onto regiser
			LOAD	: in	std_logic;										--	Load enable signal for loading value onto register
			RESET	: in	std_logic;										--	Reset signal to make the register 0
			ODATA	: out	std_logic										--	Output of register
		);
	end component;
	
	signal ZERO_F_INPUT			: std_logic;
	signal CARRY_F_INPUT		: std_logic;
	signal ZERO_F_LOAD			: std_logic;
	signal CARRY_F_LOAD			: std_logic;
	
begin
	ZERO_FLAG : component REGISTER_S
		port map(
			CLK   => CLK,
			IDATA => ZERO_F_INPUT,
			LOAD  => ZERO_F_LOAD,
			RESET => Z_RESET,
			ODATA => Z_OUT
		);
		
	CARRY_FLAG : component REGISTER_S
		port map(
			CLK   => CLK,
			IDATA => CARRY_F_INPUT,
			LOAD  => CARRY_F_LOAD,
			RESET => C_RESET,
			ODATA => C_OUT
		);
	
	
	ZERO_F_LOAD <= (Z_SET or IL_ENABLE) and (not Z_RESET);
	CARRY_F_LOAD <= (C_SET or IL_ENABLE) and (not C_RESET);
	
	ZERO_F_INPUT <= (Z_SET or Z_IN) and ZERO_F_LOAD;
	CARRY_F_INPUT <= (C_SET or C_IN) and ZERO_F_LOAD;
	
end architecture;