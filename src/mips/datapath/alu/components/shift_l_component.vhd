--------------------------------------------------------------------------------
-- Author:		Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:   	06-04-2017
-- Package Name:	alu/components
-- Module Name:   	SHIFT_L_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity SHIFT_L_COMPONENT is
	port(
		INPUT		: in  std_logic_vector(16 - 1 downto 0);
		OUTPUT		: out std_logic_vector(16 - 1 downto 0)
	    );
end entity;

architecture SHIFT_L_COMPONENT_ARCH of SHIFT_L_COMPONENT is
begin
	OUTPUT(15 downto 1) <= INPUT(14 downto 0);
	OUTPUT(0) <= '0'; 
end architecture;
