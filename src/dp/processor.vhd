--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         13-04-2017
-- Package Name:        dp
-- Module Name:         PROCESSOR
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity PROCESSOR is
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
end entity;

architecture PROCESSOR_ARCH of PROCESSOR is
	component TRI_STATE is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			DATA_IN			:  in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			STATE			:  in  std_logic;
			DATA_OUT		:  out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
	      );
	end component;
	
	component FLAGS is
		port(
			CLK			:	in	std_logic;						--	Clock signal
			C_IN		:	in	std_logic;						--	Carry in
			Z_IN		:	in	std_logic;						--	Zero in
			C_SET		:	in	std_logic;						--	Carry Flag set
			C_RESET		:	in 	std_logic;						--	Carry Flag reset
			Z_SET		:	in	std_logic;						--	Zero Flag set
			Z_RESET		:	in 	std_logic;						--	Zero Flag reset
			IL_ENABLE	:	in	std_logic;						--	Imediate Load enable	
			C_OUT		:	out	std_logic;						--	Carry out
			Z_OUT		:	out	std_logic						--	Zero out
		);
	end component;
	
	component WINDOW_POINTER is
		generic(
			POINTER_SIZE  		:	integer
			);
		port(
			CLK					:	in	std_logic;
			WP_ADD				:	in	std_logic_vector(POINTER_SIZE - 1 downto 0);
			WP_ADD_ENABLE		:	in	std_logic;
			WP_RESET			:	in	std_logic;
			WP_OUT				:	out	std_logic_vector(POINTER_SIZE - 1 downto 0)
	      );
	end component;

	component REGISTER_R is
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
	end component;
	
	component ADDRESS_UNIT IS
	    port (
	        Rside : IN std_logic_vector (15 DOWNTO 0);
	        Iside : IN std_logic_vector (7 DOWNTO 0);
	        Address : OUT std_logic_vector (15 DOWNTO 0);
	        clk, ResetPC, PCplusI, PCplus1 : IN std_logic;
	        RplusI, Rplus0, EnablePC : IN std_logic
	    );
	end component;
	
	component ALU is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OPERATION	: in  std_logic_vector(3 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			CARRY_OUT	: out std_logic;
			ZERO_OUT	: out std_logic
	      );
	end component;
	
	component REGISTER_FILE is
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
	end component;
	
	component CONTROL_UNIT is
		generic(
			WORD_SIZE       : integer; -- This indicates the operations' size
			WP_ADDRESS_SIZE : integer
		);
		port(
			-- ----------- SIGNALS FROM OUT OF PROCESSOR --------------
			CLK                      : in  std_logic;
			EXTERNAL_RESET           : in  std_logic;
			HALTED					 : out std_logic;
			-- --------------- MEMORY RELATED SIGNALS -----------------
			MEM_DATA_READY           : in  std_logic;
			WRITE_MEM                : out std_logic;
			READ_MEM                 : out std_logic;
			------------------- FLAGS RELATED SIGNALS -----------------
			Z_IN                     : in  std_logic;
			C_IN                     : in  std_logic;
			C_OUT                    : out std_logic;
			Z_OUT                    : out std_logic;
			C_SET                    : out std_logic;
			C_RESET                  : out std_logic;
			Z_SET                    : out std_logic;
			Z_RESET                  : out std_logic;
			IL_ENABLE                : out std_logic;
			-- ------------------ AL RELATED SIGNALS ------------------
			RESET_PC                 : out std_logic;
			PC_PLUS_I                : out std_logic;
			PC_PLUS_1                : out std_logic;
			R_PLUS_I                 : out std_logic;
			R_PLUS_0                 : out std_logic;
			ENABLE_PC                : out std_logic;
			-- ------------------ ALU RELATED SIGNALS ------------------
			ALU_OPERATION			 : out std_logic_vector(3 downto 0);
			-- ------------------ WP RELATED SIGNALS ------------------
			WP_ADD_ENABLE			 : out std_logic;
			WP_RESET                 : out std_logic;
			---------------- REGISTER FILE RELATED SIGNALS ------------
			RF_L_WRITE				 : out std_logic;
			RF_H_WRITE				 : out std_logic;
			-- ---------------------- SHADOW --------------------------
			SHADOW                   : out std_logic;
			-- ------------------ IR RELATED SIGNALS ------------------
			IR_INPUT                 : in  std_logic_vector(WORD_SIZE - 1 downto 0);
			IR_LOAD                  : out std_logic;
			-- --------------- DATABUS CONTROL SIGNALS ----------------
			ALU_ON_DATA_BUS			 : out std_logic;
			ADDRESS_ON_BUS           : out std_logic;
			RS_ON_ADDRESS_UNIT_RSIDE : out std_logic;
			RD_ON_ADDRESS_UNIT_RSIDE : out std_logic
		);
	end component;
	
	-------------------------- FLAGS SIGNALS -----------------------------------
	signal C_IN							:	std_logic;
	signal Z_IN							:	std_logic;
	signal C_OUT						:	std_logic;
	signal Z_OUT						:	std_logic;
	signal FLAGS_IL_ENABLE				:	std_logic;
	signal C_SET						:	std_logic;
	signal Z_SET						:	std_logic;
	signal C_RESET						:	std_logic;
	signal Z_RESET						:	std_logic;
	----------------------- ADDRESS UNIT RELATED SIGNALS -----------------------
	signal RESET_PC						:	std_logic;
	signal PC_PLUS_I					:	std_logic;
	signal PC_PLUS_1					:	std_logic;
	signal R_PLUS_I						:	std_logic;
	signal R_PLUS_0						:	std_logic;
	signal ENABLE_PC					:	std_logic;
	signal ADDRESS_UNIT_OUT				:	std_logic_vector(WORD_SIZE - 1 downto 0);
	
	------------------------ CONTROL SIGNALS -----------------------------------
	signal ALU_ON_DATA_BUS				:	std_logic;
	signal ADDRESS_ON_DATA_BUS			:	std_logic;
	signal RS_ON_ADDRESS_UNIT_RSIDE		:	std_logic;
	signal RD_ON_ADDRESS_UNIT_RSIDE		:	std_logic;
	-------------------------- ALU SIGNALS -----------------------------------
	signal ALU_OPERATION				:	std_logic_vector(3 downto 0);
	signal ALU_OUT						:	std_logic_vector(WORD_SIZE - 1 downto 0);
	------------------------ SHADOW SIGNALS -----------------------------------
	signal SHADOW						:	std_logic;
	signal SHADOW_OUT					:	std_logic_vector(SHADOW_SIZE * 2 - 1 downto 0);
	
	------------------------ IR SIGNALS -----------------------------------
	signal IR_OUT						:	std_logic_vector(WORD_SIZE - 1 downto 0);
	signal IR_LOAD						:	std_logic;
	
	------------------------- BUS SIGNALS -----------------------------------
	signal DATA_BUS						:	std_logic_vector(WORD_SIZE - 1 downto 0);
	signal ADDRESS_UNIT_RSIDE_BUS		:	std_logic_vector(WORD_SIZE - 1 downto 0);
	------------------------- WP SIGNALS -----------------------------------
	signal WP_ADD_ENABLE				:	std_logic;
	signal WP_RESET						:	std_logic;
	signal WP_OUT						:	std_logic_vector(REGISTER_FILE_ADDRESS_SIZE - 1 downto 0);
	-------------------- REGISTER FILE SIGNALS -----------------------------
	signal RF_L_WRITE					:	std_logic;
	signal RF_H_WRITE					:	std_logic;

	signal LEFT_REGISTER_FROM_RF		:	std_logic_vector(WORD_SIZE - 1 downto 0);
	signal RIGHT_REGISTER_FROM_RF		:	std_logic_vector(WORD_SIZE - 1 downto 0);
begin
	
	FLAGS_INS : component FLAGS
		port map(
			CLK       => CLK,
			C_IN      => C_IN,
			Z_IN      => Z_IN,
			C_SET     => C_SET,
			C_RESET   => C_RESET,
			Z_SET     => Z_SET,
			Z_RESET   => Z_RESET,
			IL_ENABLE => FLAGS_IL_ENABLE,
			C_OUT     => C_OUT,
			Z_OUT     => Z_OUT
		);
		
	-------------------------- CONNECTING CONTROL SIGNALS --------------------------
	DATA_BUS		<=	MEMORY_BUS;
	ADDRESS_BUS		<=	ADDRESS_UNIT_OUT;
	
	ALU_OUT_TRI_STATE : component TRI_STATE
		generic map(
			COMPONENT_SIZE => WORD_SIZE
		)
		port map(
			DATA_IN  => ALU_OUT,
			STATE    => ALU_ON_DATA_BUS,
			DATA_OUT => DATA_BUS
		);
		
	RIGHT_REGISTER_ON_ADDRESS_UNIT_RSIDE_BUS_TRI_STATE : component TRI_STATE
		generic map(
			COMPONENT_SIZE => WORD_SIZE
		)
		port map(
			DATA_IN  => RIGHT_REGISTER_FROM_RF,
			STATE    => RS_ON_ADDRESS_UNIT_RSIDE,
			DATA_OUT => ADDRESS_UNIT_RSIDE_BUS
		);
	
	LEFT_REGISTER_ON_ADDRESS_UNIT_RSIDE_BUS_TRI_STATE : component TRI_STATE
		generic map(
			COMPONENT_SIZE => WORD_SIZE
		)
		port map(
			DATA_IN  => LEFT_REGISTER_FROM_RF,
			STATE    => RD_ON_ADDRESS_UNIT_RSIDE,
			DATA_OUT => ADDRESS_UNIT_RSIDE_BUS
		);
		
	ADDRESS_ON_DATA_BUS_TRI_STATE : component TRI_STATE
		generic map(
			COMPONENT_SIZE => WORD_SIZE
		)
		port map(
			DATA_IN  => ADDRESS_UNIT_OUT,
			STATE    => ADDRESS_ON_DATA_BUS,
			DATA_OUT => DATA_BUS
		);
	
	IR : component REGISTER_R
		generic map(
			REG_SIZE => WORD_SIZE
		)
		port map(
			IDATA => DATA_BUS,
			CLK   => CLK,
			LOAD  => IR_LOAD,
			RESET => '0',
			ODATA => IR_OUT
		);
		
	WP : component WINDOW_POINTER
		generic map(
			POINTER_SIZE => REGISTER_FILE_ADDRESS_SIZE
		)
		port map(
			CLK           => CLK,
			WP_ADD        => IR_OUT(REGISTER_FILE_ADDRESS_SIZE - 1 downto 0),
			WP_ADD_ENABLE => WP_ADD_ENABLE,
			WP_RESET      => WP_RESET,
			WP_OUT        => WP_OUT
		);
		
		
	CONTROL_UNIT_INS : component CONTROL_UNIT
		generic map(
			WORD_SIZE       => WORD_SIZE,
			WP_ADDRESS_SIZE => 6
		)
		port map(
			CLK                      => CLK,
			EXTERNAL_RESET           => EXTERNAL_RESET,
			HALTED					 => HALTED,
			MEM_DATA_READY           => MEM_DATA_READY,
			WRITE_MEM                => WRITE_MEM,
			READ_MEM                 => READ_MEM,
			Z_IN                     => Z_IN,
			C_IN                     => C_IN,
			C_OUT                    => C_OUT,
			Z_OUT                    => Z_OUT,
			C_SET                    => C_SET,
			C_RESET                  => C_RESET,
			Z_SET                    => Z_SET,
			Z_RESET                  => Z_RESET,
			IL_ENABLE                => FLAGS_IL_ENABLE,
			RESET_PC                 => RESET_PC,
			PC_PLUS_I                => PC_PLUS_I,
			PC_PLUS_1                => PC_PLUS_1,
			R_PLUS_I                 => R_PLUS_I,
			R_PLUS_0                 => R_PLUS_0,
			ENABLE_PC                => ENABLE_PC,
			ALU_OPERATION			 =>	ALU_OPERATION,
			WP_ADD_ENABLE            => WP_ADD_ENABLE,
			WP_RESET                 => WP_RESET,
			RF_L_WRITE				 => RF_L_WRITE,
			RF_H_WRITE				 => RF_H_WRITE,
			SHADOW                   => SHADOW,
			IR_INPUT                 => IR_OUT,
			IR_LOAD                  => IR_LOAD,
			ALU_ON_DATA_BUS			 =>	ALU_ON_DATA_BUS,
			ADDRESS_ON_BUS           => ADDRESS_ON_DATA_BUS,
			RS_ON_ADDRESS_UNIT_RSIDE => RS_ON_ADDRESS_UNIT_RSIDE,
			RD_ON_ADDRESS_UNIT_RSIDE => RD_ON_ADDRESS_UNIT_RSIDE
		);
		
	REGISTER_FILE_inst : component REGISTER_FILE
		generic map(
			REGESTER_SIZE => WORD_SIZE,
			ADDRESS_SIZE  => REGISTER_FILE_ADDRESS_SIZE
		)
		port map(
			IDATA      => DATA_BUS,
			CLK        => CLK,
			WP_IN      => WP_OUT,
			RF_L_WRITE => RF_L_WRITE,
			RF_H_WRITE => RF_H_WRITE,
			SELECTOR   => SHADOW_OUT,
			LEFT_OUT   => LEFT_REGISTER_FROM_RF,
			RIGHT_OUT  => RIGHT_REGISTER_FROM_RF
		);
		
	ALU_INS : component ALU
		generic map(
			COMPONENT_SIZE => WORD_SIZE
		)
		port map(
			CARRY_IN  => C_OUT,
			INPUT1    => LEFT_REGISTER_FROM_RF,
			INPUT2    => RIGHT_REGISTER_FROM_RF,
			OPERATION => ALU_OPERATION,
			OUTPUT    => ALU_OUT,
			CARRY_OUT => C_IN,
			ZERO_OUT  => Z_IN
		);
	
	ADDRESS_UNIT_INS : component ADDRESS_UNIT
		port map(
			Rside    => ADDRESS_UNIT_RSIDE_BUS,
			Iside    => IR_OUT(IMMEDIATE_H_INDEX downto IMMEDIATE_L_INDEX),
			Address  => ADDRESS_UNIT_OUT,
			clk      => CLK,
			ResetPC  => RESET_PC,
			PCplusI  => PC_PLUS_I,
			PCplus1  => PC_PLUS_1,
			RplusI   => R_PLUS_I,
			Rplus0   => R_PLUS_0,
			EnablePC => ENABLE_PC
		);
	SHADOW_MUX : with SHADOW select
		SHADOW_OUT <=
			IR_OUT(SHADOW_1_H_INDEX downto SHADOW_1_L_INDEX) when '0',
			IR_OUT(SHADOW_2_H_INDEX downto SHADOW_2_L_INDEX) when '1',
			IR_OUT(SHADOW_1_H_INDEX downto SHADOW_1_L_INDEX) when others;
				
end architecture;