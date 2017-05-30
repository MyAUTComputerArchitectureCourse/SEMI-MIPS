--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         09-04-2017
-- Package Name:        alu
-- Module Name:         ALU
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ALU is
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
end entity;

architecture ALU_ARCH of ALU is
	component ADDER_SUBTRACTOR_COMPONENT is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
			SUM			: out std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			CARRY		: out std_logic
	      );
	end component;
	component AND_COMPONENT is
		generic(
			COMPONENT_SIZE	: integer
		       );
		port(
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
		    );
	end component;
	component OR_COMPONENT is
		generic(
			COMPONENT_SIZE	: integer
		       );
		port(
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
		    );
	end component;
	component XOR_COMPONENT is
		generic(
			COMPONENT_SIZE	: integer
		       );
		port(
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
		    );
	end component;
	component SHIFT_L_COMPONENT is
		generic(
			COMPONENT_SIZE	: integer
		       );
		port(
			INPUT		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
		    );
	end component;
	component SHIFT_R_COMPONENT is
		generic(
			COMPONENT_SIZE	: integer
		       );
		port(
			INPUT		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
		    );
	end component;
	component COMPARISON_COMPONENT is
	    generic(
	        COMPONENT_SIZE  : integer
	    );
	
	    port(
	        INPUT1      : in std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	        INPUT2      : in std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	        Z_FLAG      : out std_logic;
	        CARRY_FLAG  : out std_logic
	    );
	end component;
	component TWOS_COMPLEMENT_COMPONENT is
	    generic (
	        COMPONENT_SIZE  : integer
	    );
	    port (
	        INPUT   : in std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	        OUTPUT  : out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
	    );
	end component;
	component VECTOR_NORER is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			INPUT		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OUTPUT		: out std_logic
	      );
	end component;
	component MULTIPLICATION_COMPONENT is
	generic(
		COMPONENT_SIZE	: integer
	);
	
	port(
		INPUT1		: in std_logic_vector(COMPONENT_SIZE/2 - 1 downto 0);
		INPUT2		: in std_logic_vector(COMPONENT_SIZE/2 - 1 downto 0);
		OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0)
	
	);
end component;
	
	signal UNKNOWN_SIG					: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal ZERO_SIG						: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	
	---------------- OUTPUT SIGNALS OF COMPONENTS ----------------
	signal ADDER_SUB_COMPONENT_OUT		: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal ADDER_SUB_COMPONENT_CARRY	: std_logic;
	signal AND_COMPONENT_OUT			: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal OR_COMPONENT_OUT				: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal XOR_COMPONENT_OUT			: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal SHIFT_L_COMPONENT_OUT		: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal SHIFT_R_COMPONENT_OUT		: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal COMPARISON_COMPONENT_CFLAG	: std_logic;
	signal COMPARISON_COMPONENT_ZFLAG	: std_logic;
	signal TWOS_COMPLEMENT_COMPONENT_OUT: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	signal MULTIPLICATION_COMPONENT_OUT : std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	
	
	signal OUTPUT_TEMP				: std_logic_vector(COMPONENT_SIZE - 1 downto 0);
	
	signal NOR_OF_OUTPUT			: std_logic;
begin
	
	GENERATE_UNKNOWN_SIG : for I in UNKNOWN_SIG'range generate
		UNKNOWN_SIG(I)  <= 'U';
	end generate GENERATE_UNKNOWN_SIG;
	
	GENERATE_ZERO_SIG : for I in ZERO_SIG'range generate
		ZERO_SIG(I)  <= '0';
	end generate GENERATE_ZERO_SIG;
	
	---------------------------------- ALU COMPONENTS INSTANTIATION SECTION ----------------------------------
	ADDER_SUB_COMPONENT_INS : component ADDER_SUBTRACTOR_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			CARRY_IN => CARRY_IN,
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			IS_SUB => OPERATION(0),
			SUM    => ADDER_SUB_COMPONENT_OUT,
			CARRY  => ADDER_SUB_COMPONENT_CARRY
		);
	AND_COMPONENT_INS		: AND_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			OUTPUT => AND_COMPONENT_OUT
		);
	OR_COMPONENT_INS		: OR_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			OUTPUT => OR_COMPONENT_OUT
		);
	XOR_COMPONENT_INS		: XOR_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			OUTPUT => XOR_COMPONENT_OUT
		);
	SHIFT_L_COMPONENT_INS	: SHIFT_L_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT  => INPUT1,
			OUTPUT => SHIFT_L_COMPONENT_OUT
		);
	SHIFT_R_COMPONENT_INS	: SHIFT_R_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT  => INPUT1,
			OUTPUT => SHIFT_R_COMPONENT_OUT
		);
	
	VECTOR_NORER_INS		: VECTOR_NORER
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT => OUTPUT_TEMP,
			OUTPUT => NOR_OF_OUTPUT
		);
			
	COMPARISON_COMPONENT_INS : component COMPARISON_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT1     => INPUT1,
			INPUT2     => INPUT2,
			Z_FLAG     => COMPARISON_COMPONENT_ZFLAG,
			CARRY_FLAG => COMPARISON_COMPONENT_CFLAG
		);
		
	TWOS_COMPLEMENT_COMPONENT_INS : component TWOS_COMPLEMENT_COMPONENT
		generic map(
			COMPONENT_SIZE => COMPONENT_SIZE
		)
		port map(
			INPUT  => INPUT1,
			OUTPUT => TWOS_COMPLEMENT_COMPONENT_OUT
		);
	
	MULTIPLICATION_COMPONENT_INS : component MULTIPLICATION_COMPONENT
		generic map(
			COMPONENT_SIZE	=> COMPONENT_SIZE
		)
		port map(
			INPUT1 => INPUT1(COMPONENT_SIZE/2 - 1 downto 0),
			INPUT2 => INPUT2(COMPONENT_SIZE/2 - 1 downto 0),
			OUTPUT => MULTIPLICATION_COMPONENT_OUT
		); 
		
	OUTPUT <= OUTPUT_TEMP;
	
	---------------------------------- SELECTOR OUTPUTS SECTION ----------------------------------
	OUTPUT_ASSIGNMENT : with OPERATION select
		OUTPUT_TEMP <=
			AND_COMPONENT_OUT when "0000",
			OR_COMPONENT_OUT when "0001",
			XOR_COMPONENT_OUT when "0010",
			UNKNOWN_SIG when "0011",
			SHIFT_L_COMPONENT_OUT when "0100",
			SHIFT_R_COMPONENT_OUT when "0101",
			ADDER_SUB_COMPONENT_OUT when "0110",
			ADDER_SUB_COMPONENT_OUT when "0111",
			TWOS_COMPLEMENT_COMPONENT_OUT when "1000",
			MULTIPLICATION_COMPONENT_OUT when "1001",
			INPUT2 when "1010",
			
			UNKNOWN_SIG when others;
	
	
	CARRY_ASSIGNMENT : with OPERATION select
		CARRY_OUT <=
			'0' when "0000",
			'0' when "0001",
			'0' when "0010",
			COMPARISON_COMPONENT_CFLAG when "0011",
			'0' when "0100",
			'0' when "0101",
			ADDER_SUB_COMPONENT_CARRY when "0110",
			ADDER_SUB_COMPONENT_CARRY when "0111",
			'0' when "1000",
			'0' when "1001",
			'0' when "1010",
			
			'U' when others;
			
	ZERO_F_ASSIGNMENT : with OPERATION select
		ZERO_OUT <=
			NOR_OF_OUTPUT when "0000",
			NOR_OF_OUTPUT when "0001",
			NOR_OF_OUTPUT when "0010",
			COMPARISON_COMPONENT_ZFLAG when "0011",
			NOR_OF_OUTPUT when "0100",
			NOR_OF_OUTPUT when "0101",
			NOR_OF_OUTPUT when "0110",
			NOR_OF_OUTPUT when "0111",
			NOR_OF_OUTPUT when "1000",
			NOR_OF_OUTPUT when "1001",
			
			'U' when others;
	
end architecture;