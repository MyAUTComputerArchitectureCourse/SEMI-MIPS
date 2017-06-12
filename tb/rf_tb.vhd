library IEEE;
use IEEE.std_logic_1164.all;

entity RF_TB is
end entity;

architecture RF_TB_ARCH of RF_TB is
  signal clock  : std_logic := '0';
  signal we : std_logic;
  signal input, output1, output2 : std_logic_vector(15 downto 0);
  signal inAdr, outAdr1, outAdr2 : std_logic_vector(3 downto 0);
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

  begin
    registerFileIns : registerFile port map(clock, we, input, inAdr, outAdr1, outAdr2, output1, output2);
      
    clock <= not clock after 100 ns;
    we <= '0', '1' after 90 ns, '0' after 500 ns;
    input <= "0000000000001110", "1010101010101010" after 290 ns;
    inAdr <= "0001", "0111" after 290 ns;
    outAdr1 <= "0001";
    outAdr2 <= "0111";
    
end architecture;

