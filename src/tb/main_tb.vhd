--------------------------------------------------------------------------------
-- Author:			Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:   	16-04-2017
-- Package Name:	tb
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity MAIN_TB is
end entity;

architecture MAIN_TB_ARCH of MAIN_TB is
	component PROCESSOR is
		generic(
			WORD_SIZE 	 				: integer;
			REGISTER_FILE_ADDRESS_SIZE	: integer;
			------------------------ SHADOW RELATED PARAMS -------------------------
			SHADOW_SIZE					: integer;
			SHADOW_1_H_INDEX			: integer;
			SHADOW_1_L_INDEX			: integer;
			SHADOW_2_H_INDEX			: integer;
			SHADOW_2_L_INDEX			: integer;
			----------------------- IMMEDIATE RELATED PARAMS -----------------------
			IMMEDIATE_H_INDEX			: integer;
			IMMEDIATE_L_INDEX			: integer
			);
		port(
			CLK							:	in	std_logic;
			------------------------- MEMORY SIGNALS -------------------------
			MEM_DATA_READY				:	in	std_logic;
			WRITE_MEM					:	out	std_logic;
			READ_MEM					:	out	std_logic;
			MEMORY_BUS					:	inout	std_logic_vector(WORD_SIZE - 1 downto 0);
			ADDRESS_BUS					:	out	std_logic_vector(WORD_SIZE - 1 downto 0);
			------------------------- EXTERNAL SIGNALS -------------------------
			EXTERNAL_RESET				:	in	std_logic;
			HALTED						:	out	std_logic;
			------------------------- I/O PORTS SIGNALS -------------------------
			PORTS						:	inout	std_logic_vector(63 downto 0)
	      );
	end component;
	
	component memory is
		generic (blocksize : integer := 1024);
	
		port (clk, readmem, writemem : in std_logic;
			addressbus: in std_logic_vector (15 downto 0);
			databus : inout std_logic_vector (15 downto 0);
			memdataready : out std_logic);
	end component;
	
	signal CLK_COUNTER	: integer := 0;
	signal CLK_COUNT	: integer := 70;
	signal CLK : std_logic := '1';
	
	signal MEM_DATA_READY		:	std_logic;
	signal WRITE_MEM			:	std_logic;
	signal READ_MEM				:	std_logic;
	signal MEMORY_BUS			:	std_logic_vector(15 downto 0);
	signal ADDRESS_BUS			:	std_logic_vector(15 downto 0);
	signal PORTS				:	std_logic_vector(63 downto 0);
	signal EXTERNAL_RESET		:	std_logic;
	
	signal IS_HALTED			:	std_logic;
	
begin
	PROCESSOR_INS : component PROCESSOR
		generic map(
			WORD_SIZE                  => 16,
			REGISTER_FILE_ADDRESS_SIZE => 6,
			SHADOW_SIZE                => 2,
			SHADOW_1_H_INDEX           => 11,
			SHADOW_1_L_INDEX           => 8,
			SHADOW_2_H_INDEX           => 3,
			SHADOW_2_L_INDEX           => 0,
			IMMEDIATE_H_INDEX          => 7,
			IMMEDIATE_L_INDEX          => 0
		)
		port map(
			CLK            => CLK,
			MEM_DATA_READY => MEM_DATA_READY,
			WRITE_MEM      => WRITE_MEM,
			READ_MEM       => READ_MEM,
			MEMORY_BUS     => MEMORY_BUS,
			ADDRESS_BUS    => ADDRESS_BUS,
			EXTERNAL_RESET => EXTERNAL_RESET,
			HALTED		   => IS_HALTED,
			PORTS          => PORTS
		);
	
	memory_inst : component memory
		generic map(
			blocksize => 1024
		)
		port map(
			clk          => CLK,
			readmem      => READ_MEM,
			writemem     => WRITE_MEM,
			addressbus   => ADDRESS_BUS,
			databus      => MEMORY_BUS,
			memdataready => MEM_DATA_READY
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
		EXTERNAL_RESET			<=	'1';
		wait for 250 ns;
		EXTERNAL_RESET			<=	'0';
		
		wait for 400 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end MAIN_TB_ARCH;