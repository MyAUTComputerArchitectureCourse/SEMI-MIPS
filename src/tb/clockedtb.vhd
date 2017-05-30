--------------------------------------------------------------------------------
-- Author:		SeyedMostafa Meshkati
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
	
	
	component memory is
		generic (blocksize : integer := 1024);
	
		port (clk, readmem, writemem : in std_logic;
			addressbus: in std_logic_vector (15 downto 0);
			databus : inout std_logic_vector (15 downto 0);
			memdataready : out std_logic);
	end component memory;
	
	signal readmem, writemem, memdataready	: std_logic;
	signal address							:	std_logic_vector(15 downto 0);
	signal data								:	std_logic_vector(15 downto 0);
begin
	memory_inst : component memory
		generic map(
			blocksize => 1024
		)
		port map(
			clk          => clk,
			readmem      => readmem,
			writemem     => writemem,
			addressbus   => address,
			databus      => data,
			memdataready => memdataready
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
		readmem	<=	'1';
		address	<=	"0000000000000000";
		wait for 120 ns;
		
		address	<=	"0000000000000010";
		wait for 220 ns;
		
		wait for 200 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end CLOCK_TB_ARCH;
