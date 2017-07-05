entity SEMI_MIPS is
  port (
    clk   			: in  std_logic;
    we      		: out  std_logic;
    address 		: out  std_logic_vector(7 downto 0);
    memory_in		: in  std_logic_vector(15 downto 0);
    memory_out		: out  std_logic_vector(15 downto 0)
  );
end entity;

architecture ALU_ARCH of ALU is
begin
end architecture;
	