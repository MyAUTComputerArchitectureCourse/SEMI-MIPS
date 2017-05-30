--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         11-04-2017
-- Package Name:        alu/components
-- Module Name:         VECTOR_NORER
--------------------------------------------------------------------------------

-- This module can get a vector and nor all bits in a vector to the output

library IEEE;
use IEEE.std_logic_1164.all;

entity VECTOR_NORER is
	generic(
		COMPONENT_SIZE  : integer
		);
	port(
		INPUT		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
		OUTPUT		: out std_logic
      );
end entity;

architecture VECTOR_NORER_ARCH of VECTOR_NORER is
	signal BIT_RESULT		: std_logic_vector(COMPONENT_SIZE - 1 downto 1);
	signal NOT_OF_INPUT		: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
begin
	NOT_OF_INPUT  <= not INPUT;
	BIT_RESULT(1) <= NOT_OF_INPUT(0) and NOT_OF_INPUT(1);
	GENERATING_NORS:
	for I in 1 to INPUT'length - 2 generate
		BIT_RESULT(I + 1) <= NOT_OF_INPUT(I + 1) and BIT_RESULT(I);
	end generate;
	
	OUTPUT <= BIT_RESULT(COMPONENT_SIZE - 1);
end architecture;