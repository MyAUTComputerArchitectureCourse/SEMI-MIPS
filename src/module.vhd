library IEEE;
use IEEE.std_logic_1164.all;

entity SEMI_MIPS_MODULE is
	port(
		CLK : std_logic;
		EXTERNAL_RESET : std_logic
	);
end entity;

architecture RTL of SEMI_MIPS_MODULE is
	component SEMI_MIPS is
	  port (
	    clk   			: in  std_logic;
	    external_reset	: in std_logic;
	    we      		: out  std_logic;
	    re				: out std_logic;
	    address 		: out  std_logic_vector(7 downto 0);
	    memory_in		: in  std_logic_vector(15 downto 0);
	    memory_out		: out  std_logic_vector(15 downto 0)
	  );
	end component;
	
	component MEMORY is
	  port (
	    clk   : in  std_logic;
	    we      : in  std_logic;
	    re      : in  std_logic;
	    address : in  std_logic_vector(7 downto 0);
	    datain  : in  std_logic_vector(15 downto 0);
	    dataout : out std_logic_vector(15 downto 0)
	  );
	end component;
	
	signal we, re : std_logic;
	signal address : std_logic_vector(7 downto 0);
	
	signal memory_in, memory_out : std_logic_vector(15 downto 0);
	
begin
	
	MEMORY_inst : component MEMORY
		port map(
			clk     => clk,
			we      => we,
			re		=> re,
			address => address,
			datain  => memory_out,
			dataout => memory_in
		);
		
	SEMI_MIPS_inst : component SEMI_MIPS
		port map(
			clk            => clk,
			external_reset => external_reset,
			we             => we,
			re             => re,
			address        => address,
			memory_in      => memory_in,
			memory_out     => memory_out
		);
		

end architecture RTL;
