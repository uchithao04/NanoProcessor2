----------------------------------------------------------------------------------
-- Module Name: Mul_4 - Behavioral
-- Description: 4-bit unsigned multiplier using partial products.
--              Returns lower 4 bits of A*B as result P.
--              Sets Overflow if upper nibble is non-zero.
--              Sets Zero if product is zero.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Mul_4 is
    Port ( A        : in  STD_LOGIC_VECTOR (3 downto 0);
           B        : in  STD_LOGIC_VECTOR (3 downto 0);
           P        : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Zero     : out STD_LOGIC);
end Mul_4;

architecture Behavioral of Mul_4 is

    -- Partial products: PP_i = A shifted left by i, masked by B(i)
    signal PP0 : STD_LOGIC_VECTOR (7 downto 0);
    signal PP1 : STD_LOGIC_VECTOR (7 downto 0);
    signal PP2 : STD_LOGIC_VECTOR (7 downto 0);
    signal PP3 : STD_LOGIC_VECTOR (7 downto 0);
    signal product : STD_LOGIC_VECTOR (7 downto 0);

begin
    -- PP0 = A * B(0)  (no shift)
    PP0 <= "0000" & A                        when B(0) = '1' else "00000000";
    -- PP1 = A * B(1)  (shift left 1)
    PP1 <= "000"  & A & "0"                  when B(1) = '1' else "00000000";
    -- PP2 = A * B(2)  (shift left 2)
    PP2 <= "00"   & A & "00"                 when B(2) = '1' else "00000000";
    -- PP3 = A * B(3)  (shift left 3)
    PP3 <= "0"    & A & "000"                when B(3) = '1' else "00000000";

    -- Sum all partial products
    product <= STD_LOGIC_VECTOR(
                   unsigned(PP0) + unsigned(PP1) +
                   unsigned(PP2) + unsigned(PP3));

    P        <= product(3 downto 0);
    Overflow <= '1' when product(7 downto 4) /= "0000" else '0';
    Zero     <= '1' when product = "00000000" else '0';

end Behavioral;
