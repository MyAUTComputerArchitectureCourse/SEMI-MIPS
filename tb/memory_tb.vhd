library IEEE;
use IEEE.std_logic_1164.all;

entity MEMORY_TB is
end entity;

architecture MEMORY_TB_ARCH of MEMORY_TB is
  signal clock  : std_logic := '0';
  signal we : std_logic;
  signal datain, dataout : std_logic_vector(15 downto 0);
  signal address : std_logic_vector(7 downto 0);
  component MEMORY is
    port (
      clock   : in  std_logic;
      we      : in  std_logic;
      address : in  std_logic_vector(7 downto 0);
      datain  : in  std_logic_vector(15 downto 0);
      dataout : out std_logic_vector(15 downto 0)
    );
  end component;

  begin
    memoryIns : MEMORY port map(clock, we, address, datain, dataout);
      
    clock <= not clock after 100 ns;
    we <= '0', '1' after 90 ns, '0' after 600 ns;
    address <= (OTHERS => '0');
    datain <= (OTHERS => '0'), "0000000000000001" after 300 ns, (OTHERS => '0') after 450 ns;
end architecture;