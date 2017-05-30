--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         13-04-2017
-- Package Name:        register/generic_implementation
-- Module Name:         REGISTER_S
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity REGISTER_S is
	port(
		CLK		: in	std_logic;										--	Clock signal
		IDATA	: in	std_logic;										--	Input data for loading onto regiser
		LOAD	: in	std_logic;										--	Load enable signal for loading value onto register
		RESET	: in	std_logic;										--	Reset signal to make the register 0
		ODATA	: out	std_logic										--	Output of register
	);
end entity;

architecture REGISTER_S_ARCH of REGISTER_S is
	
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if LOAD = '1' then
				ODATA <= IDATA;
			end if;
			if RESET = '1' then
				ODATA <= '0';
			end if;
		end if;
	end process;
end architecture;