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
	port(
		INPUT1		: in  std_logic_vector(16 - 1 downto 0);
		INPUT2		: in  std_logic_vector(16 - 1 downto 0);
		OUTPUT		: out std_logic_vector(16 - 1 downto 0)
	    );
end entity;

architecture OR_COMPONENT_ARCH of OR_COMPONENT is

begin
	OUTPUT(0) <= INPUT1(0) or INPUT2(0);
	OUTPUT(1) <= INPUT1(1) or INPUT2(1);
	OUTPUT(2) <= INPUT1(2) or INPUT2(2);
	OUTPUT(3) <= INPUT1(3) or INPUT2(3);
	OUTPUT(4) <= INPUT1(4) or INPUT2(4);
	OUTPUT(5) <= INPUT1(5) or INPUT2(5);
	OUTPUT(6) <= INPUT1(6) or INPUT2(6);
	OUTPUT(7) <= INPUT1(7) or INPUT2(7);
	OUTPUT(8) <= INPUT1(8) or INPUT2(8);
	OUTPUT(9) <= INPUT1(9) or INPUT2(9);
	OUTPUT(10) <= INPUT1(10) or INPUT2(10);
	OUTPUT(11) <= INPUT1(11) or INPUT2(11);
	OUTPUT(12) <= INPUT1(12) or INPUT2(12);
	OUTPUT(13) <= INPUT1(13) or INPUT2(13);
	OUTPUT(14) <= INPUT1(14) or INPUT2(14);
	OUTPUT(15) <= INPUT1(15) or INPUT2(15);
end architecture;
