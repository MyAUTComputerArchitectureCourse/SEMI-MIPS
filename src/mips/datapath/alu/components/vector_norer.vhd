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
	port(
		INPUT		: in  std_logic_vector(15 downto 0);
		OUTPUT		: out std_logic
      );
end entity;

architecture VECTOR_NORER_ARCH of VECTOR_NORER is
	signal BIT_RESULT		: std_logic_vector(15 downto 1);
	signal NOT_OF_INPUT		: std_logic_vector(15 downto 0);
begin
	NOT_OF_INPUT  <= not INPUT;
	BIT_RESULT(1) <= NOT_OF_INPUT(0) and NOT_OF_INPUT(1);
	
	BIT_RESULT(2) <= NOT_OF_INPUT(2) and BIT_RESULT(1);
	BIT_RESULT(3) <= NOT_OF_INPUT(3) and BIT_RESULT(2);
	BIT_RESULT(4) <= NOT_OF_INPUT(4) and BIT_RESULT(3);
	BIT_RESULT(5) <= NOT_OF_INPUT(5) and BIT_RESULT(4);
	BIT_RESULT(6) <= NOT_OF_INPUT(6) and BIT_RESULT(5);
	BIT_RESULT(7) <= NOT_OF_INPUT(7) and BIT_RESULT(6);
	BIT_RESULT(8) <= NOT_OF_INPUT(8) and BIT_RESULT(7);
	BIT_RESULT(9) <= NOT_OF_INPUT(9) and BIT_RESULT(8);
	BIT_RESULT(10) <= NOT_OF_INPUT(10) and BIT_RESULT(9);
	BIT_RESULT(11) <= NOT_OF_INPUT(11) and BIT_RESULT(10);
	BIT_RESULT(12) <= NOT_OF_INPUT(12) and BIT_RESULT(11);
	BIT_RESULT(13) <= NOT_OF_INPUT(13) and BIT_RESULT(12);
	BIT_RESULT(14) <= NOT_OF_INPUT(14) and BIT_RESULT(13);
	BIT_RESULT(15) <= NOT_OF_INPUT(15) and BIT_RESULT(14);
	
	OUTPUT <= BIT_RESULT(15);
end architecture;