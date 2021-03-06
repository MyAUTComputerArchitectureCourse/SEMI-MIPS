

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
	component ADDER_SUBTRACTOR_COMPONENT is
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(15 downto 0);
			INPUT2		: in  std_logic_vector(15 downto 0);
			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
			SUM			: out std_logic_vector(15 downto 0);
			CARRY_OUT	: out std_logic;
			OVERFLOW	: out std_logic
	      );
	end component;
	
	type arraySignals is array (0 to 7) of std_logic;
	type arr_8_8 is array (0 to 7) of std_logic_vector(7 downto 0);
	type arr_8_16 is array (0 to 7) of std_logic_vector(15 downto 0);
	signal cables 	: arraySignals;
	signal khar, gav, ain, summ : arr_8_8;
	signal gav16, ain16, summ16 : arr_8_16;

	
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
	  gav16(I + 1) <= "00000000" & gav(I + 1);
	  ain16(I) <= "00000000" & ain(I);
	  summ(I) <= summ16(I)(7 downto 0);
		MODULE: ADDER_SUBTRACTOR_COMPONENT
		port map('0',gav16(I + 1) ,ain16(I) , '0', summ16(I), cables(I), open);

		ain(I + 1)(7) <= cables(I);
		MAKING:
		for K in 0 to 6 generate
			ain(I + 1)(K) <= summ(I)(K + 1);
		end generate;

		output(I + 1) <= summ(I)(0);
	end generate;
	
	-- AH:
	-- for Q in 0 to COMPONENT_SIZE/2 - 1 generate
	-- 	output(Q + COMPONENT_SIZE/2) <= summ(COMPONENT_SIZE/2 - 2)(Q);
	-- end generate;
	AH:
	for Q in 0 to 6 generate
		output(Q + 8) <= summ(6)(Q + 1);
	end generate;
	output(15) <= cables(6);
end architecture;
