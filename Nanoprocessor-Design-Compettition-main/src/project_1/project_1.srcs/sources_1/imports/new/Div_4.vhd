----------------------------------------------------------------------------------
-- Module Name: Div_4 - Behavioral
-- Description: 4-bit unsigned divider.
--              Returns Quotient Q = A / B.
--              Sets Overflow if B is zero (Division by zero).
--              Sets Zero if quotient is zero.
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Div_4 is
    Port ( A        : in  STD_LOGIC_VECTOR (3 downto 0);
           B        : in  STD_LOGIC_VECTOR (3 downto 0);
           Q        : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Zero     : out STD_LOGIC);
end Div_4;

architecture Behavioral of Div_4 is
begin
    process(A, B)
        variable quot : unsigned(3 downto 0);
    begin
        if (B = "0000") then
            quot := "0000";
            Overflow <= '1'; -- Division by zero
        else
            quot := unsigned(A) / unsigned(B);
            Overflow <= '0';
        end if;
        
        Q <= std_logic_vector(quot);
        
        if (quot = "0000") then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;
end Behavioral;
