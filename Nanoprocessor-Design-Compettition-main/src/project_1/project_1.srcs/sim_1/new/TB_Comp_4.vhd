----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_Comp_4 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Group Members:
-- GunawardenaNNDeA --- 240205A --- 111010101001001101 --- Last 4 bits: 1101
-- GunasekaraPSI --- 240197X --- 111010101001000101 --- Last 4 bits: 0101
-- GunarathnaIKL --- 240195N --- 111010101001000011 --- Last 4 bits: 0011
-- HettiarachchiUO --- 240230U --- 111010101001100110 --- Last 4 bits: 0110
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity TB_Comp_4 is
--  Port ( );
end TB_Comp_4;

architecture Behavioral of TB_Comp_4 is

Component Comp_4
    Port ( A       : in  STD_LOGIC_VECTOR (3 downto 0);
           B       : in  STD_LOGIC_VECTOR (3 downto 0);
           Equal   : out STD_LOGIC;
           Greater : out STD_LOGIC;
           Result  : out STD_LOGIC_VECTOR (3 downto 0));
End Component;

    Signal A, B, Result : STD_LOGIC_VECTOR (3 downto 0);
    Signal Equal, Greater : STD_LOGIC;

begin

    UUT: Comp_4 Port Map(
        A => A,
        B => B,
        Equal => Equal,
        Greater => Greater,
        Result => Result
    );

Process Begin

    -- GunawardenaNNDeA (1101) -- A > B
    A <= "1101";
    B <= "0010";
    wait for 80ns;

    -- GunasekaraPSI (0101) -- A == B
    A <= "0101";
    B <= "0101";
    wait for 80ns;

    -- GunarathnaIKL (0011) -- A < B
    A <= "0011";
    B <= "1100";
    wait for 80ns;

    -- HettiarachchiUO (0110) -- A > B
    A <= "0110";
    B <= "0101";
    wait for 80ns;

    -- Equal test
    A <= "1111";
    B <= "1111";
    wait for 80ns;

    -- Zero test
    A <= "0000";
    B <= "0000";
    wait for 80ns;
    wait;

End Process;

end Behavioral;
