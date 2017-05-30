--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         07-04-2017
-- Package Name:        alu/components
-- Module Name:         FULL_ADDER
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity FULL_ADDER is
	port(
		CIN			: in  std_logic;
	    A			: in  std_logic;
	    B			: in  std_logic;
	    SUM       	: out std_logic;
	    CARRY     	: out std_logic
      );
end entity;

architecture FULL_ADDER_ARCH of FULL_ADDER is
begin
	SUM		<= CIN xor A xor B;
	CARRY	<= (A and B) or (A and CIN) or (B and CIN);
end architecture;