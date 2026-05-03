----------------------------------------------------------------------------------
-- Module Name: Nano_Processor - Behavioral
-- Description:
--   Extended ISA with 3-bit opcode [11:9]:
--     000 = ADD,  001 = SUB,  010 = MUL,  011 = CMP
--     100 = MOVI, 101 = DIV,  110 = JZR
--   New components: Mul_4, Comp_4, Div_4
--   ALU result and flags muxed by AluOp[2:0]
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
           AluOp      : out STD_LOGIC_VECTOR (2 downto 0);
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

component Div_4
    Port ( A        : in  STD_LOGIC_VECTOR (3 downto 0);
           B        : in  STD_LOGIC_VECTOR (3 downto 0);
           Q        : out STD_LOGIC_VECTOR (3 downto 0);
           Overflow : out STD_LOGIC;
           Zero     : out STD_LOGIC);
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
signal alu_op             : STD_LOGIC_VECTOR (2 downto 0);  -- 000=ADD,001=SUB,010=MUL,011=CMP,101=DIV

-- ALU result signals
signal add_sub_out        : STD_LOGIC_VECTOR (3 downto 0);
signal mul_out            : STD_LOGIC_VECTOR (3 downto 0);
signal comp_out           : STD_LOGIC_VECTOR (3 downto 0);
signal div_out            : STD_LOGIC_VECTOR (3 downto 0);
signal alu_result         : STD_LOGIC_VECTOR (3 downto 0);
signal immediate_value    : STD_LOGIC_VECTOR (3 downto 0);

-- Flag signals per ALU unit
signal addsub_overflow    : STD_LOGIC;
signal addsub_zero        : STD_LOGIC;
signal mul_overflow       : STD_LOGIC;
signal mul_zero           : STD_LOGIC;
signal comp_equal         : STD_LOGIC;
signal comp_greater       : STD_LOGIC;
signal div_overflow       : STD_LOGIC;
signal div_zero           : STD_LOGIC;

-- Muxed flags driven to outputs
signal alu_zero           : STD_LOGIC;
signal alu_overflow       : STD_LOGIC;

begin

    slow_clock_0 : Slow_Clk
        port map ( Clk_in  => Clk,
                   Clk_out => clock_out);

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

    Mux_4_8_to_1_1 : Mux_4_8_to_1
        port map ( I0 => D0, I1 => D1, I2 => D2, I3 => D3,
                   I4 => D4, I5 => D5, I6 => D6, I7 => D7,
                   S  => register_select_1,
                   Y  => mux1_out);

    Mux_4_8_to_1_2 : Mux_4_8_to_1
        port map ( I0 => D0, I1 => D1, I2 => D2, I3 => D3,
                   I4 => D4, I5 => D5, I6 => D6, I7 => D7,
                   S  => register_select_2,
                   Y  => mux2_out);

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

    Div_4_0 : Div_4
        port map ( A        => mux1_out,
                   B        => mux2_out,
                   Q        => div_out,
                   Overflow => div_overflow,
                   Zero     => div_zero);

    with alu_op select
        alu_result <= add_sub_out when "000",   -- ADD
                      add_sub_out when "001",   -- SUB
                      mul_out     when "010",   -- MUL
                      comp_out    when "011",   -- CMP
                      div_out     when "101",   -- DIV
                      "0000"      when others; 

    with alu_op select
        alu_zero     <= addsub_zero  when "000",
                        addsub_zero  when "001",
                        mul_zero     when "010",
                        comp_equal   when "011",
                        div_zero     when "101",
                        '0'          when others;

    with alu_op select
        alu_overflow <= addsub_overflow when "000",
                        addsub_overflow when "001",
                        mul_overflow    when "010",
                        comp_greater    when "011",
                        div_overflow    when "101",
                        '0'             when others;

    Zero     <= alu_zero;
    Overflow <= alu_overflow;

    Mux_4_2_to_1_0 : Mux_4_2_to_1
        port map ( I0 => alu_result,
                   I1 => immediate_value,
                   S  => load_select,
                   Y  => M);

    Adder_3_0 : Adder_3
        port map ( A => memory_select,
                   S => adder_out);

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

    ProgramROM_0 : Program_Rom
        port map ( memory_select   => memory_select,
                   instruction_bus => I);

    Answer <= D7;
    
end Behavioral;
