library IEEE;

use IEEE.std_logic_1164.all;

ENTITY STATUS_REGISTER IS
    PORT (
        carryOut, carryToLast : IN std_logic;
        data : IN std_logic_vector (15 DOWNTO 0);
        carry, zero, sign, parity, borrow, overflow : OUT std_logic
    );
END STATUS_REGISTER;

ARCHITECTURE STATUS_REGISTER_ARCH OF STATUS_REGISTER IS BEGIN
    sign <= data(15);
    carry <= carryOut;
    zero <= not (data(0) or data(1) or data(2) or data(3) or data(4) or data(5) or 
                data(6) or data(7) or data(8) or data(9) or data(10) or 
                data(11) or data(12) or data(13) or data(14) or data(15));
    borrow <= data(15);
    parity <= data(0) xor data(1) xor data(2) xor data(3) xor data(4) xor data(5) xor 
                data(6) xor data(7) xor data(8) xor data(9) xor data(10) xor 
                data(11) xor data(12) xor data(13) xor data(14) xor data(15);
                
    overflow <= carryOut xor carryToLast;
END STATUS_REGISTER_ARCH;
