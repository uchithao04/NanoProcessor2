----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07/27/2022 09:04:19 AM
-- Design Name: 
-- Module Name: Nano_Processor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description:
--   Extended ISA with 3-bit opcode [11:9]:
--     000 = ADD,  001 = SUB,  010 = MUL,  011 = CMP
--     100 = MOVI, 110 = JZR
--   New components: Mul_4, Comp_4
--   ALU result and flags muxed by AluOp[1:0]
--
-- Revision:
-- Revision 0.02 - MUL and CMP instructions added
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Nano_Processor is
    Port ( Clk      : in  STD_LOGIC;
           Reset    : in  STD_LOGIC;
           Overflow : out STD_LOGIC;
           Zero     : out STD_LOGIC;
           Answer   : out STD_LOGIC_VECTOR(3 downto 0));
end Nano_Processor;

architecture Behavioral of Nano_Processor is

component Instruction_Decoder
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
end component;

component Reg_Bank
    Port ( En  : in  STD_LOGIC_VECTOR (2 downto 0);
           Clk : in  STD_LOGIC;
           Res : in  STD_LOGIC;
           D   : in  STD_LOGIC_VECTOR (3 downto 0);
           Q0  : out STD_LOGIC_VECTOR (3 downto 0);
           Q1  : out STD_LOGIC_VECTOR (3 downto 0);
           Q2  : out STD_LOGIC_VECTOR (3 downto 0);
           Q3  : out STD_LOGIC_VECTOR (3 downto 0);
           Q4  : out STD_LOGIC_VECTOR (3 downto 0);
           Q5  : out STD_LOGIC_VECTOR (3 downto 0);
           Q6  : out STD_LOGIC_VECTOR (3 downto 0);
           Q7  : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Mux_4_8_to_1
    Port ( I0 : in STD_LOGIC_VECTOR (3 downto 0);
           I1 : in STD_LOGIC_VECTOR (3 downto 0);
           I2 : in STD_LOGIC_VECTOR (3 downto 0);
           I3 : in STD_LOGIC_VECTOR (3 downto 0);
           I4 : in STD_LOGIC_VECTOR (3 downto 0);
           I5 : in STD_LOGIC_VECTOR (3 downto 0);
           I6 : in STD_LOGIC_VECTOR (3 downto 0);
           I7 : in STD_LOGIC_VECTOR (3 downto 0);
           S  : in STD_LOGIC_VECTOR (2 downto 0);
           Y  : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component Mux_3_2_to_1
    Port ( I0 : in  STD_LOGIC_VECTOR (2 DOWNTO 0);
           I1 : in  STD_LOGIC_VECTOR (2 DOWNTO 0);
           S  : in  STD_LOGIC;
           Y  : out STD_LOGIC_VECTOR (2 DOWNTO 0));
end component;

component Mux_4_2_to_1
    Port ( I0 : in  STD_LOGIC_VECTOR (3 DOWNTO 0);
           I1 : in  STD_LOGIC_VECTOR (3 DOWNTO 0);
           S  : in  STD_LOGIC;
           Y  : out STD_LOGIC_VECTOR (3 DOWNTO 0));
end component;

component Program_Counter
    Port ( D   : in  STD_LOGIC_VECTOR (2 downto 0);
           Clk : in  STD_LOGIC;
           Res : in  STD_LOGIC;
           Q   : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component Add_Sub_4
    Port ( Control  : in  STD_LOGIC;
           A        : in  STD_LOGIC_VECTOR (3 downto 0);
           B        : in  STD_LOGIC_VECTOR (3 downto 0);
           S        : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Zero     : out STD_LOGIC);
end component;

component Adder_3
    Port ( A : in  STD_LOGIC_VECTOR (2 downto 0);
           S : out STD_LOGIC_VECTOR (2 downto 0));
end component;

component Program_Rom
    Port ( memory_select  : in  STD_LOGIC_VECTOR (2 downto 0);
           instruction_bus : out STD_LOGIC_VECTOR (11 downto 0));
end component;

component Slow_Clk
    Port ( Clk_in  : in  STD_LOGIC;
           Clk_out : out STD_LOGIC);
end component;

-- *** NEW: Mul_4 and Comp_4 ***
component Mul_4
    Port ( A        : in  STD_LOGIC_VECTOR (3 downto 0);
           B        : in  STD_LOGIC_VECTOR (3 downto 0);
           P        : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Zero     : out STD_LOGIC);
end component;

component Comp_4
    Port ( A       : in  STD_LOGIC_VECTOR (3 downto 0);
           B       : in  STD_LOGIC_VECTOR (3 downto 0);
           Equal   : out STD_LOGIC;
           Greater : out STD_LOGIC;
           Result  : out STD_LOGIC_VECTOR (3 downto 0));
end component;

-- Instruction and data buses
signal I                  : STD_LOGIC_VECTOR (11 downto 0);
signal M, mux1_out, mux2_out : STD_LOGIC_VECTOR (3 downto 0);
signal D0,D1,D2,D3,D4,D5,D6,D7 : STD_LOGIC_VECTOR (3 downto 0);

-- Control signals
signal register_enable    : STD_LOGIC_VECTOR (2 downto 0);
signal register_select_1  : STD_LOGIC_VECTOR (2 downto 0);
signal register_select_2  : STD_LOGIC_VECTOR (2 downto 0);
signal address_to_jump    : STD_LOGIC_VECTOR (2 downto 0);
signal adder_out          : STD_LOGIC_VECTOR (2 downto 0);
signal memory_select      : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal pc_in              : STD_LOGIC_VECTOR (2 downto 0) := "000";
signal clock_out          : STD_LOGIC;
signal load_select        : STD_LOGIC;
signal jump_flag          : STD_LOGIC;
signal alu_op             : STD_LOGIC_VECTOR (1 downto 0);  -- 00=ADD,01=SUB,10=MUL,11=CMP

-- ALU result signals
signal add_sub_out        : STD_LOGIC_VECTOR (3 downto 0);
signal mul_out            : STD_LOGIC_VECTOR (3 downto 0);
signal comp_out           : STD_LOGIC_VECTOR (3 downto 0);
signal alu_result         : STD_LOGIC_VECTOR (3 downto 0);
signal immediate_value    : STD_LOGIC_VECTOR (3 downto 0);

-- Flag signals per ALU unit
signal addsub_overflow    : STD_LOGIC;
signal addsub_zero        : STD_LOGIC;
signal mul_overflow       : STD_LOGIC;
signal mul_zero           : STD_LOGIC;
signal comp_equal         : STD_LOGIC;
signal comp_greater       : STD_LOGIC;

-- Muxed flags driven to outputs
signal alu_zero           : STD_LOGIC;
signal alu_overflow       : STD_LOGIC;

begin

    -- -------------------------------------------------------
    -- Clock divider
    -- -------------------------------------------------------
    slow_clock_0 : Slow_Clk
        port map ( Clk_in  => Clk,
                   Clk_out => clock_out);

    -- -------------------------------------------------------
    -- Instruction Decoder (3-bit opcode)
    -- -------------------------------------------------------
    Instruction_Decoder_0 : Instruction_Decoder
        port map ( Ins        => I,
                   RegJmp     => mux1_out,
                   RegEn      => register_enable,
                   LoadSel    => load_select,
                   ImVal      => immediate_value,
                   RegSel1    => register_select_1,
                   RegSel2    => register_select_2,
                   AluOp      => alu_op,
                   Jmp        => jump_flag,
                   AddressJmp => address_to_jump);

    -- -------------------------------------------------------
    -- Register Bank (8 x 4-bit registers)
    -- -------------------------------------------------------
    Reg_Bank_0 : Reg_Bank
        port map ( En  => register_enable,
                   Clk => clock_out,
                   Res => reset,
                   D   => M,
                   Q0  => D0,
                   Q1  => D1,
                   Q2  => D2,
                   Q3  => D3,
                   Q4  => D4,
                   Q5  => D5,
                   Q6  => D6,
                   Q7  => D7);

    -- 8-to-1 mux: read Rd (first operand / jump check register)
    Mux_4_8_to_1_1 : Mux_4_8_to_1
        port map ( I0 => D0, I1 => D1, I2 => D2, I3 => D3,
                   I4 => D4, I5 => D5, I6 => D6, I7 => D7,
                   S  => register_select_1,
                   Y  => mux1_out);

    -- 8-to-1 mux: read Rs (second operand)
    Mux_4_8_to_1_2 : Mux_4_8_to_1
        port map ( I0 => D0, I1 => D1, I2 => D2, I3 => D3,
                   I4 => D4, I5 => D5, I6 => D6, I7 => D7,
                   S  => register_select_2,
                   Y  => mux2_out);

    -- -------------------------------------------------------
    -- ALU units: Add/Sub, Multiply, Compare
    -- -------------------------------------------------------
    -- Add_Sub_4: Control=alu_op(0)  → 0=ADD, 1=SUB
    Add_Sub_4_0 : Add_Sub_4
        port map ( Control  => alu_op(0),
                   A        => mux1_out,
                   B        => mux2_out,
                   S        => add_sub_out,
                   Overflow => addsub_overflow,
                   Zero     => addsub_zero);

    Mul_4_0 : Mul_4
        port map ( A        => mux1_out,
                   B        => mux2_out,
                   P        => mul_out,
                   Overflow => mul_overflow,
                   Zero     => mul_zero);

    Comp_4_0 : Comp_4
        port map ( A       => mux1_out,
                   B       => mux2_out,
                   Equal   => comp_equal,
                   Greater => comp_greater,
                   Result  => comp_out);

    -- -------------------------------------------------------
    -- ALU result mux (4-way, selected by AluOp)
    -- -------------------------------------------------------
    with alu_op select
        alu_result <= add_sub_out when "00",   -- ADD
                      add_sub_out when "01",   -- SUB
                      mul_out     when "10",   -- MUL
                      comp_out    when others; -- CMP (always "0000", RegEn="000")

    -- -------------------------------------------------------
    -- Flag mux
    -- -------------------------------------------------------
    with alu_op select
        alu_zero     <= addsub_zero  when "00",
                        addsub_zero  when "01",
                        mul_zero     when "10",
                        comp_equal   when others;

    with alu_op select
        alu_overflow <= addsub_overflow when "00",
                        addsub_overflow when "01",
                        mul_overflow    when "10",
                        comp_greater    when others;

    Zero     <= alu_zero;
    Overflow <= alu_overflow;

    -- -------------------------------------------------------
    -- LoadSel mux: choose between ALU result and immediate
    -- -------------------------------------------------------
    Mux_4_2_to_1_0 : Mux_4_2_to_1
        port map ( I0 => alu_result,
                   I1 => immediate_value,
                   S  => load_select,
                   Y  => M);

    -- -------------------------------------------------------
    -- Program Counter logic
    -- -------------------------------------------------------
    Adder_3_0 : Adder_3
        port map ( A => memory_select,
                   S => adder_out);

    -- PC mux: choose between PC+1 (normal) and jump address
    Mux_3_2_to_1_0 : Mux_3_2_to_1
        port map ( I0 => adder_out,
                   I1 => address_to_jump,
                   S  => jump_flag,
                   Y  => pc_in);

    Program_Counter_0 : Program_Counter
        port map ( D   => pc_in,
                   Clk => clock_out,
                   Res => reset,
                   Q   => memory_select);

    -- -------------------------------------------------------
    -- Program ROM
    -- -------------------------------------------------------
    ProgramROM_0 : Program_Rom
        port map ( memory_select   => memory_select,
                   instruction_bus => I);

    -- R7 drives the answer output (displayed on 7-seg / LEDs)
    Answer <= D7;

end Behavioral;
