--------------------------------------------------------------------------------
-- Author:              SeyedMostafa Meshkati
--------------------------------------------------------------------------------
-- Create Date:         13-04-2017
-- Package Name:        alu/components
-- Module Name:         MULTIPLICATION_COMPONENT
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity MULTIPLICATION_COMPONENT is
	generic(
		COMPONENT_SIZE	: integer
	);
	
	port(
		INPUT1		: in std_logic_vector(COMPONENT_SIZE/2 - 1 downto 0);
		INPUT2		: in std_logic_vector(COMPONENT_SIZE/2 - 1 downto 0);
		OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
	
	);
end entity;

architecture MULTIPLICATION_COMPONENT_ARCH of MULTIPLICATION_COMPONENT is
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
	
	type arraySignals is array (0 to COMPONENT_SIZE/2 - 1) of std_logic;
	type arr1 is array (0 to COMPONENT_SIZE/2 - 1) of std_logic_vector(COMPONENT_SIZE/2 - 1 downto 0);
	signal cables 	: arraySignals;
	signal khar, gav, ain, summ : arr1;

	
begin
	MAKING_IN:
	for W in 0 to COMPONENT_SIZE/2 - 1 generate
		ANDING:
		for J in 0 to COMPONENT_SIZE/2 - 1 generate
			gav(W)(j) <= INPUT1(J) and INPUT2(W);
		end generate;
	end generate;

	ain(0)(COMPONENT_SIZE/2 - 1) <= '0';

	KHAAR:
		for L in 0 to COMPONENT_SIZE/2 - 2 generate
			ain(0)(L) <= gav(0)(L + 1);
		end generate;
		output(0) <= gav(0)(0);
	CONNECT:
	for I in 0 to COMPONENT_SIZE/2 - 2 generate
		MODULE: ADDER_SUBTRACTOR_COMPONENT
		generic map (COMPONENT_SIZE/2)
		port map('0',gav(I + 1) ,ain(I) , '0', summ(I), cables(I));

		ain(I + 1)(COMPONENT_SIZE/2 - 1) <= cables(I);
		MAKING:
		for K in 0 to COMPONENT_SIZE/2 - 2 generate
			ain(I + 1)(K) <= summ(I)(K + 1);
		end generate;

		output(I + 1) <= summ(I)(0);
	end generate;
	
	-- AH:
	-- for Q in 0 to COMPONENT_SIZE/2 - 1 generate
	-- 	output(Q + COMPONENT_SIZE/2) <= summ(COMPONENT_SIZE/2 - 2)(Q);
	-- end generate;
	AH:
	for Q in 0 to COMPONENT_SIZE/2 - 2 generate
		output(Q + COMPONENT_SIZE/2) <= summ(COMPONENT_SIZE/2 - 2)(Q + 1);
	end generate;
	output(COMPONENT_SIZE - 1) <= cables(COMPONENT_SIZE/2 - 2);
end architecture;
