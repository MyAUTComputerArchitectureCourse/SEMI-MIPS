library IEEE;

use IEEE.std_logic_1164.all;

entity TB is
end TB;

-- architecture TB_ARCH of TB is 

-- 	component ADDER_SUBTRACTOR_COMPONENT is
-- 		generic(
-- 			COMPONENT_SIZE  : integer
-- 			);
-- 		port(
-- 			CARRY_IN	: in  std_logic;
-- 			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
-- 			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
-- 			IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
-- 			SUM			: out std_logic_vector(COMPONENT_SIZE - 1 downto 0);
-- 			CARRY		: out std_logic
-- 		);
-- 	end component;

-- 	signal outs : std_logic_vector(15 downto 0);
-- 	signal cc : std_logic;

-- 	begin
-- 		ADDER: ADDER_SUBTRACTOR_COMPONENT
-- 		generic map(16)
-- 		port map('0', "0000000011011001", "0000000000011001", '0', outs, cc);

-- 		process
-- 		begin
-- 			wait for 10 ns;
-- 			assert false report "Reached end of test";
-- 			wait;
-- 		end process;
-- end architecture;

architecture TB_ARCH of TB is
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
	
	signal a, b: std_logic_vector(7 downto 0);
	signal c : std_logic_vector(15 downto 0);

	
begin

	ADDRESS: MULTIPLICATION_COMPONENT
	generic map(16)
	port map(a, b, c);

	process
	begin
		a <= "11011001";
		b <= "00011001";
		wait for 10 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end TB_ARCH;