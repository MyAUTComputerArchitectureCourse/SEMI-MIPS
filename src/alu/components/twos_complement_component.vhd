--------------------------------------------------------------------------------
-- Author:              SeyedMostafa Meshkati
--------------------------------------------------------------------------------
-- Create Date:         11-04-2017
-- Package Name:        alu_component
-- Module Name:         COMPARISION_COMPONENT
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity TWOS_COMPLEMENT_COMPONENT is
    generic (
        COMPONENT_SIZE  : integer
    );
    port (
        INPUT   : in std_logic_vector(COMPONENT_SIZE - 1 downto 0);
        OUTPUT  : out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
    );
end entity;

architecture TWOS_COMPLEMENT_COMPONENT_ARCH of TWOS_COMPLEMENT_COMPONENT is
    component FULL_ADDER is
		port(
			CIN			: in  std_logic;
		    A			: in  std_logic;
		    B			: in  std_logic;
		    SUM       	: out std_logic;
		    CARRY     	: out std_logic
	      );
	end component;

    signal complement_input : std_logic_vector(COMPONENT_SIZE - 1 downto 0);
    signal carries : std_logic_vector(COMPONENT_SIZE downto 0);

    begin
        complement_input <= not INPUT;
        carries(0) <= '1';
        
        CONNECTING:
        for I in 0 to COMPONENT_SIZE - 1 generate
            MODULE: FULL_ADDER
            port map(carries(I), complement_input(I), '0', OUTPUT(I), carries(I + 1));
        end generate;

end architecture;