--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         09-04-2017
-- Package Name:        alu/components
-- Module Name:         ADDER_SUBTRACTOR_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ADDER_SUBTRACTOR_COMPONENT is
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
end entity;

architecture ADDER_SUBTRACTOR_COMPONENT_ARCH of ADDER_SUBTRACTOR_COMPONENT is
	component FULL_ADDER is
		port(
			CIN			: in  std_logic;
		    A			: in  std_logic;
		    B			: in  std_logic;
		    SUM       	: out std_logic;
		    CARRY     	: out std_logic
	      );
	end component;

	signal CARRIES		: std_logic_vector(COMPONENT_SIZE downto 0);
	signal B_MUXED		: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
begin
	CARRIES(0)	<= IS_SUB xor CARRY_IN;
	
	GENERATING_B:
	for I in INPUT2'range generate
		with IS_SUB select B_MUXED(I) <=
		INPUT2(I) when '0',
		not INPUT2(I) when '1',
		INPUT2(I) when others;
	end generate;
	
	
	
	
	ADDERS_CONNECTING:
	for I in INPUT1'range generate
		ADDER_X: FULL_ADDER
			port map(
				CIN   => CARRIES(I),
				A     => INPUT1(I),
				B     => B_MUXED(I),
				SUM   => SUM(I),
				CARRY => CARRIES(I + 1)
			);
	end generate;
	CARRY		<= CARRIES(COMPONENT_SIZE - 1) xor CARRIES(COMPONENT_SIZE);	
end architecture;