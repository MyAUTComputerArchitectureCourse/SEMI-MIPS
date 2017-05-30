library IEEE;

use IEEE.std_logic_1164.all;

entity TB is
end TB;

architecture TB_ARCH of TB is
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

	signal a, b: std_logic_vector(15 downto 0);
	signal z, c: std_logic;

	begin
	MODULE: COMPARISON_COMPONENT
	generic map (16)
	port map(a, b, z, c);

	process
	begin
		a <= "0010100000000011";
		b <= "0001111111111101";

		wait for 10 ns;

		a <= "0010100000000000";
		b <= "0010100000000000";

		wait for 10 ns;

		a <= "0010100000000000";
		b <= "0011100000000001";

		wait for 10 ns;

		assert false report "Reached end of test";
		wait;

	end process;
	

end architecture;

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 

-- architecture TB_ARCH of TB is
-- 	component BIT_COMPARATOR_COMPONENT is
-- 		port(
-- 			INPUT1   : in std_logic;
-- 			INPUT2   : in std_logic;
-- 			E_IN     : in std_logic;
-- 			L_IN     : in std_logic;
-- 			G_IN     : in std_logic;
-- 			EQUAL    : out std_logic;
-- 			GREATER  : out std_logic;
-- 			LOWER    : out std_logic
-- 		);
-- 	end component;

-- 	signal a, b, ei, li, gi, e, l, g: std_logic;
-- begin
-- 	MODULE: BIT_COMPARATOR_COMPONENT
--        	port map(a, b, ei, li, gi, e, g, l);
	
-- 	process
-- 	begin
-- 		a <= '0';
-- 		b <= '0';
-- 		ei <= '1';
-- 		li <= '0';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '0';
-- 		b <= '0';
-- 		ei <= '0';
-- 		li <= '1';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '0';
-- 		b <= '0';
-- 		ei <= '0';
-- 		li <= '0';
-- 		gi <= '1';

-- 		wait for 10 ns;

-- 		-- -- --
-- 		a <= '1';
-- 		b <= '0';
-- 		ei <= '1';
-- 		li <= '0';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '1';
-- 		b <= '0';
-- 		ei <= '0';
-- 		li <= '1';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '1';
-- 		b <= '0';
-- 		ei <= '0';
-- 		li <= '0';
-- 		gi <= '1';

-- 		wait for 10 ns;

-- 		-- -- -- 
-- 		a <= '0';
-- 		b <= '1';
-- 		ei <= '1';
-- 		li <= '0';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '0';
-- 		b <= '1';
-- 		ei <= '0';
-- 		li <= '1';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '0';
-- 		b <= '1';
-- 		ei <= '0';
-- 		li <= '0';
-- 		gi <= '1';

-- 		wait for 10 ns;

-- 		-- -- -- -- -- 
-- 		a <= '1';
-- 		b <= '1';
-- 		ei <= '1';
-- 		li <= '0';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '1';
-- 		b <= '1';
-- 		ei <= '0';
-- 		li <= '1';
-- 		gi <= '0';

-- 		wait for 10 ns;

-- 		a <= '1';
-- 		b <= '1';
-- 		ei <= '0';
-- 		li <= '0';
-- 		gi <= '1';

-- 		wait for 10 ns;

-- 		assert false report "Reached end of test";
-- 		wait;
-- 	end process;
-- end TB_ARCH;
