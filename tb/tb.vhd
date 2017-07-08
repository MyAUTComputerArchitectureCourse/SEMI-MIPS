library IEEE;
use IEEE.std_logic_1164.all;

entity TB is
end entity;

architecture TB_ARCH of TB is
	component SEMI_MIPS_MODULE is
		port(
			CLK : std_logic;
			EXTERNAL_RESET : std_logic
		);
	end component;	
	
	signal CLK_COUNTER	: integer := 0;
	signal CLK_COUNT	: integer := 50;
	signal CLK : std_logic := '1';
	signal EXTERNAL_RESET : std_logic;
	
begin
	CLOCK_GEN : process is
	begin
		loop
			CLK <= not CLK;
			wait for 100 ns;
			CLK <= not CLK;
			wait for 100 ns;
			
			CLK_COUNTER <= CLK_COUNTER + 1;
			
			if(CLK_COUNTER = CLK_COUNT) then
				assert false report "Reached end of the clock generation";
				wait;
			end if;
			
		end loop;
		
	end process CLOCK_GEN;
	
	SEMI_MIPS_MODULE_inst : component SEMI_MIPS_MODULE
		port map(
			CLK            => CLK,
			EXTERNAL_RESET => EXTERNAL_RESET
		);
		
	
	EXTERNAL_RESET <= '1', '0' after 200 ns;
end architecture;