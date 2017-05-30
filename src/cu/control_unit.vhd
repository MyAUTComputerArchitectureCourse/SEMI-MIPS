--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         11-04-2017
-- Package Name:        cu
-- Module Name:         CONTROL_UNIT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity CONTROL_UNIT is
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
		-- ---------------- FLAGS RELATED SIGNALS -----------------
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
		ALU_OPERATION			 : out std_logic_vector(3 downto 0);				--	This is not generic cause it can't be :D
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
end entity;

architecture CONTROL_UNIT_ARCH of CONTROL_UNIT is
	type CU_STATE_TYPE is (
		FETCH_0, FETCH_1,
		DECODE,
		HLT,
		EXEC_NOP, EXEC_HLT, EXEC_SZF, EXEC_CZF, EXEC_SCF, EXEC_CCF, EXEC_CWP,
		EXEC_JPR, EXEC_BRZ, EXEC_BRC, EXEC_AWP,
		EXEC_MVR, EXEC_LDA, EXEC_STA, EXEC_INP, EXEC_OUP, EXEC_AND, EXEC_ORR, EXEC_NOT, EXEC_SHL, EXEC_SHR, EXEC_ADD, EXEC_ADD2, EXEC_SUB, EXEC_MUL, EXEC_CMP,
		EXEC_MIL, EXEC_MIH, EXEC_SPC, EXEC_JPA,
		END_OF_NOP,
		WRITE_BACK,
		END_OF_INSTRUCTION
	);

	signal NEXT_CU_STATE : CU_STATE_TYPE := FETCH_0;
	signal IS_IMEDIATE      : std_logic;
	signal IS_SECOND_PART   : std_logic;
	signal OPCODE_HELPER1   : std_logic_vector(1 downto 0);
	signal OPCODE_HELPER2   : std_logic_vector(1 downto 0);
	signal OPCODE           : std_logic_vector(3 downto 0);
	
	signal THIS_LOGGING_STATE	:	std_logic_vector(5 downto 0);

begin

	process(CLK)
	begin
		if CLK'event and CLK = '1' then
			if EXTERNAL_RESET = '1' then
				THIS_LOGGING_STATE		<=	"XXXXXX";
				WRITE_MEM                <= '0';
				READ_MEM                 <= '0';
				
				RESET_PC                 <= '1';
				PC_PLUS_I       		 <= '0';
				PC_PLUS_1       		 <= '0';
				R_PLUS_I        		 <= '0';
				R_PLUS_0        		 <= '0';
				ENABLE_PC				 <= '1';
				
				C_RESET                  <= '1';
				Z_RESET                  <= '1';
				C_SET					 <= '0';
				Z_SET					 <= '0';
				IL_ENABLE				 <= '0';
				
				WP_RESET                 <= '1';
				RF_L_WRITE				 <=	'0';
				RF_H_WRITE				 <=	'0';
				
				ALU_ON_DATA_BUS			 <=	'0';
				ADDRESS_ON_BUS           <= '0';
				RS_ON_ADDRESS_UNIT_RSIDE <= '0';
				RD_ON_ADDRESS_UNIT_RSIDE <= '0';
				HALTED					 <= '0';
				IR_LOAD                  <= '0';
				IS_SECOND_PART           <= '0';
				NEXT_CU_STATE         <= FETCH_0;
			else
				RESET_PC			<= '0';
				ENABLE_PC			<= '0';
				Z_SET				<= '0';
				Z_RESET				<= '0';
				C_SET				<= '0';
				C_RESET				<= '0';
				
				WP_RESET                 <= '0';
				case NEXT_CU_STATE is
				
				when FETCH_0 =>
					THIS_LOGGING_STATE		<=	"000000";
					READ_MEM <= '1';
					-- -- AL_OUT <- PC ----
					RESET_PC         <= '0';
					PC_PLUS_I        <= '0';
					PC_PLUS_1        <= '0';
					R_PLUS_I         <= '0';
					R_PLUS_0         <= '0';
					
					IR_LOAD          <= '1';
					if MEM_DATA_READY = '1' then
						NEXT_CU_STATE <= FETCH_1;
					end if;
				when FETCH_1 =>
					NEXT_CU_STATE <= DECODE;
					IR_LOAD <= '0';
				when DECODE =>
					THIS_LOGGING_STATE		<=	"000010";
					READ_MEM	<=	'0';
					

					if IS_SECOND_PART = '1' then
						OPCODE <= IR_INPUT(7 downto 4);
					else
						OPCODE <= IR_INPUT(15 downto 12);
					end if;

					if IS_SECOND_PART = '1' then
						OPCODE_HELPER1 <= IR_INPUT(3 downto 2);
						OPCODE_HELPER2 <= IR_INPUT(1 downto 0);
					else
						OPCODE_HELPER1 <= IR_INPUT(11 downto 10);
						OPCODE_HELPER2 <= IR_INPUT(9 downto 8);
					end if;
					
					case OPCODE is
						
						when "0000" =>
							if IS_SECOND_PART = '1' then
								OPCODE_HELPER1 <= IR_INPUT(3 downto 2);
								OPCODE_HELPER2 <= IR_INPUT(1 downto 0);
							else
								OPCODE_HELPER1 <= IR_INPUT(11 downto 10);
								OPCODE_HELPER2 <= IR_INPUT(9 downto 8);
							end if;

							case OPCODE_HELPER1 is
								when "00" =>
									IS_SECOND_PART <= not IS_SECOND_PART;
									
									case OPCODE_HELPER2 is
										when "00" =>		--	NO OPERATION 
											NEXT_CU_STATE <= END_OF_INSTRUCTION;
										when "01" =>		--	HLT 
											NEXT_CU_STATE <= HLT;
										when "10" =>		--	SZF
											Z_SET		<= '1';
											NEXT_CU_STATE <= END_OF_INSTRUCTION;					
										when "11" =>		--	CZF
											Z_RESET		<= '1';
											NEXT_CU_STATE <= END_OF_INSTRUCTION;
										when others => null;
									end case;
									
								when "01" =>
									
									case OPCODE_HELPER2 is
										when "00" =>		--	SCF
											IS_SECOND_PART <= not IS_SECOND_PART;
											C_SET	<= '1';
											NEXT_CU_STATE	<= END_OF_INSTRUCTION;
										when "01" =>		--	CCF	 
											IS_SECOND_PART <= not IS_SECOND_PART;
											C_RESET	<= '1';
											NEXT_CU_STATE	<= END_OF_INSTRUCTION;
										when "10" =>		--	CWP 
											IS_SECOND_PART <= not IS_SECOND_PART;
											WP_RESET	<= '1';
											NEXT_CU_STATE	<= END_OF_INSTRUCTION;
										when "11" =>		--	JPR
											PC_PLUS_I	<= '1';
											ENABLE_PC	<= '1';
											NEXT_CU_STATE	<= EXEC_JPR;						
										when others => null;
									end case;
								when "10" =>
									IS_SECOND_PART		<= '0';
									case OPCODE_HELPER2 is
										when "00" =>
											if Z_IN = '1' then
												PC_PLUS_I	<= '1';
												ENABLE_PC	<= '1';
												NEXT_CU_STATE	<= EXEC_BRZ;
											else
												NEXT_CU_STATE	<= END_OF_INSTRUCTION;
											end if;
										when "01" =>
											if C_IN = '1' then
												PC_PLUS_I	<= '1';
												ENABLE_PC	<= '1';
												NEXT_CU_STATE	<= EXEC_BRC;
											else
												NEXT_CU_STATE	<= END_OF_INSTRUCTION;
											end if;
										when "10" =>
											WP_ADD_ENABLE	<= '1';
											NEXT_CU_STATE	<= EXEC_AWP;
										when others => null;
									end case;
								when "11" =>
									null;
								when others =>
									null;
							end case;
						when "0001" =>				--	Move register
							SHADOW						<= IS_SECOND_PART;
							ALU_ON_DATA_BUS				<= '1';
							RF_H_WRITE					<= '1';
							RF_L_WRITE					<= '1';
							NEXT_CU_STATE <= EXEC_MVR; 
						when "0010" =>				--	Load address
							SHADOW						<= IS_SECOND_PART;
							READ_MEM					<= '1';
							R_PLUS_0					<= '1';
							RS_ON_ADDRESS_UNIT_RSIDE	<= '1';
							RF_H_WRITE					<= '1';
							RF_L_WRITE					<= '1';
							NEXT_CU_STATE <= EXEC_LDA;
						when "0011" =>				--	Store address
							SHADOW						<= IS_SECOND_PART;
							ALU_OPERATION				<= "1010";
							ALU_ON_DATA_BUS				<= '1';
							WRITE_MEM					<= '1';
							R_PLUS_0					<= '1';
							RD_ON_ADDRESS_UNIT_RSIDE	<= '1';
							NEXT_CU_STATE <= EXEC_STA;
						when "0100" =>				--	Input from port
							SHADOW			<=	IS_SECOND_PART;
							NEXT_CU_STATE <= EXEC_INP;
						when "0101" =>				--	Output to port
							SHADOW			<=	IS_SECOND_PART;
							NEXT_CU_STATE <= EXEC_OUP;
						when "0110" =>				--	And
							SHADOW						<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"0000";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE				<=	EXEC_AND;
						when "0111" =>				--	OR
							SHADOW						<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"0001";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE <= EXEC_ORR;
						when "1000" =>				--	Not
							SHADOW			<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"1000";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE <= EXEC_NOT;
						when "1001" =>				--	Shift left
							SHADOW			<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"0100";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE <= EXEC_SHL;
						when "1010" =>				--	Shift right
							SHADOW						<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"0011";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE				<=	EXEC_SHR;
						when "1011" =>				--	Add
							ALU_OPERATION				<= "0110";
							RF_H_WRITE					<= '0';
							RF_L_WRITE					<= '0';
							THIS_LOGGING_STATE			<= "101011";
							NEXT_CU_STATE				<=	EXEC_ADD;
						when "1100" =>				--	Subtract
							SHADOW						<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"0111";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE				<=	EXEC_SUB;
						when "1101" =>				--	Multiply
							SHADOW						<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"1001";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE				<=	EXEC_MUL;
						when "1110" =>				--	Compare
							SHADOW						<=	IS_SECOND_PART;
							ALU_OPERATION				<=	"0011";
							ALU_ON_DATA_BUS				<=	'1';
							IL_ENABLE					<=	'1';
							NEXT_CU_STATE				<=	EXEC_CMP;
							
						when "1111" =>				-- Oner group instructions
							IS_SECOND_PART	<=	'0';		
							SHADOW			<=	'0';
							case OPCODE_HELPER2 is
							when "00" =>			--	Move Immidiate low
								
								SHADOW			<=	'0';
								RF_L_WRITE		<=	'1';
								READ_MEM		<=	'1';	-- Read the immediate data directly from the data bus that came from memory
								NEXT_CU_STATE	<=	EXEC_MIL;					
							when "01" => 			--	Move Immidaite high
								SHADOW			<=	'0';
								RF_H_WRITE		<=	'1';
								READ_MEM		<=	'1';	-- Read the immediate data directly from the data bus that came from memory
								NEXT_CU_STATE	<=	EXEC_MIH;
								
							when "10" =>			--	Save pc
								PC_PLUS_I					<=	'1';
								ADDRESS_ON_BUS				<=	'1';
								RF_H_WRITE					<=	'1';
								RF_L_WRITE					<=	'1';
								NEXT_CU_STATE				<=	EXEC_SPC;
							when "11" =>			--	Jump addressed
								R_PLUS_I					<=	'1';
								ENABLE_PC					<=	'1';
								RD_ON_ADDRESS_UNIT_RSIDE	<=	'1';
								NEXT_CU_STATE				<=	EXEC_JPA;
							when others =>
								THIS_LOGGING_STATE <= "0X0X0X";
							end case;
						when others =>
							null;
					end case;
				when EXEC_NOP =>
					null;
				when EXEC_HLT =>
					null;
				when EXEC_SZF =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_CZF =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_SCF =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_CCF =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_CWP =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_JPR =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_BRZ =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_BRC =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_AWP =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_MVR =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_LDA =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_STA =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_INP =>
					NEXT_CU_STATE <= END_OF_INSTRUCTION;
				when EXEC_OUP =>
					NEXT_CU_STATE	<= END_OF_INSTRUCTION;
				when EXEC_AND =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_ORR =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_NOT =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_SHL =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_SHR =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_ADD =>
					THIS_LOGGING_STATE <= "101010";
					NEXT_CU_STATE	<= EXEC_ADD2;
				when EXEC_ADD2 =>
					
					IS_SECOND_PART	<= not IS_SECOND_PART;
					SHADOW						<=	IS_SECOND_PART;
					ALU_OPERATION				<=	"0110";
					ALU_ON_DATA_BUS				<=	'1';
					IL_ENABLE					<=	'1';
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_SUB =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_MUL =>
					IS_SECOND_PART	<= not IS_SECOND_PART;
					NEXT_CU_STATE	<= WRITE_BACK;
				when EXEC_CMP =>
					NEXT_CU_STATE 	<= END_OF_INSTRUCTION;
				when EXEC_MIL =>
					NEXT_CU_STATE	<= END_OF_INSTRUCTION;
				when EXEC_MIH =>
					NEXT_CU_STATE	<= END_OF_INSTRUCTION;
				when EXEC_SPC =>
					NEXT_CU_STATE	<= END_OF_INSTRUCTION;
				when EXEC_JPA =>
					null;
				when END_OF_NOP =>
					null;
				when WRITE_BACK =>
					ALU_ON_DATA_BUS	<=	'0';
					RF_H_WRITE		<=	'1';
					RF_L_WRITE		<=	'1';
					IL_ENABLE		<=	'0';
					NEXT_CU_STATE	<=	END_OF_INSTRUCTION;
				when HLT =>
					THIS_LOGGING_STATE <= "111110";
					HALTED			<= '1';
					NEXT_CU_STATE 	<= HLT;
				when END_OF_INSTRUCTION =>
					THIS_LOGGING_STATE <= "111111";
					
					Z_SET						<= '0';
					Z_RESET						<= '0';
					C_SET						<= '0';
					C_RESET						<= '0';
					IL_ENABLE					<= '0';
					
					WP_RESET					<= '0';
					WP_ADD_ENABLE				<= '0';
					
					READ_MEM					<= '0';
					WRITE_MEM					<= '0';
					
					RF_L_WRITE					<=	'0';
					RF_H_WRITE					<=	'0';
					
					PC_PLUS_I					<=	'0';
					R_PLUS_I					<=	'0';
					ENABLE_PC					<=	'0';
					R_PLUS_0					<=	'0';
					
					ADDRESS_ON_BUS				<=	'0';
					RS_ON_ADDRESS_UNIT_RSIDE	<=	'0';
					RD_ON_ADDRESS_UNIT_RSIDE	<=	'0';
					ALU_ON_DATA_BUS				<=	'0';
							
					if IS_SECOND_PART = '1' then
						NEXT_CU_STATE <= DECODE;
					else
						ENABLE_PC	  <= '1';
						PC_PLUS_1	  <= '1';
						READ_MEM	  <= '1';
						NEXT_CU_STATE <= FETCH_0;
					end if;
				when others =>
					null;
						
				end case;
			end if;

		end if;
	end process;
end architecture;
