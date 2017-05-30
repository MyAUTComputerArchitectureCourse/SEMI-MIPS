uthor:		SeyedMostafa Meshkati
--------------------------------------------------------------------------------
-- Create Date:   	13-04-2017
-- Package Name:	address_unit_testbench
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity CLOCK_TB is
	end CLOCK_TB;

architecture CLOCK_TB_ARCH of CLOCK_TB is
		
		signal CLK_COUNTER	: integer := 0;
			signal CLK_COUNT	: integer := 50;
				signal CLK : std_logic := '1';
					
					
					component WINDOW_POINTER is
								generic(
											POINTER_SIZE  		:	integer
														);
																port(
																			CLK					:	in	std_logic;
																			WP_ADD				:	in	std_logic_vector(POINTER_SIZE - 1 downto 0);
																			WP_RESET			:	in	std_logic;
																			WP_OUT				:	out	std_logic_vector(POINTER_SIZE - 1 downto 0)
																				      );
																				      	end component;
																						
																						signal wp_add, wp_out		: std_logic_vector(5 downto 0);
																							signal wp_r					: std_logic;
																								
begin
		WINDOW_POINTER_inst : component WINDOW_POINTER
				generic map(
							POINTER_SIZE => 6
									)
											port map(
														CLK      => CLK,
																	WP_ADD   => wp_add,
																				WP_RESET => wp_r,
																							WP_OUT   => wp_out
																									);
																											
																											
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
																																																																		
																																																																		TEST_BENCH:process
																																																																				begin
																																																																							wp_r	<= '1';
																																																																									wp_add	<= "000000";
																																																																											wait for 120 ns;
																																																																													
																																																																													wp_r	<= '0';
																																																																															wp_add	<= "000100";
																																																																																	wait for 90 ns;
																																																																																			
																																																																																			wp_r	<= '0';
																																																																																					wp_add	<= "000110";
																																																																																							
																																																																																							
																																																																																							wait for 200 ns;
																																																																																									assert false report "Reached end of test";
																																																																																											wait;
																																																																																												end process;
																																																																																											end CLOCK_TB_ARCH;

