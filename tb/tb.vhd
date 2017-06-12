library IEEE;
use IEEE.std_logic_1164.all;

entity TB is
end entity;

architecture TB_ARCH of TB is
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
	
	signal CARRY_IN		: std_logic;
	signal INPUT1		: std_logic_vector(16 - 1 downto 0);
	signal INPUT2		: std_logic_vector(16 - 1 downto 0);
	signal OPERATION	: std_logic_vector(3 downto 0);
	signal OUTPUT		: std_logic_vector(16 - 1 downto 0);
	signal CARRY_OUT	: std_logic;
	signal ZERO_OUT		: std_logic;
	
begin
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
		
		CARRY_IN	<= '0';
		INPUT1		<= "0000000000000100", "0000000000100001" after 100 ns, "0000000000000010" after 200 ns;
		INPUT2		<= "0000000000000010", "0000000000000001" after 100 ns, "0000000000000011" after 200 ns;
		OPERATION	<= "1010", "0111" after 100 ns, "1001" after 200 ns;
end architecture;