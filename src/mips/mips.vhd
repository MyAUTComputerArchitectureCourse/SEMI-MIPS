entity SEMI_MIPS is
  port (
    clk   			: in  std_logic;
    we      		: out  std_logic;
    address 		: out  std_logic_vector(7 downto 0);
    memory_in		: in  std_logic_vector(15 downto 0);
    memory_out		: out  std_logic_vector(15 downto 0)
  );
end entity;

architecture ALU_ARCH of ALU is
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
	
	signal DATABUS  : std_logic_vector(15 downto 0);
 	signal Address : std_logic_vector(7 downto 0);
	signal S1 , S2 , reg2 , d  : std_logic_vector(2 downto 0);
	signal 4bit_Alu_op : std_logic_vector(3 downto 0);
	signal I , carryIn, overflowIn, carry, zero, sign, parity, borrow, overflow   : std_logic;
 	signal ALUoutput , source1 , source2 , IRin ,  IRoutput : std_logic_vector (15 downto 0);
	
	
	
	
begin
	IR : component reg16b
		port map(
			clk    => clk,
			load   => load,
			reset  => reset,
			input  => input,
			output => output
		);
		
	ADDRESS_UNIT_inst : component ADDRESS_UNIT
		port map(
			Iside    => Iside,
			Address  => Address,
			clk      => clk,
			ResetPC  => ResetPC,
			I        => I,
			PCplus1  => PCplus1,
			EnablePC => EnablePC
		);
		
	ALU_inst : component ALU
		port map(
			CARRY_IN  => CARRY_IN,
			INPUT1    => INPUT1,
			INPUT2    => INPUT2,
			OPERATION => OPERATION,
			OUTPUT    => OUTPUT,
			CARRY_OUT => CARRY_OUT,
			ZERO_OUT  => ZERO_OUT
		);
	
	STATUS_REGISTER_inst : component STATUS_REGISTER
		port map(
			carryIn    => carryIn,
			overflowIn => overflowIn,
			data       => data,
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
			INPUT    => INPUT,
			IN_ADR   => IN_ADR,
			OUT1_ADR => OUT1_ADR,
			OUT2_ADR => OUT2_ADR,
			OUTPUT1  => OUTPUT1,
			OUTPUT2  => OUTPUT2
		);
		
	MEM_TRI_STATE : with signalName select
		DATABUS <=
			 when choice1,
			
			expression2 when others;
	
end architecture;