--------------------------------------------------------------------------------
-- Author:              SeyedMostafa Meshkati
--------------------------------------------------------------------------------
-- Create Date:         08-04-2017
-- Package Name:        alu/components
-- Module Name:         COMPARISION_COMPONENT
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity COMPARISON_COMPONENT is
    generic(
        COMPONENT_SIZE  : integer
    );

    port(
        INPUT1      : in std_logic_vector(COMPONENT_SIZE - 1 downto 0);
        INPUT2      : in std_logic_vector(COMPONENT_SIZE - 1 downto 0);
        Z_FLAG      : out std_logic;
        CARRY_FLAG  : out std_logic
    );
end entity;

architecture COMPARISON_COMPONENT_ARCH of COMPARISON_COMPONENT is
    component BIT_COMPARATOR is
        port(
            INPUT1   : in std_logic;
            INPUT2   : in std_logic;
            E_IN     : in std_logic;
            L_IN     : in std_logic;
            G_IN     : in std_logic;
            EQUAL    : out std_logic;
            GREATER  : out std_logic;
            LOWER    : out std_logic
        );
    end component;

    signal equals, lowers, greaters: std_logic_vector(COMPONENT_SIZE downto 0);
begin

    equals(0) <= '1';
    lowers(0) <= '0';
    greaters(0) <= '0';

    CONNECTING:
    for I in 0 to COMPONENT_SIZE - 1 generate
        MODULE: BIT_COMPARATOR
        port map(INPUT1(COMPONENT_SIZE - 1 - I), INPUT2(COMPONENT_SIZE - 1 - I), equals(I), lowers(I), greaters(I), equals(I + 1), greaters(I + 1), lowers(I + 1));
        
    end generate;

    Z_FLAG <= equals(COMPONENT_SIZE);
    CARRY_FLAG <= lowers(COMPONENT_SIZE);

end architecture;