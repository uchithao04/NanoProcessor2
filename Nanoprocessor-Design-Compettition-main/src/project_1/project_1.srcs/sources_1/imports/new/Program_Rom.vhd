----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2022 08:50:04 AM
-- Design Name: 
-- Module Name: Program_Rom - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:
--   Demo program for extended ISA (3-bit opcode):
--
--   Addr  Binary         Encoding              Assembly       Result
--    0    100001000011   100 001 000 0011       MOVI R1, 3    R1 = 3
--    1    100010000010   100 010 000 0010       MOVI R2, 2    R2 = 2
--    2    010001010000   010 001 010 000        MUL  R1, R2   R1 = 3*2 = 6
--    3    000111001000   000 111 001 000        ADD  R7, R1   R7 = 0+6 = 6
--    4    011001010000   011 001 010 000        CMP  R1, R2   Zero=0(6≠2), OV=1(6>2)
--    5    110000000101   110 000 000 101        JZR  R0, 5    R0==0 → loop forever
--    6    000000000000   000 000 000 000        NOP (ADD R0,R0)
--    7    110000000101   110 000 000 101        JZR  R0, 5    safety loop
--
--   Opcode map: 000=ADD, 001=SUB, 010=MUL, 011=CMP, 100=MOVI, 110=JZR
--   Register fields: Rd=[8:6], Rs=[5:3]
--
-- Revision:
-- Revision 0.02 - Updated for 3-bit opcode + MUL/CMP demo
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Program_Rom is
    Port ( memory_select   : in  STD_LOGIC_VECTOR (2 downto 0);
           instruction_bus : out STD_LOGIC_VECTOR (11 downto 0));
end Program_Rom;

 architecture Behavioral of Program_Rom is
    type rom_type is array (0 to 7) of std_logic_vector(11 downto 0);
--    signal program_rom : rom_type := (
--        "100001000011",  -- Addr 0: MOVI R1, 3    (100 001 000 0011)
--        "100010000010",  -- Addr 1: MOVI R2, 2    (100 010 000 0010)
--        "010001010000",  -- Addr 2: MUL  R1, R2   (010 001 010 000) R1=6
--        "000111001000",  -- Addr 3: ADD  R7, R1   (000 111 001 000) R7=6 (shown on 7-seg)
--        "011001010000",  -- Addr 4: CMP  R1, R2   (011 001 010 000) Zero=0, OV=1
--        "110000000101",  -- Addr 5: JZR  R0, 5   (110 000 000 101) R0==0 -> loop to 5
--        "000000000000",  -- Addr 6: NOP           (000 000 000 000)
--        "110000000101"   -- Addr 7: JZR  R0, 5   (110 000 000 101) safety loop
--    );
    signal program_rom : rom_type := (
        "100001000111",  -- Addr 0: MOVI R1, 3    (100 001 000 0011)
        "100010000010",  -- Addr 1: MOVI R2, 2    (100 010 000 0010)
        "010001010000",  -- Addr 2: MUL  R1, R2   (010 001 010 000) R1=6
        "000111001000",  -- Addr 3: ADD  R7, R1   (000 111 001 000) R7=6 (shown on 7-seg)
        "011001010000",  -- Addr 4: CMP  R1, R2   (011 001 010 000) Zero=0, OV=1
        "110000000101",  -- Addr 5: JZR  R0, 5   (110 000 000 101) R0==0 -> loop to 5
        "000000000000",  -- Addr 6: NOP           (000 000 000 000)
        "110000000101"   -- Addr 7: JZR  R0, 5   (110 000 000 101) safety loop
    );
begin
    instruction_bus <= program_rom(to_integer(unsigned(memory_select)));
end Behavioral;
