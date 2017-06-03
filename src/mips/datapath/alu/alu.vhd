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
	port(
		CARRY_IN	: in  std_logic;
		INPUT1		: in  std_logic_vector(16 - 1 downto 0);
		INPUT2		: in  std_logic_vector(16 - 1 downto 0);
		OPERATION	: in  std_logic_vector(3 downto 0);
		OUTPUT		: out std_logic_vector(16 - 1 downto 0);
		CARRY_OUT	: out std_logic;
		ZERO_OUT	: out std_logic
      );
end entity;

architecture ALU_ARCH of ALU is
	component ADDER_SUBTRACTOR_COMPONENT is
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(16 - 1 downto 0);
			INPUT2		: in  std_logic_vector(16 - 1 downto 0);
			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
			SUM			: out std_logic_vector(16 - 1 downto 0);
			CARRY		: out std_logic
	      );
	end component;
	component AND_COMPONENT is
		port(
			INPUT1		: in  std_logic_vector(16 - 1 downto 0);
			INPUT2		: in  std_logic_vector(16 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		    );
	end component;
	component OR_COMPONENT is
		port(
			INPUT1		: in  std_logic_vector(16 - 1 downto 0);
			INPUT2		: in  std_logic_vector(16 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		    );
	end component;
	component XOR_COMPONENT is
		port(
			INPUT1		: in  std_logic_vector(16 - 1 downto 0);
			INPUT2		: in  std_logic_vector(16 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		    );
	end component;
	component SHIFT_L_COMPONENT is
		port(
			INPUT		: in  std_logic_vector(16 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		    );
	end component;
	component SHIFT_R_COMPONENT is
		port(
			INPUT		: in  std_logic_vector(16 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		    );
	end component;
	component MULTIPLICATION_COMPONENT is
		port(
			INPUT1		: in std_logic_vector(16/2 - 1 downto 0);
			INPUT2		: in std_logic_vector(16/2 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		
		);
	end component;
	component NOT_COMPONENT is
		port(
			INPUT		: in  std_logic_vector(16 - 1 downto 0);
			OUTPUT		: out std_logic_vector(16 - 1 downto 0)
		    );
	end component;
	
	signal UNKNOWN_SIG					: std_logic_vector(16 - 1 downto 0);
	signal ZERO_SIG						: std_logic_vector(16 - 1 downto 0);
	
	---------------- OUTPUT SIGNALS OF COMPONENTS ----------------
	signal ADDER_SUB_COMPONENT_OUT		: std_logic_vector(16 - 1 downto 0);
	signal ADDER_SUB_COMPONENT_CARRY	: std_logic;
	signal AND_COMPONENT_OUT			: std_logic_vector(16 - 1 downto 0);
	signal OR_COMPONENT_OUT				: std_logic_vector(16 - 1 downto 0);
	signal XOR_COMPONENT_OUT			: std_logic_vector(16 - 1 downto 0);
	signal SHIFT_L_COMPONENT_OUT		: std_logic_vector(16 - 1 downto 0);
	signal SHIFT_R_COMPONENT_OUT		: std_logic_vector(16 - 1 downto 0);
	signal MULTIPLICATION_COMPONENT_OUT : std_logic_vector(16 - 1 downto 0);
	signal NOT_COMPONENT_OUT			: std_logic_vector(16 - 1 downto 0);
	
	
	signal OUTPUT_TEMP				: std_logic_vector(16 - 1 downto 0);
begin
	
	GENERATE_UNKNOWN_SIG : for I in UNKNOWN_SIG'range generate
		UNKNOWN_SIG(I)  <= 'U';
	end generate GENERATE_UNKNOWN_SIG;
	
	GENERATE_ZERO_SIG : for I in ZERO_SIG'range generate
		ZERO_SIG(I)  <= '0';
	end generate GENERATE_ZERO_SIG;
	
	---------------------------------- ALU COMPONENTS INSTANTIATION SECTION ----------------------------------
	ADDER_SUB_COMPONENT_INS : component ADDER_SUBTRACTOR_COMPONENT
		port map(
			CARRY_IN => CARRY_IN,
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			IS_SUB => OPERATION(0),
			SUM    => ADDER_SUB_COMPONENT_OUT,
			CARRY  => ADDER_SUB_COMPONENT_CARRY
		);
	AND_COMPONENT_INS		: AND_COMPONENT
		port map(
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			OUTPUT => AND_COMPONENT_OUT
		);
	OR_COMPONENT_INS		: OR_COMPONENT
		port map(
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			OUTPUT => OR_COMPONENT_OUT
		);
	XOR_COMPONENT_INS		: XOR_COMPONENT
		port map(
			INPUT1 => INPUT1,
			INPUT2 => INPUT2,
			OUTPUT => XOR_COMPONENT_OUT
		);
	SHIFT_L_COMPONENT_INS	: SHIFT_L_COMPONENT
		port map(
			INPUT  => INPUT1,
			OUTPUT => SHIFT_L_COMPONENT_OUT
		);
	SHIFT_R_COMPONENT_INS	: SHIFT_R_COMPONENT
		port map(
			INPUT  => INPUT1,
			OUTPUT => SHIFT_R_COMPONENT_OUT
		);
	
	VECTOR_NORER_INS		: VECTOR_NORER
		port map(
			INPUT => OUTPUT_TEMP,
			OUTPUT => NOR_OF_OUTPUT
		);
			
	COMPARISON_COMPONENT_INS : component COMPARISON_COMPONENT
		port map(
			INPUT1     => INPUT1,
			INPUT2     => INPUT2,
			Z_FLAG     => COMPARISON_COMPONENT_ZFLAG,
			CARRY_FLAG => COMPARISON_COMPONENT_CFLAG
		);
	
	MULTIPLICATION_COMPONENT_INS : component MULTIPLICATION_COMPONENT
		port map(
			INPUT1 => INPUT1(16/2 - 1 downto 0),
			INPUT2 => INPUT2(16/2 - 1 downto 0),
			OUTPUT => MULTIPLICATION_COMPONENT_OUT
		); 
		
	NOT_COMPONENT_INS : component NOT_COMPONENT
		port map(
			INPUT  => INPUT1,
			OUTPUT => NOT_COMPONENT_OUT
		);
		
		
	OUTPUT <= OUTPUT_TEMP;
	
	---------------------------------- SELECTOR OUTPUTS SECTION ----------------------------------
	OUTPUT_ASSIGNMENT : with OPERATION select
		OUTPUT_TEMP <=
			AND_COMPONENT_OUT when "0000",
			OR_COMPONENT_OUT when "0001",
			XOR_COMPONENT_OUT when "0010",
			SHIFT_L_COMPONENT_OUT when "0100",
			SHIFT_R_COMPONENT_OUT when "0101",
			ADDER_SUB_COMPONENT_OUT when "0110",
			ADDER_SUB_COMPONENT_OUT when "0111",
			NOT_COMPONENT_OUT when "1000",
			MULTIPLICATION_COMPONENT_OUT when "1001",
			INPUT2 when "1010",
			
			UNKNOWN_SIG when others;
	
	
	CARRY_ASSIGNMENT : with OPERATION select
		CARRY_OUT <=
			'0' when "0000",
			'0' when "0001",
			'0' when "0010",
			'0' when "0100",
			'0' when "0101",
			ADDER_SUB_COMPONENT_CARRY when "0110",
			ADDER_SUB_COMPONENT_CARRY when "0111",
			'0' when "1000",
			'0' when "1001",
			'0' when "1010",
			
			'U' when others;
			
	ZERO_OUT <= NOR_OF_OUTPUT;
	
end architecture;