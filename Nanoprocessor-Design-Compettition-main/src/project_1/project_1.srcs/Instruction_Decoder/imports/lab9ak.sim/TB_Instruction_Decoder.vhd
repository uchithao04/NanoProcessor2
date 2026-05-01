----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_Instruction_Decoder - Behavioral
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

entity TB_Instruction_Decoder is
--  Port ( );
end TB_Instruction_Decoder;

architecture Behavioral of TB_Instruction_Decoder is

    Component Instruction_Decoder
    Port ( Ins        : in  STD_LOGIC_VECTOR (11 downto 0);
           RegJmp     : in  STD_LOGIC_VECTOR (3 downto 0);
           RegEn      : out STD_LOGIC_VECTOR (2 downto 0);
           LoadSel    : out STD_LOGIC;
           ImVal      : out STD_LOGIC_VECTOR (3 downto 0);
           RegSel1    : out STD_LOGIC_VECTOR (2 downto 0);
           RegSel2    : out STD_LOGIC_VECTOR (2 downto 0);
           AluOp      : out STD_LOGIC_VECTOR (1 downto 0);
           Jmp        : out STD_LOGIC;
           AddressJmp : out STD_LOGIC_VECTOR (2 downto 0));
    End Component;
    
    signal Ins : STD_LOGIC_VECTOR (11 downto 0);
    signal RegJmp, ImVal : STD_LOGIC_VECTOR (3 downto 0);
    signal RegEn, RegSel1, RegSel2, AddressJmp : STD_LOGIC_VECTOR (2 downto 0);
    signal AluOp : STD_LOGIC_VECTOR (1 downto 0);
    signal LoadSel, Jmp : STD_LOGIC;
    
begin
    UUT: Instruction_Decoder
        Port Map(
            Ins => Ins,
            RegJmp => RegJmp,
            RegEn => RegEn,
            LoadSel => LoadSel,
            ImVal => ImVal,
            RegSel1 => RegSel1,
            RegSel2 => RegSel2,
            AluOp => AluOp,
            Jmp => Jmp,
            AddressJmp => AddressJmp
        );

    Process begin
        RegJmp <= "0000";
        
        -- GunawardenaNNDeA (1101)
        -- MOVI R1, 1101 => 100 (MOVI) | 001 (R1) | 00 | 1101
        Ins <= "100001001101";
        wait for 80ns;
        
        -- GunasekaraPSI (0101)
        -- MOVI R2, 0101 => 100 (MOVI) | 010 (R2) | 00 | 0101
        Ins <= "100010000101";
        wait for 80ns;
        
        -- GunarathnaIKL (0011)
        -- MOVI R3, 0011 => 100 (MOVI) | 011 (R3) | 00 | 0011
        Ins <= "100011000011";
        wait for 80ns;
        
        -- HettiarachchiUO (0110)
        -- MOVI R4, 0110 => 100 (MOVI) | 100 (R4) | 00 | 0110
        Ins <= "100100000110";
        wait for 80ns;
        
        -- ADD R1, R2 => 000 (ADD) | 001 (R1) | 010 (R2) | 000
        Ins <= "000001010000";
        wait for 80ns;
        
        -- SUB R3, R4 => 001 (SUB) | 011 (R3) | 100 (R4) | 000
        Ins <= "001011100000";
        wait for 80ns;
        
        -- MUL R1, R3 => 010 (MUL) | 001 (R1) | 011 (R3) | 000
        Ins <= "010001011000";
        wait for 80ns;
        
        -- CMP R2, R4 => 011 (CMP) | 010 (R2) | 100 (R4) | 000
        Ins <= "011010100000";
        wait for 80ns;
        
        -- JZR R1, 111 => 110 (JZR) | 001 (R1) | 000 | 111
        Ins <= "110001000111";
        RegJmp <= "0000"; -- should jump
        wait for 80ns;
        
        Ins <= "110001000111";
        RegJmp <= "0001"; -- should NOT jump
        wait;
        
    End process;

end Behavioral;
