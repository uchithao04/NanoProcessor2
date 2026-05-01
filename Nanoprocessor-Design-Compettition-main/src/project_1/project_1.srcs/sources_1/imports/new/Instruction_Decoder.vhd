----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.07.2022 03:15:32
-- Design Name: 
-- Module Name: Instruction_Decoder - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:
--   Extended to 3-bit opcode [11:9]:
--     000 = ADD  Rd, Rs
--     001 = SUB  Rd, Rs
--     010 = MUL  Rd, Rs
--     011 = CMP  Rd, Rs  (no writeback -- RegEn forced to "000")
--     100 = MOVI Rd, Imm[3:0]
--     110 = JZR  Rd, Addr[2:0]  (no writeback -- RegEn forced to "000")
--
--   Register fields: Rd = Ins[8:6],  Rs = Ins[5:3]
--   AluOp = Ins[10:9]  (00=ADD, 01=SUB, 10=MUL, 11=CMP)
-- 
-- Revision:
-- Revision 0.02 - 3-bit opcode, MUL + CMP added
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Instruction_Decoder is
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
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is

begin

-- RegEn: suppress writeback for CMP (011) and JZR (110)
RegEn <= "000" when (Ins(11) = '0' and Ins(10) = '1' and Ins(9) = '1') -- CMP = 011
    else "000" when (Ins(11) = '1' and Ins(10) = '1' and Ins(9) = '0') -- JZR = 110
    else Ins(8 downto 6);

-- LoadSel: high only for MOVI (opcode 100)
LoadSel <= Ins(11) AND NOT(Ins(10)) AND NOT(Ins(9));

-- Immediate value in lower nibble
ImVal <= Ins(3 downto 0);

-- Register selects from new bit positions
RegSel1 <= Ins(8 downto 6);   -- Rd (destination / first operand)
RegSel2 <= Ins(5 downto 3);   -- Rs (second operand)

-- AluOp: bits [10:9] select ALU function (valid when opcode MSB = 0)
-- 00 = ADD,  01 = SUB,  10 = MUL,  11 = CMP
AluOp <= Ins(10 downto 9);

-- Jump address in lower 3 bits
AddressJmp <= Ins(2 downto 0);

-- Jump flag: opcode must be JZR (110) and selected register must be zero
Jmp <= Ins(11) AND Ins(10) AND NOT(Ins(9)) AND
       NOT(RegJmp(3) OR RegJmp(2) OR RegJmp(1) OR RegJmp(0));

end Behavioral;
