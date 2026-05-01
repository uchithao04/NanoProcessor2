----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_HA - Behavioral
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

entity TB_HA is
--  Port ( );
end TB_HA;

architecture Behavioral of TB_HA is

Component HA
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           C : out STD_LOGIC;
           S : out STD_LOGIC);
End Component;

Signal A, B, C, S : STD_LOGIC;

begin

    UUT: HA Port Map(
        A => A,
        B => B,
        C => C,
        S => S
    );



Process Begin

    A <= '0';
    B <= '0';
    wait for 80ns;


    A <= '0';
    B <= '1';
    wait for 80ns; 

    A <= '1';
    B <= '0';
    wait for 80ns;

    A <= '1';
    B <= '1';
    wait for 80ns;

    wait;
End Process;

end Behavioral;
