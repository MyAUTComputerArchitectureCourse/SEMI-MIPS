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
begin
	
end architecture;