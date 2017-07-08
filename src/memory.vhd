library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.Numeric_Std.all;

entity MEMORY is
  port (
    clk   : in  std_logic;
    we      : in  std_logic;
    re		: in  std_logic;
    address : in  std_logic_vector(7 downto 0);
    datain  : in  std_logic_vector(15 downto 0);
    dataout : out std_logic_vector(15 downto 0)
  );
end entity;

architecture MEMORY_ARCH of MEMORY is

   type ram_type is array (0 to 63) of std_logic_vector(15 downto 0);
   signal ram : ram_type;
   signal read_address : std_logic_vector(7 downto 0);

begin

  RamProc: process(clk) is

  begin
  	
  	ram(0) <= "1110000000010000";
	ram(1) <= "1110000100010001";
	ram(2) <= "0000000000010010";
	ram(3) <= "1101001000000000";
	
	
	ram(32) <= "0000000000000010";
	ram(33) <= "0000000000000101";
		
    if clk'event and clk = '1' then
      if we = '1' then
        ram(to_integer(unsigned(address))) <= datain;
      end if;
      read_address <= address;
    end if;
	end process RamProc;
	
	OUTPUT : with re & we select
		dataout <=
			ram(to_integer(unsigned(address))) when "10",
			"ZZZZZZZZZZZZZZZZ" when "00",
			"ZZZZZZZZZZZZZZZZ" when "01	",
			"ZZZZZZZZZZZZZZZZ" when others;

end architecture;