--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         09-04-2017
-- Package Name:        util
-- Module Name:         TRI_STATE
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity TRI_STATE is
	generic(
		COMPONENT_SIZE  : integer
		);
	port(
		DATA_IN			:  in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
		STATE			:  in  std_logic;
		DATA_OUT		:  out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
      );
end entity;

architecture TRI_STATE_ARCH of TRI_STATE is
	signal Z_OUT		: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
begin
	GENERATE_Z_OUT : for I in Z_OUT'range generate
		Z_OUT(I) <= 'Z';
	end generate GENERATE_Z_OUT;
	
	CHANGE_VALUES : process (DATA_IN, STATE)
	begin
		if(STATE = '1') then
			DATA_OUT <= DATA_IN;
		else
			DATA_OUT <= Z_OUT;
		end if;
			
	end process CHANGE_VALUES;
	
end architecture;