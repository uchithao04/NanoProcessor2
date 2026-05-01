----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_Tri_State_Buffer - Behavioral
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

entity TB_Tri_State_Buffer is
--  Port ( );
end TB_Tri_State_Buffer;

architecture Behavioral of TB_Tri_State_Buffer is

Component Tri_State_Buffer
    Port ( Input  : in  STD_LOGIC;
           Enable : in  STD_LOGIC;
           Output : out STD_LOGIC);
End Component;

    Signal Input, Enable, Output : STD_LOGIC;

begin

    UUT: Tri_State_Buffer Port Map(
        Input => Input,
        Enable => Enable,
        Output => Output
    );

Process Begin

    -- GunawardenaNNDeA (1101)
    Input <= '1';
    Enable <= '1';
    wait for 80ns;

    -- GunasekaraPSI (0101)
    Input <= '1';
    Enable <= '0';
    wait for 80ns;

    -- GunarathnaIKL (0011)
    Input <= '0';
    Enable <= '1';
    wait for 80ns;

    -- HettiarachchiUO (0110)
    Input <= '0';
    Enable <= '0';
    wait;

End Process;

end Behavioral;
