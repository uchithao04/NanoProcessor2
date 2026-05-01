----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_RCA_4 - Behavioral
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

entity TB_RCA_4 is
--  Port ( );
end TB_RCA_4;

architecture Behavioral of TB_RCA_4 is

Component RCA_4
    Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
           B : in STD_LOGIC_VECTOR (3 downto 0);
           C_in : in STD_LOGIC;
           S : out STD_LOGIC_VECTOR (3 downto 0);
           C_out : out STD_LOGIC;
           Overflow : out STD_LOGIC);
End Component;

    Signal C_in, C_out, Overflow : STD_LOGIC;
    Signal A, B, S : STD_LOGIC_VECTOR (3 downto 0);

begin

    UUT: RCA_4 Port Map(
        A => A,
        B => B,
        C_in => C_in,
        S => S,
        C_out => C_out,
        Overflow => Overflow
    );

Process Begin

    -- GunawardenaNNDeA (1101)
    A <= "1101";
    B <= "0010";
    C_in <= '0';
    wait for 80ns;

    C_in <= '1';
    wait for 80ns;

    -- GunasekaraPSI (0101)
    A <= "0101";
    B <= "0011";
    C_in <= '0';
    wait for 80ns;

    C_in <= '1';
    wait for 80ns;

    -- GunarathnaIKL (0011)
    A <= "0011";
    B <= "1100";
    C_in <= '0';
    wait for 80ns;

    C_in <= '1';
    wait for 80ns;

    -- HettiarachchiUO (0110)
    A <= "0110";
    B <= "0101";
    C_in <= '0';
    wait for 80ns;

    C_in <= '1';
    wait for 80ns;

    A <= "1111";
    B <= "1111";
    C_in <= '1';
    wait for 80ns;

    A <= "0000";
    B <= "0000";
    C_in <= '0';
    wait;

End Process;

end Behavioral;
