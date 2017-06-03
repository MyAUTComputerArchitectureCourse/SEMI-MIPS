--------------------------------------------------------------------------------
-- Author:		Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:   	07-04-2017
-- Package Name:	alu/components
-- Module Name:   	SHIFT_R_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity SHIFT_R_COMPONENT is
	port(
		INPUT		: in  std_logic_vector(16 - 1 downto 0);
		OUTPUT		: out std_logic_vector(16 - 1 downto 0)
	    );
end entity;

architecture SHIFT_R_COMPONENT_ARCH of SHIFT_R_COMPONENT is
begin
	SIGNAL_GEN:
	for I in 1 to 16 - 1 generate
		OUTPUT(I - 1) <= INPUT(I);
	end generate;
	
	OUTPUT(16 - 1) <= '0'; 
end architecture;
