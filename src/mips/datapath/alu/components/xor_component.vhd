--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         06-04-2017
-- Package Name:        alu_component
-- Module Name:         XOR_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity XOR_COMPONENT is
	port(
		INPUT1		: in  std_logic_vector(15 downto 0);
		INPUT2		: in  std_logic_vector(15 downto 0);
		OUTPUT		: out std_logic_vector(15 downto 0)
	    );
end entity;

architecture XOR_COMPONENT_ARCH of XOR_COMPONENT is

begin
	OUTPUT(0) <= INPUT1(0) xor INPUT2(0);
	OUTPUT(1) <= INPUT1(1) xor INPUT2(1);
	OUTPUT(2) <= INPUT1(2) xor INPUT2(2);
	OUTPUT(3) <= INPUT1(3) xor INPUT2(3);
	OUTPUT(4) <= INPUT1(4) xor INPUT2(4);
	OUTPUT(5) <= INPUT1(5) xor INPUT2(5);
	OUTPUT(6) <= INPUT1(6) xor INPUT2(6);
	OUTPUT(7) <= INPUT1(7) xor INPUT2(7);
	OUTPUT(8) <= INPUT1(8) xor INPUT2(8);
	OUTPUT(9) <= INPUT1(9) xor INPUT2(9);
	OUTPUT(10) <= INPUT1(10) xor INPUT2(10);
	OUTPUT(11) <= INPUT1(11) xor INPUT2(11);
	OUTPUT(12) <= INPUT1(12) xor INPUT2(12);
	OUTPUT(13) <= INPUT1(13) xor INPUT2(13);
	OUTPUT(14) <= INPUT1(14) xor INPUT2(14);
	OUTPUT(15) <= INPUT1(15) xor INPUT2(15);
	
end architecture;