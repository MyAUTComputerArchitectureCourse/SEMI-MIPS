library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity registerFile is
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
end entity;
architecture registerFile_ARCH of registerFile is
	type reg_64n16b is array (0 to 15) of STD_LOGIC_VECTOR(15 downto 0);
	signal data : reg_64n16b;
begin
	OUTPUT1 <= data(to_integer(unsigned(OUT1_ADR)));
	OUTPUT2 <= data(to_integer(unsigned(OUT2_ADR)));
  
	process(clk)
	begin
    	
    	if(CLK = '1' and CLK'event) then
    		if(W_EN = '1') then
    			data(to_integer(unsigned(IN_ADR))) <= INPUT;
    		end if;	
		end if;
    
	end process;  
  
end architecture;