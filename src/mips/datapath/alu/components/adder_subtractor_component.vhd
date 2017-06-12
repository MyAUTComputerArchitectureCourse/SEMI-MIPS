--------------------------------------------------------------------------------
-- Author:              Ahmad Anvari
--------------------------------------------------------------------------------
-- Create Date:         09-04-2017
-- Package Name:        alu/components
-- Module Name:         ADDER_SUBTRACTOR_COMPONENT
--------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ADDER_SUBTRACTOR_COMPONENT is
	port(
		CARRY_IN	: in  std_logic;
		INPUT1		: in  std_logic_vector(16 - 1 downto 0);
		INPUT2		: in  std_logic_vector(16 - 1 downto 0);
		IS_SUB		: in  std_logic;											-- 0 for add and 1 for subtraction
		SUM			: out std_logic_vector(16 - 1 downto 0);
		CARRY_OUT	: out std_logic;
		OVERFLOW	: out std_logic
      );
end entity;

architecture ADDER_SUBTRACTOR_COMPONENT_ARCH of ADDER_SUBTRACTOR_COMPONENT is
	component FULL_ADDER is
		port(
			CIN			: in  std_logic;
		    A			: in  std_logic;
		    B			: in  std_logic;
		    SUM       	: out std_logic;
		    CARRY     	: out std_logic
	      );
	end component;

	signal CARRIES		: std_logic_vector(16 downto 0);
	signal B_MUXED		: std_logic_vector(16 - 1 downto 0);
begin
	CARRIES(0)	<= IS_SUB xor CARRY_IN;
	
	
	with IS_SUB select B_MUXED(0) <=
		INPUT2(0) when '0',
		not INPUT2(0) when '1',
		INPUT2(0) when others;
		
	with IS_SUB select B_MUXED(1) <=
		INPUT2(1) when '0',
		not INPUT2(1) when '1',
		INPUT2(1) when others;
	
	with IS_SUB select B_MUXED(2) <=
		INPUT2(2) when '0',
		not INPUT2(2) when '1',
		INPUT2(2) when others;
		
	with IS_SUB select B_MUXED(3) <=
		INPUT2(3) when '0',
		not INPUT2(3) when '1',
		INPUT2(3) when others;
	
	with IS_SUB select B_MUXED(4) <=
		INPUT2(4) when '0',
		not INPUT2(4) when '1',
		INPUT2(4) when others;
		
	with IS_SUB select B_MUXED(5) <=
		INPUT2(5) when '0',
		not INPUT2(5) when '1',
		INPUT2(5) when others;
	
	with IS_SUB select B_MUXED(6) <=
		INPUT2(6) when '0',
		not INPUT2(6) when '1',
		INPUT2(6) when others;
		
	with IS_SUB select B_MUXED(7) <=
		INPUT2(7) when '0',
		not INPUT2(7) when '1',
		INPUT2(7) when others;
		
	with IS_SUB select B_MUXED(8) <=
		INPUT2(8) when '0',
		not INPUT2(8) when '1',
		INPUT2(8) when others;
		
	with IS_SUB select B_MUXED(9) <=
		INPUT2(9) when '0',
		not INPUT2(9) when '1',
		INPUT2(9) when others;
		
	with IS_SUB select B_MUXED(10) <=
		INPUT2(10) when '0',
		not INPUT2(10) when '1',
		INPUT2(10) when others;
		
	with IS_SUB select B_MUXED(11) <=
		INPUT2(11) when '0',
		not INPUT2(11) when '1',
		INPUT2(11) when others;
		
	with IS_SUB select B_MUXED(12) <=
		INPUT2(12) when '0',
		not INPUT2(12) when '1',
		INPUT2(12) when others;
		
	with IS_SUB select B_MUXED(13) <=
		INPUT2(13) when '0',
		not INPUT2(13) when '1',
		INPUT2(13) when others;
		
	with IS_SUB select B_MUXED(14) <=
		INPUT2(14) when '0',
		not INPUT2(14) when '1',
		INPUT2(14) when others;
		
	with IS_SUB select B_MUXED(15) <=
		INPUT2(15) when '0',
		not INPUT2(15) when '1',
		INPUT2(15) when others;
		
	
	ADDER_0: FULL_ADDER
		port map(
			CIN   => CARRIES(0),
			A     => INPUT1(0),
			B     => B_MUXED(0),
			SUM   => SUM(0),
			CARRY => CARRIES(1)
		);
		
	ADDER_1: FULL_ADDER
		port map(
			CIN   => CARRIES(1),
			A     => INPUT1(1),
			B     => B_MUXED(1),
			SUM   => SUM(1),
			CARRY => CARRIES(2)
		);
		
	ADDER_2: FULL_ADDER
		port map(
			CIN   => CARRIES(2),
			A     => INPUT1(2),
			B     => B_MUXED(2),
			SUM   => SUM(2),
			CARRY => CARRIES(3)
		);
		
	ADDER_3: FULL_ADDER
		port map(
			CIN   => CARRIES(3),
			A     => INPUT1(3),
			B     => B_MUXED(3),
			SUM   => SUM(3),
			CARRY => CARRIES(4)
		);
		
	ADDER_4: FULL_ADDER
		port map(
			CIN   => CARRIES(4),
			A     => INPUT1(4),
			B     => B_MUXED(4),
			SUM   => SUM(4),
			CARRY => CARRIES(5)
		);
		
	ADDER_5: FULL_ADDER
		port map(
			CIN   => CARRIES(5),
			A     => INPUT1(5),
			B     => B_MUXED(5),
			SUM   => SUM(5),
			CARRY => CARRIES(6)
		);
		
	ADDER_6: FULL_ADDER
		port map(
			CIN   => CARRIES(6),
			A     => INPUT1(6),
			B     => B_MUXED(6),
			SUM   => SUM(6),
			CARRY => CARRIES(7)
		);
		
	ADDER_7: FULL_ADDER
		port map(
			CIN   => CARRIES(7),
			A     => INPUT1(7),
			B     => B_MUXED(7),
			SUM   => SUM(7),
			CARRY => CARRIES(8)
		);
		
	ADDER_8: FULL_ADDER
		port map(
			CIN   => CARRIES(8),
			A     => INPUT1(8),
			B     => B_MUXED(8),
			SUM   => SUM(8),
			CARRY => CARRIES(9)
		);
		
	ADDER_9: FULL_ADDER
		port map(
			CIN   => CARRIES(9),
			A     => INPUT1(9),
			B     => B_MUXED(9),
			SUM   => SUM(9),
			CARRY => CARRIES(10)
		);
		
	ADDER_10: FULL_ADDER
		port map(
			CIN   => CARRIES(10),
			A     => INPUT1(10),
			B     => B_MUXED(10),
			SUM   => SUM(10),
			CARRY => CARRIES(11)
		);
		
	ADDER_11: FULL_ADDER
		port map(
			CIN   => CARRIES(11),
			A     => INPUT1(11),
			B     => B_MUXED(11),
			SUM   => SUM(11),
			CARRY => CARRIES(12)
		);
		
	ADDER_12: FULL_ADDER
		port map(
			CIN   => CARRIES(12),
			A     => INPUT1(12),
			B     => B_MUXED(12),
			SUM   => SUM(12),
			CARRY => CARRIES(13)
		);
		
	ADDER_13: FULL_ADDER
		port map(
			CIN   => CARRIES(13),
			A     => INPUT1(13),
			B     => B_MUXED(13),
			SUM   => SUM(13),
			CARRY => CARRIES(14)
		);
		
	ADDER_14: FULL_ADDER
		port map(
			CIN   => CARRIES(14),
			A     => INPUT1(14),
			B     => B_MUXED(14),
			SUM   => SUM(14),
			CARRY => CARRIES(15)
		);
		
	ADDER_15: FULL_ADDER
		port map(
			CIN   => CARRIES(15),
			A     => INPUT1(15),
			B     => B_MUXED(15),
			SUM   => SUM(15),
			CARRY => CARRIES(16)
		);
	
	CARRY		<= CARRIES(15) xor CARRIES(16);	
end architecture;