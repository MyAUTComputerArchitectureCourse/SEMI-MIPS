

library IEEE;

use IEEE.std_logic_1164.all;

entity MULTIPLICATION_COMPONENT is

	
	port(
		INPUT1		: in std_logic_vector(7 downto 0);
		INPUT2		: in std_logic_vector(7 downto 0);
		OUTPUT		: out std_logic_vector(15 downto 0)
	
	);
end entity;

architecture MULTIPLICATION_COMPONENT_ARCH of MULTIPLICATION_COMPONENT is
	component ADDER_SUBTRACTOR_COMPONENT_MULTIPLIER is
		port(
			CARRY_IN	: in  std_logic;
<<<<<<< HEAD
			INPUT1		: in  std_logic_vector(15 downto 0);
			INPUT2		: in  std_logic_vector(15 downto 0);
			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
			SUM			: out std_logic_vector(15 downto 0);
=======
			INPUT1		: in  std_logic_vector(7 downto 0);
			INPUT2		: in  std_logic_vector(7 downto 0);
			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
			SUM			: out std_logic_vector(7 downto 0);
>>>>>>> ae1714fb7bec6f857c52929fe28e8d3b5bab8ccc
			CARRY		: out std_logic
	      );
	end component;
	
	type arraySignals is array (0 to 7) of std_logic;
	type arr1 is array (0 to 7) of std_logic_vector(7 downto 0);
	signal cables 	: arraySignals;
	signal khar, gav, ain, summ : arr1;

	
begin
	MAKING_IN:
	for W in 0 to 7 generate
		ANDING:
		for J in 0 to 7 generate
			gav(W)(j) <= INPUT1(J) and INPUT2(W);
		end generate;
	end generate;

	ain(0)(7) <= '0';

	KHAAR:
		for L in 0 to 6 generate
			ain(0)(L) <= gav(0)(L + 1);
		end generate;
		output(0) <= gav(0)(0);
	CONNECT:
	for I in 0 to 6 generate
<<<<<<< HEAD
		MODULE: ADDER_SUBTRACTOR_COMPONENT
=======
		MODULE: ADDER_SUBTRACTOR_COMPONENT_MULTIPLIER
>>>>>>> ae1714fb7bec6f857c52929fe28e8d3b5bab8ccc
		port map('0',gav(I + 1) ,ain(I) , '0', summ(I), cables(I));

		ain(I + 1)(7) <= cables(I);
		MAKING:
		for K in 0 to 6 generate
			ain(I + 1)(K) <= summ(I)(K + 1);
		end generate;

		output(I + 1) <= summ(I)(0);
	end generate;
	
	-- AH:
<<<<<<< HEAD
	-- for Q in 0 to COMPONENT_SIZE/2 - 1 generate
	-- 	output(Q + COMPONENT_SIZE/2) <= summ(COMPONENT_SIZE/2 - 2)(Q);
	-- end generate;
	AH:
	for Q in 0 to 6 generate
		output(Q + 8) <= summ(6)(Q + 1);
	end generate;
	output(15) <= cables(6);
=======
	-- for Q in 0 to 8 - 1 generate
	-- 	output(Q + 8) <= summ(7)(Q);
	-- end generate;
	AH:
	for Q in 0 to 6 generate
		output(Q + 8) <= summ(7)(Q + 1);
	end generate;
	output(16 - 1) <= cables(7);
>>>>>>> ae1714fb7bec6f857c52929fe28e8d3b5bab8ccc
end architecture;