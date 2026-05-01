----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_LUT_16_7 - Behavioral
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

entity TB_LUT_16_7 is
--  Port ( );
end TB_LUT_16_7;

architecture Behavioral of TB_LUT_16_7 is

Component LUT_16_7
    Port ( address : in STD_LOGIC_VECTOR (3 downto 0);
           data : out STD_LOGIC_VECTOR (6 downto 0));
End Component;

    Signal address : STD_LOGIC_VECTOR (3 downto 0);
    Signal data : STD_LOGIC_VECTOR (6 downto 0);

begin

    UUT: LUT_16_7 Port Map(
        address => address,
        data => data
    );

Process Begin

    -- GunawardenaNNDeA (1101)
    address <= "1101";
    wait for 80ns;

    -- GunasekaraPSI (0101)
    address <= "0101";
    wait for 80ns;

    -- GunarathnaIKL (0011)
    address <= "0011";
    wait for 80ns;

    -- HettiarachchiUO (0110)
    address <= "0110";
    wait for 80ns;

    -- Full address sweep
    address <= "0000";
    wait for 80ns;

    address <= "0001";
    wait for 80ns;

    address <= "0010";
    wait for 80ns;

    address <= "0100";
    wait for 80ns;

    address <= "0111";
    wait for 80ns;

    address <= "1000";
    wait for 80ns;

    address <= "1001";
    wait for 80ns;

    address <= "1010";
    wait for 80ns;

    address <= "1011";
    wait for 80ns;

    address <= "1100";
    wait for 80ns;

    address <= "1110";
    wait for 80ns;

    address <= "1111";
    wait;

End Process;

end Behavioral;
