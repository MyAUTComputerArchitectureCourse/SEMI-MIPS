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
	GATE_GEN:
	for I in OUTPUT'range generate
		OUTPUT(I) <= not INPUT(I);
	end generate;
end architecture;
