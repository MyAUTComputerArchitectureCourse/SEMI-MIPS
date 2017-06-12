--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         06-04-2017
-- Package Name:        alu_component
-- Module Name:         NOT_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity NOT_COMPONENT is
	port(
		INPUT		: in  std_logic_vector(16 - 1 downto 0);
		OUTPUT		: out std_logic_vector(16 - 1 downto 0)
	    );
end entity;

architecture NOT_COMPONENT_ARCH of NOT_COMPONENT is
begin
	OUTPUT(0) <= not INPUT(0);
	OUTPUT(1) <= not INPUT(1);
	OUTPUT(2) <= not INPUT(2);
	OUTPUT(3) <= not INPUT(3);
	OUTPUT(4) <= not INPUT(4);
	OUTPUT(5) <= not INPUT(5);
	OUTPUT(6) <= not INPUT(6);
	OUTPUT(7) <= not INPUT(7);
	OUTPUT(8) <= not INPUT(8);
	OUTPUT(9) <= not INPUT(9);
	OUTPUT(10) <= not INPUT(10);
	OUTPUT(11) <= not INPUT(11);
	OUTPUT(12) <= not INPUT(12);
	OUTPUT(13) <= not INPUT(13);
	OUTPUT(14) <= not INPUT(14);
	OUTPUT(15) <= not INPUT(15);
end architecture;
