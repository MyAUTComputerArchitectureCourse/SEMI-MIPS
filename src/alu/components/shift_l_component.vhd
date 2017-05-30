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
	generic(
		COMPONENT_SIZE	: integer
	       );
	port(
		INPUT		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
		OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
	    );
end entity;

architecture SHIFT_L_COMPONENT_ARCH of SHIFT_L_COMPONENT is
begin
	SIGNAL_GEN:
	for I in 1 to COMPONENT_SIZE - 1 generate
		OUTPUT(I) <= INPUT(I - 1);
	end generate;
	
	OUTPUT(0) <= '0'; 
end architecture;
