--------------------------------------------------------------------------------
-- Author:		Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:   	06-04-2017
-- Package Name:	alu_component
-- Module Name:   	OR_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity OR_COMPONENT is
	generic(
		COMPONENT_SIZE	: integer
	       );
	port(
		INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
		INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
		OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
	    );
end entity;

architecture OR_COMPONENT_ARCH of OR_COMPONENT is

begin
	GATE_GEN:
	for I in OUTPUT'range generate
	begin
		OUTPUT(I) <= INPUT1(I) or INPUT2(I);
	end generate;
end architecture;
