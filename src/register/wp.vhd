--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         14-04-2017
-- Package Name:        register
-- Module Name:         WINDOW_POINTER
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity WINDOW_POINTER is
	generic(
		POINTER_SIZE  		:	integer
		);
	port(
		CLK					:	in	std_logic;
		WP_ADD				:	in	std_logic_vector(POINTER_SIZE - 1 downto 0);
		WP_ADD_ENABLE		:	in	std_logic;
		WP_RESET			:	in	std_logic;
		WP_OUT				:	out	std_logic_vector(POINTER_SIZE - 1 downto 0)
      );
end entity;

architecture WINDOW_POINTER_ARCH of WINDOW_POINTER is
	component ADDER_SUBTRACTOR_COMPONENT is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
			SUM			: out std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			CARRY		: out std_logic
	      );
	end component;
	
	component REGISTER_R is
		generic(
			REG_SIZE : integer := 2											-- Size of the register
		);
		port(
			IDATA	: in	std_logic_vector(REG_SIZE - 1 downto 0);		--	Input data for loading onto regiser
			CLK		: in	std_logic;										--	Clock signal
			LOAD	: in	std_logic;										--	Load enable signal for loading value onto register
			RESET	: in	std_logic;										--	Reset signal to make the register 0
			ODATA	: out	std_logic_vector(REG_SIZE - 1 downto 0)			--	Output of register
		);
	end component;
	
	component VECTOR_NORER is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			INPUT		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic
	      );
	end component;
	
	
	signal		REG_OUT				:	std_logic_vector(POINTER_SIZE - 1 downto 0);
	signal		TEMP				:	std_logic_vector(POINTER_SIZE - 1 downto 0);
	signal		REG_IN				:	std_logic_vector(POINTER_SIZE - 1 downto 0);
	signal		REG_CARRY			:	std_logic;
	
begin
	
--	DEFAULT_VALUE : for I in REG_OUT'range generate
--		REG_OUT(I)	<= '0';
--		REG_IN(I)	<= '0';
--	end generate DEFAULT_VALUE;
	
	
	WP_ADDER : component ADDER_SUBTRACTOR_COMPONENT
		generic map(
			COMPONENT_SIZE => POINTER_SIZE
		)
		port map(
			CARRY_IN => '0',
			INPUT1   => WP_ADD,
			INPUT2   => REG_OUT,
			IS_SUB   => '0',
			SUM      => REG_IN,
			CARRY    => REG_CARRY
		);
		
	WP_REGISTER : component REGISTER_R
		generic map(
			REG_SIZE => POINTER_SIZE
		)
		port map(
			IDATA => REG_IN,
			CLK   => CLK,
			LOAD  => WP_ADD_ENABLE,
			RESET => WP_RESET,
			ODATA => REG_OUT
		);
		
	WP_OUT	<= REG_OUT;
end architecture;