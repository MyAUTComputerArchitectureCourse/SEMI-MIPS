--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         06-04-2017
-- Package Name:        alu_component
-- Module Name:         AND_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity AND_COMPONENT is
	port(
		INPUT1		: in  std_logic_vector(16 - 1 downto 0);
		INPUT2		: in  std_logic_vector(16 - 1 downto 0);
		OUTPUT		: out std_logic_vector(16 - 1 downto 0)
	    );
end entity;

architecture AND_COMPONENT_ARCH of AND_COMPONENT is
begin
	OUTPUT(0) <= INPUT1(0) and INPUT2(0);
	OUTPUT(1) <= INPUT1(1) and INPUT2(1);
	OUTPUT(2) <= INPUT1(2) and INPUT2(2);
	OUTPUT(3) <= INPUT1(3) and INPUT2(3);
	OUTPUT(4) <= INPUT1(4) and INPUT2(4);
	OUTPUT(5) <= INPUT1(5) and INPUT2(5);
	OUTPUT(6) <= INPUT1(6) and INPUT2(6);
	OUTPUT(7) <= INPUT1(7) and INPUT2(7);
	OUTPUT(8) <= INPUT1(8) and INPUT2(8);
	OUTPUT(9) <= INPUT1(9) and INPUT2(9);
	OUTPUT(10) <= INPUT1(10) and INPUT2(10);
	OUTPUT(11) <= INPUT1(11) and INPUT2(11);
	OUTPUT(12) <= INPUT1(12) and INPUT2(12);
	OUTPUT(13) <= INPUT1(13) and INPUT2(13);
	OUTPUT(14) <= INPUT1(14) and INPUT2(14);
	OUTPUT(15) <= INPUT1(15) and INPUT2(15);
end architecture;
