library IEEE;

use IEEE.std_logic_1164.all;

entity TB is
end TB;

architecture TB_ARCH of TB is
	component ALU is
		generic(
			COMPONENT_SIZE  : integer
			);
		port(
			CARRY_IN	: in  std_logic;
			INPUT1		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			INPUT2		: in  std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			OPERATION	: in  std_logic_vector(3 downto 0);
			OUTPUT		: out std_logic_vector(COMPONENT_SIZE - 1 downto 0);
			CARRY_OUT	: out std_logic;
			ZERO_OUT	: out std_logic
	      );
	end component;
	
	signal a, b, output	: std_logic_vector(15 downto 0);
	signal op			: std_logic_vector(3 downto 0);
	signal carry		: std_logic;
	signal zero			: std_logic;
	signal cin			: std_logic;
	
begin

	ALU_INS: ALU
		generic map(
			COMPONENT_SIZE => 16
		)
		port map(
			CARRY_IN  => cin,
			INPUT1    => a,
			INPUT2    => b,
			OPERATION => op,
			OUTPUT    => OUTPUT,
			CARRY_OUT => carry,
			ZERO_OUT  => zero
		);
	
	process
	begin
		cin <=  '1';
		a	<=	"0000000011011001";
		b	<=	"0000000000011001";
		op	<=	"0110";						-- Add
		
		wait for 1 ns;
		
		
		a	<=	"0000100000010010";
		b	<=	"0001000000010001";
		op	<=	"0000";						-- And
		
		wait for 1 ns;
		
		
		a	<=	"0000100000010010";
		b	<=	"0001000000000001";
		op	<=	"0000";						-- Another And :D
		
		wait for 1 ns;
		
		a	<=	"0001111010010010";
		b	<=	"0001000010010001";
		op	<=	"0001";						-- Or
		
		wait for 1 ns;
		
		a	<=	"1001000000010010";
		b	<=	"0101000000010001";
		op	<=	"0010";						-- Xor
		wait for 1 ns;
		
		a	<=	"0001000000010010";
		b	<=	"0001000000010001";
		op	<=	"0011";						-- Compare
		wait for 1 ns;
		
		a	<=	"0001000000010010";
		b	<=	"0001000000010001";
		op	<=	"0100";						-- Shift Left
		wait for 1 ns;
		
		a	<=	"0001000000010010";
		b	<=	"0001000000010001";
		op	<=	"0101";						-- Shift Right
		wait for 1 ns;
		
		a	<=	"0000000000110010";
		b	<=	"0000000000010001";
		op	<=	"0111";						-- Subtract
		wait for 1 ns;
		
		cin <=  '1';
		a	<=	"0000000000010011";
		b	<=	"0000000000010011";
		op	<=	"0111";						-- Other Subtract :D
		wait for 1 ns;
		
		a	<=	"1111000001011011";
		b	<=	"0001000001010001";
		op	<=	"0000";
		wait for 1 ns;						-- Two's complement
		
		a	<=	"0000000000001011";
		b	<=	"0000000001010001";
		op	<=	"1001";
		wait for 1 ns;						-- Multiplication

		wait for 1 ns;
		assert false report "Reached end of test";
		wait;
	end process;
end TB_ARCH;