entity SEMI_MIPS is
  port (
    clk   			: in  std_logic;
    external_reset	: in std_logic;
    we      		: out  std_logic;
    address 		: out  std_logic_vector(7 downto 0);
    memory_in		: in  std_logic_vector(15 downto 0);
    memory_out		: out  std_logic_vector(15 downto 0)
  );
end entity;

architecture DATA_PATH of SEMI_MIPS is
	component ALU is
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(16 - 1 downto 0);
			INPUT2		: in  std_logic_vector(16 - 1 downto 0);
			OPERATION	: in  std_logic_vector(3 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0);
			CARRY_OUT	: out std_logic;
			ZERO_OUT	: out std_logic
	      );
	end component;
	
	component STATUS_REGISTER is
		PORT (
	        carryIn, overflowIn : IN std_logic;
	        data : IN std_logic_vector (15 DOWNTO 0);
	        carry, zero, sign, parity, borrow, overflow : OUT std_logic
	    );
	end component;
	
	component registerFile is
		port (
			CLK		:	in	std_logic;
			W_EN	:	in	std_logic;
			INPUT	:	in	std_logic_vector(15 downto 0);
			IN_ADR	:	in	std_logic_vector(3 downto 0);
			OUT1_ADR:	in	std_logic_vector(3 downto 0);
			OUT2_ADR:	in	std_logic_vector(3 downto 0);
			OUTPUT1	:	out	std_logic_vector(15 downto 0);
			OUTPUT2	:	out	std_logic_vector(15 downto 0)
		);
	end component;
	
	component ADDRESS_UNIT is
		PORT (
	        Iside : IN std_logic_vector (7 DOWNTO 0);
	        Address : OUT std_logic_vector (7 DOWNTO 0);
	        clk, ResetPC, I, PCplus1 : IN std_logic;
	        EnablePC : IN std_logic
	    );
	end component;
	
	component reg16b is
		port(clk, load, reset : in STD_LOGIC;
			input : in STD_LOGIC_VECTOR (15 downto 0);
			output : out STD_LOGIC_VECTOR (15 downto 0) := "0000000000000000"
		);
	end component;
	
	component CU is
		port (
		  clk, ExternalReset, 
		  carry, zero, sign, parity, borrow, overflow		       -- status register
		        : in STD_LOGIC;
		        
		  IRout : in STD_LOGIC_VECTOR(15 downto 0);                -- IR 
	
		  reg0 : in STD_LOGIC_VECTOR(15 downto 0);				   -- Register(0)
		  
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
			
			
	
	end component;

	
	
	
	signal DATABUS  : std_logic_vector(15 downto 0);
 	
	signal S1 , S2 , reg2 , d  : std_logic_vector(2 downto 0);
	
	signal ALU_OP : std_logic_vector(3 downto 0);
	signal ALUoutput, ALU_INPUT2 : std_logic_vector(15 downto 0);
	signal ALU_Zero : std_logic;
	
	
	signal carryIn, overflowIn, carry, zero, sign, parity, borrow, overflow   : std_logic;
 	
 	signal REG_FILE_SRC1 , REG_FILE_SRC2 ,  IRoutput : std_logic_vector (15 downto 0);
 	signal W_EN : std_logic;
	
	signal IRLoad, IRReset : std_logic;
	signal I : std_logic;
	signal PCplus1, EnablePC : std_logic;
	
	
begin
	IR : component reg16b
		port map(
			clk    => clk,
			load   => IRLoad,
			reset  => IRReset,
			input  => DATABUS,
			output => IRoutput
		);
		
	ADDRESS_UNIT_inst : component ADDRESS_UNIT
		port map(
			Iside    => IRoutput(7 downto 0),
			Address  => Address,
			clk      => clk,
			ResetPC  => external_reset,
			I        => I,
			PCplus1  => PCplus1,
			EnablePC => EnablePC
		);
		
	ALU_inst : component ALU
		port map(
			CARRY_IN  => carry,
			INPUT1    => INPUT1,
			INPUT2    => ALU_INPUT2,
			OPERATION => ALU_OP,
			OUTPUT    => ALUoutput,
			CARRY_OUT => carryIn,
			ZERO_OUT  => ALU_Zero
		);
	
	STATUS_REGISTER_inst : component STATUS_REGISTER
		port map(
			carryIn    => carryIn,
			overflowIn => overflowIn,
			data       => ALUoutput,
			carry      => carry,
			zero       => zero,
			sign       => sign,
			parity     => parity,
			borrow     => borrow,
			overflow   => overflow
		);
		
	registerFile_inst : component registerFile
		port map(
			CLK      => CLK,
			W_EN     => W_EN,
			INPUT    => DATABUS,
			IN_ADR   => IN_ADR,
			OUT1_ADR => OUT1_ADR,
			OUT2_ADR => OUT2_ADR,
			OUTPUT1  => OUTPUT1,
			OUTPUT2  => OUTPUT2
		);
		
	CU_inst : component CU
		port map(
			clk               => clk,
			ExternalReset     => ExternalReset,
			carry             => carry,
			zero              => zero,
			sign              => sign,
			parity            => parity,
			borrow            => borrow,
			overflow          => overflow,
			IRout             => IRout,
			reg0              => reg0,
			ALUout_on_Databus => ALUout_on_Databus,
			IRload            => IRload,
			ResetPC           => ResetPC,
			I                 => I,
			PCplus1           => PCplus1,
			EnablePC          => EnablePC,
			W_EN              => W_EN,
			we                => we,
			re                => re,
			itype             => itype,
			alu_operation     => ALU_OP,
			databus           => databus
		);
		
		
	MEM_TRI_STATE : with signalName select
		DATABUS <=
			 when choice1,
			
			expression2 when others;
	
end architecture;