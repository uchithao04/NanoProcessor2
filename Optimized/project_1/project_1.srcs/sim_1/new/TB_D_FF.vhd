----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_D_FF - Behavioral
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

entity TB_D_FF is
--  Port ( );
end TB_D_FF;

architecture Behavioral of TB_D_FF is

Component D_FF
    Port ( D : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Res : in STD_LOGIC;
           Q : out STD_LOGIC);
End Component;

    Signal D, Clk, Res, Q : STD_LOGIC := '0';

begin

    UUT: D_FF Port Map(
        D => D,
        Clk => Clk,
        Res => Res,
        Q => Q
    );

    -- Clock generation process
    process begin
        wait for 35ns;
        Clk <= NOT(Clk);
    end process;

    -- Stimulus process
    Process Begin

        -- Reset test
        Res <= '1';
        D <= '0';
        wait for 100ns;

        -- GunawardenaNNDeA (1101)
        Res <= '0';
        D <= '1';
        wait for 80ns;

        -- GunasekaraPSI (0101)
        D <= '0';
        wait for 80ns;

        -- GunarathnaIKL (0011)
        D <= '1';
        wait for 80ns;

        -- HettiarachchiUO (0110)
        D <= '0';
        wait for 80ns;

        -- Reset while D is high
        D <= '1';
        wait for 80ns;

        Res <= '1';
        wait for 80ns;

        Res <= '0';
        D <= '0';
        wait;

    End Process;

end Behavioral;
