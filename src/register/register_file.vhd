--------------------------------------------------------------------------------
-- Author:		Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:   	07-04-2017
-- Package Name:	register
-- Module Name:   	REGISTER_FILE
--------------------------------------------------------------------------------
 
library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

-- Caution: This module is not generic for the exclusive usage of this module in this project.
-- Be careful about the parameters in the generic part and their meaning!!!!!!!!!!!!!!!!!!!!
	
entity REGISTER_FILE is
	generic(
		REGESTER_SIZE 	: integer := 16;											-- Size of each register in the register file
		ADDRESS_SIZE 	: integer := 6												-- Size of the address that can lead to the number of registers
		);
	
	port(
		IDATA		: in std_logic_vector(REGESTER_SIZE - 1 downto 0);						--	STD logic vector for input data
		CLK			: in std_logic;															--	Clock input
		WP_IN		: in std_logic_vector(ADDRESS_SIZE - 1 downto 0);						--	Select signal for addressing to registers
		RF_L_WRITE	: in std_logic;															--	Write enable signal for low significant bit
		RF_H_WRITE	: in std_logic;															--	Write enable signal for high significant bit
		SELECTOR	: in std_logic_vector(3 downto 0);
		LEFT_OUT	: out std_logic_vector(REGESTER_SIZE - 1 downto 0);						--	Output number 1
		RIGHT_OUT	: out std_logic_vector(REGESTER_SIZE - 1 downto 0)						--	Output number 2
		);
end entity;

architecture REGISTER_FILE_ARCH of REGISTER_FILE is
	
	type REGISTER_FILE_TYPE is array (natural range <>, natural range <>) of std_logic;

	
begin	
	
	process(clk)
		constant REGISTER_NUM : integer := 2 ** ADDRESS_SIZE;
		variable REGISTER_FILE_ARR : REGISTER_FILE_TYPE(0 to REGISTER_NUM - 1,IDATA'range);
		variable address : integer;
		
	begin
		if clk'event and clk = '1' then
			address := to_integer(unsigned(WP_IN));
			if(RF_L_WRITE = '1') then
				for I in  IDATA'length / 2 - 1 downto 0 loop
					REGISTER_FILE_ARR(address + to_integer(unsigned(SELECTOR(3 downto 2))) ,I) := IDATA(I);
				end loop;
			end if;
			if(RF_H_WRITE = '1') then
				for I in IDATA'length - 1 downto IDATA'length / 2 loop
					REGISTER_FILE_ARR(address + to_integer(unsigned(SELECTOR(3 downto 2))), I) := IDATA(I - IDATA'length / 2);
				end loop;
				
			end if;

			for I in RIGHT_OUT'range loop
				RIGHT_OUT(I)	<= REGISTER_FILE_ARR(address + to_integer(unsigned(SELECTOR(1 downto 0))), I);
			end loop;
			
			for I in LEFT_OUT'range loop
				LEFT_OUT(I)		<= REGISTER_FILE_ARR(address + to_integer(unsigned(SELECTOR(3 downto 2))), I);
			end loop;
		
			end if;
	end process;
end architecture;
