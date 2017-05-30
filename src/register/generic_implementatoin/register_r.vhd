--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         07-04-2017
-- Package Name:        register/generic_implementation
-- Module Name:         REGISTER_R
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity REGISTER_R is
	generic(
		REG_SIZE : integer := 2											-- Size of the register
	);
	port(
		IDATA	: in	std_logic_vector(REG_SIZE - 1 downto 0);		--	Input data for loading onto regiser
		CLK		: in	std_logic;										--	Clock signal
		LOAD	: in	std_logic;										--	Load enable signal for loading value onto register
		RESET	: in	std_logic;										--	Reset signal to make the register 0
		ODATA	: out	std_logic_vector(REG_SIZE - 1 downto 0)			--	Output of register
	);
end entity;

architecture REGISTER_R_ARCH of REGISTER_R is
	
begin
	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if LOAD = '1' then
				for i in IDATA'range loop
					ODATA(i) <= IDATA(i);
				end loop;
			end if;
			if RESET = '1' then
				for i in IDATA'range loop
					ODATA(i) <= '0';
				end loop;
			end if;
		end if;
	end process;
end architecture;