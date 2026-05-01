----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_Mux_4_2_to_1 - Behavioral
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

entity TB_Mux_4_2_to_1 is
--  Port ( );
end TB_Mux_4_2_to_1;

architecture Behavioral of TB_Mux_4_2_to_1 is

Component Mux_4_2_to_1
    Port ( I0 : in STD_LOGIC_VECTOR (3 downto 0);
           I1 : in STD_LOGIC_VECTOR (3 downto 0);
           S : in STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (3 downto 0));
End Component;

    Signal S : STD_LOGIC;
    Signal I0, I1, Y : STD_LOGIC_VECTOR (3 downto 0);

begin

    UUT: Mux_4_2_to_1
        Port Map(
            I0 => I0,
            I1 => I1,
            S => S,
            Y => Y
        );

    Process Begin

        -- GunawardenaNNDeA (1101)
        I0 <= "1101";
        I1 <= "0010";
        S <= '0';
        wait for 80ns;

        S <= '1';
        wait for 80ns;

        -- GunasekaraPSI (0101)
        I0 <= "0101";
        I1 <= "1010";
        S <= '0';
        wait for 80ns;

        S <= '1';
        wait for 80ns;

        -- GunarathnaIKL (0011)
        I0 <= "0011";
        I1 <= "1100";
        S <= '0';
        wait for 80ns;

        S <= '1';
        wait for 80ns;

        -- HettiarachchiUO (0110)
        I0 <= "0110";
        I1 <= "1001";
        S <= '0';
        wait for 80ns;

        S <= '1';
        wait;

    End Process;

end Behavioral;
