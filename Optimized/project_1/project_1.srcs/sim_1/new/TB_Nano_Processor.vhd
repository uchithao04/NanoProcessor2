----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01.04.2026 20:00:00
-- Design Name: 
-- Module Name: TB_Nano_Processor - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity TB_Nano_Processor is
--  Port ( );
end TB_Nano_Processor;

architecture Behavioral of TB_Nano_Processor is

    component Nano_Processor
        Port ( Clk      : in  STD_LOGIC;
               Reset    : in  STD_LOGIC;
               Overflow : out STD_LOGIC;
               Zero     : out STD_LOGIC;
               Answer   : out STD_LOGIC_VECTOR(3 downto 0));
    end component;

    -- Signals
    signal Clk      : STD_LOGIC := '0';
    signal Reset    : STD_LOGIC := '0';
    signal Overflow : STD_LOGIC;
    signal Zero     : STD_LOGIC;
    signal Answer   : STD_LOGIC_VECTOR(3 downto 0);

    -- Clock period definition
    constant Clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: Nano_Processor
        Port map (
            Clk      => Clk,
            Reset    => Reset,
            Overflow => Overflow,
            Zero     => Zero,
            Answer   => Answer
        );

    -- Clock process definitions
    Clk_process :process
    begin
        Clk <= '0';
        wait for Clk_period/2;
        Clk <= '1';
        wait for Clk_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- Initial reset
        Reset <= '1';
        wait for 50 ns;	
        Reset <= '0';

        -- Wait for the program to execute
        -- Program logic:
        -- 0: MOVI R1, 3
        -- 1: MOVI R2, 2
        -- 2: MUL  R1, R2 -> R1=6
        -- 3: ADD  R7, R1 -> R7=6
        -- 4: CMP  R1, R2 -> Result=6-2, Zero=0, Overflow=1
        -- 5: JZR  R0, 5  -> Loops here
        
        wait for 500 ns;

        -- Check results (Answer should be 6, Overflow should be 1)
        assert (Answer = "0110") report "Test Failed: Answer should be 6" severity error;
        assert (Overflow = '1')  report "Test Failed: Overflow should be 1 (6 > 2)" severity error;
        
        report "Simulation Finished Successfully! Answer is " & integer'image(to_integer(unsigned(Answer)));

        wait;
    end process;

end Behavioral;
