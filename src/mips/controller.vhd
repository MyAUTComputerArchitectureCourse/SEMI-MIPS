library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity CU is
	port (
	  clk, ExternalReset, 
	  carry, zero, sign, parity, borrow, overflow		       -- status register
	        : in STD_LOGIC;
	        
	  IRout : in STD_LOGIC_VECTOR(15 downto 0);                -- IR 
	  
	  ALUout_on_Databus,					                   -- Data Bus
	  IRload,                                                  -- IR
	  ResetPC, I, PCplus1, EnablePC,    					   -- Address Unit
	  W_EN,                 			                       -- register file
	  we, re,		                                           -- memory
	  itype
	        : out STD_LOGIC;
	            -- ALU's bits
	    	alu_operation : out std_logic_vector(3 downto 0);
	    	
	    	databus : inout std_logic_vector(15 downto 0)
	    	
		);
		
		

end entity;

architecture CU_ARCH of CU is 
	type state is (reset, fetch, baseExe, halt, PCInc, shiftRighting, shiftLefting);
	signal currentState : state := reset;
	signal nextState : state;
	

	constant add  : STD_LOGIC_VECTOR(3 downto 0) := "0000";
	constant sub  : STD_LOGIC_VECTOR(3 downto 0) := "0001";
	constant andD  : STD_LOGIC_VECTOR(3 downto 0) := "0010";
	constant orD  : STD_LOGIC_VECTOR(3 downto 0) := "0011";
	constant xorD  : STD_LOGIC_VECTOR(3 downto 0) := "0100";
	constant notD  : STD_LOGIC_VECTOR(3 downto 0) := "0101";
	
	constant mul  : STD_LOGIC_VECTOR(3 downto 0) := "0110";
	constant jmp  : STD_LOGIC_VECTOR(3 downto 0) := "0111";
	constant addi  : STD_LOGIC_VECTOR(3 downto 0) := "1000";
	constant srlD  : STD_LOGIC_VECTOR(3 downto 0) := "1001";
	constant andi  : STD_LOGIC_VECTOR(3 downto 0) := "1010";
	
	constant ori  : STD_LOGIC_VECTOR(3 downto 0) := "1011";
	constant sllD  : STD_LOGIC_VECTOR(3 downto 0) := "1100";
	constant store  : STD_LOGIC_VECTOR(3 downto 0) := "1101";
	constant load  : STD_LOGIC_VECTOR(3 downto 0) := "1110";
	constant brnz  : STD_LOGIC_VECTOR(3 downto 0) := "1111";
	
	
	---------- ALU Operations ----------------------
	constant ALU_and : std_logic_vector (3 downto 0) := "0000";
	constant ALU_or : std_logic_vector (3 downto 0) := "0001";
	constant ALU_xor : std_logic_vector (3 downto 0) := "0010";
	constant ALU_sl : std_logic_vector (3 downto 0) := "0100";
	constant ALU_sr : std_logic_vector (3 downto 0) := "0101";
	constant ALU_add : std_logic_vector (3 downto 0) := "0110";
	constant ALU_mul : std_logic_vector (3 downto 0) := "1001";
	constant ALU_sub : std_logic_vector (3 downto 0) := "0111";
	constant ALU_not : std_logic_vector (3 downto 0) := "1000";
	constant ALU_input2 : std_logic_vector (3 downto 0) := "1010";


	signal Immediate : std_logic_vector(7 downto 0);
	signal shiftTempSig : std_logic_vector(15 downto 0);
	
begin
	
	Immediate <= IRout(7 downto 0);
	
  -- state changer
	  process (clk, ExternalReset)
		begin
			if ExternalReset = '1' then
			currentState <= reset;
		elsif clk'event and clk = '1' then
			currentState <= nextState;
		end if;
	end process;
	
	
	-- control signals base on state
	process (currentState)
		variable shiftCounter : integer;
		
	begin
	  -- set defaults
	ALUout_on_Databus <= '0';
	IRload <= '0';
	ResetPC <= '0';
	EnablePC <= '0';
	PCplus1 <= '0';
	itype <= '0';
	ALUout_on_Databus <= '0';
	W_EN <= '0';
	we <= '0';
	re <= '0';
	
	
	
		case currentState is
		  when halt =>
		    nextState <= halt;
			when reset =>
			  ResetPC <= '1';
			  EnablePC <= '1';
			  nextState <= fetch;
			  
			when fetch =>
			  re <= '1';
			  IRload <= '1';
			  nextState <= baseExe;
			  
			when baseExe =>
			  
				case IRout(15 downto 12) is
				when add =>
					alu_operation <= ALU_add;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when addi =>
					alu_operation <= ALU_add;
					PCplus1 <= '1';
					EnablePC <= '1';
					itype <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when sub =>
					alu_operation <= ALU_sub;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when andD =>
					alu_operation <= ALU_and;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when andi =>
					alu_operation <= ALU_and;
					PCplus1 <= '1';
					EnablePC <= '1';
					itype <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when orD =>
					alu_operation <= ALU_or;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when ori =>
					alu_operation <= ALU_or;
					PCplus1 <= '1';
					EnablePC <= '1';
					itype <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when xorD =>
					alu_operation <= ALU_xor;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when notD =>
					alu_operation <= ALU_not;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when mul =>
					alu_operation <= ALU_mul;
					PCplus1 <= '1';
					EnablePC <= '1';
					ALUout_on_Databus <= '1';
					nextState <= fetch;
				when jmp =>
					nextState <= fetch;
					I <= '1';
					EnablePC <= '1';
				when brnz =>
					alu_operation <= ALU_sub;
					if (z = '0') then -- if reg(0) is 0
						nextState <= fetch;
						I <= '1';
						EnablePC <= '1';
					else
						nextState <= fetch;
						EnablePC <= '1';
						PCplus1 <= '1';
					end if;
				when store =>
					I <= '1';
					we <= '1';
					alu_operation <= ALU_input2;
					ALUout_on_Databus <= '1';
					nextState <= PCInc;
				when load =>
					I <='1';
					re <= '1';
					W_EN <='1';
					PCplus1 <= '1';
					EnablePC <= '1';
					nextState <= PCInc;
				when srlD =>
					shiftCounter  := to_integer(usnigned(Immediate));
					alu_operation <= ALU_input2;
					ALUout_on_Databus <= '1';
					shiftTempSig <= databus;
					nextState <= shiftRighting;
				when sllD =>
					shiftCounter  := to_integer(usnigned(Immediate));
					alu_operation <= ALU_input2;
					ALUout_on_Databus <= '1';
					shiftTempSig <= databus;
					nextState <= shiftLefting;
				end case;
				
		when PCInc =>
			PCplus1 <= '1';
			EnablePC <= '1';
			nextState <= fetch;
			  
		when shiftRighting =>
			
			case Immediate is 
				when 0 =>
					PCplus1 <= '1';
					EnablePC <= '1';
					nextState <= fetch;
				when OTHERS =>
					nextState <= shiftRighting;
			end case;
				
			shiftCounter := shiftCounter - 1;
		when shiftLefting =>
			
			case Immediate is 
				when 0 =>
					PCplus1 <= '1';
					EnablePC <= '1';
					nextState <= fetch;
				when OTHERS =>
					shiftTempSig <= shiftTempSig(14 downto 0) & '0';
					
					nextState <= shiftLefting;
			end case;
				
			shiftCounter := shiftCounter - 1;
		when comparator =>
			
			when OTHERS =>
			  nextState <= reset;
			  
		end case;
	end process;
end architecture;