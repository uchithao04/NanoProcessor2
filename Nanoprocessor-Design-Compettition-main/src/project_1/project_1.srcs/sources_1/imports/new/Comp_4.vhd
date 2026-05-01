----------------------------------------------------------------------------------
-- Module Name: Comp_4 - Behavioral
-- Description: 4-bit unsigned comparator.
--              Equal   = 1 if A == B  (maps to processor Zero flag)
--              Greater = 1 if A  > B  (maps to processor Overflow flag)
--              Result  = always "0000" (CMP has no register write-back)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Comp_4 is
    Port ( A       : in  STD_LOGIC_VECTOR (3 downto 0);
           B       : in  STD_LOGIC_VECTOR (3 downto 0);
           Equal   : out STD_LOGIC;
           Greater : out STD_LOGIC;
           Result  : out STD_LOGIC_VECTOR (3 downto 0));
end Comp_4;

architecture Behavioral of Comp_4 is
begin
    Equal   <= '1' when A = B                            else '0';
    Greater <= '1' when unsigned(A) > unsigned(B)        else '0';
    Result  <= "0000";
end Behavioral;
