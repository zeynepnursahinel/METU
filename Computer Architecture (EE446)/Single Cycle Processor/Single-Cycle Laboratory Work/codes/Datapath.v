// Copyright (C) 2020  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"
// CREATED		"Mon May 09 02:31:39 2022"

module Datapath(
	PC_Src,
	clk,
	reset,
	Reg_Write,
	Reg_Src,
	ALU_Src,
	ALU_Shift_Control,
	Mem_Write,
	Mem_to_Reg,
	Shift_Select,
	ALU_Control,
	ALU_Flag,
	Data_Out,
	O_Instr,
	O_RD1_Out,
	O_WD3,
	R_Destination_Out
);


input wire	PC_Src;
input wire	clk;
input wire	reset;
input wire	Reg_Write;
input wire	Reg_Src;
input wire	ALU_Src;
input wire	ALU_Shift_Control;
input wire	Mem_Write;
input wire	Mem_to_Reg;
input wire	Shift_Select;
input wire	[2:0] ALU_Control;
output wire	[3:0] ALU_Flag;
output wire	[31:0] Data_Out;
output wire	[31:0] O_Instr;
output wire	[31:0] O_RD1_Out;
output wire	[31:0] O_WD3;
output wire	[31:0] R_Destination_Out;

wire	[3:0] ALU_Flag_ALTERA_SYNTHESIZED;
wire	[31:0] Instr;
wire	[31:0] RD1_Out;
wire	[31:0] RD2_Out;
wire	[31:0] SYNTHESIZED_WIRE_16;
wire	[31:0] SYNTHESIZED_WIRE_17;
wire	[31:0] SYNTHESIZED_WIRE_2;
wire	[31:0] SYNTHESIZED_WIRE_3;
wire	[31:0] SYNTHESIZED_WIRE_4;
wire	[31:0] SYNTHESIZED_WIRE_5;
wire	[31:0] SYNTHESIZED_WIRE_18;
wire	[31:0] SYNTHESIZED_WIRE_9;
wire	[31:0] SYNTHESIZED_WIRE_19;
wire	[31:0] SYNTHESIZED_WIRE_12;
wire	[3:0] SYNTHESIZED_WIRE_13;
wire	[31:0] SYNTHESIZED_WIRE_14;

assign	Data_Out = SYNTHESIZED_WIRE_9;
assign	O_WD3 = SYNTHESIZED_WIRE_19;




Adder	b2v_adder0(
	.inpA(SYNTHESIZED_WIRE_16),
	.outp(SYNTHESIZED_WIRE_17));
	defparam	b2v_adder0.data_width = 32;


Adder	b2v_adder1(
	.inpA(SYNTHESIZED_WIRE_17),
	.outp(SYNTHESIZED_WIRE_14));
	defparam	b2v_adder1.data_width = 32;


ArithmeticLogicUnit	b2v_ALU(
	.alu_control(ALU_Control),
	.inA(RD1_Out),
	.inB(SYNTHESIZED_WIRE_2),
	.N(ALU_Flag_ALTERA_SYNTHESIZED[3]),
	.Z(ALU_Flag_ALTERA_SYNTHESIZED[2]),
	.C(ALU_Flag_ALTERA_SYNTHESIZED[1]),
	.V(ALU_Flag_ALTERA_SYNTHESIZED[0]),
	.data_out(SYNTHESIZED_WIRE_3));
	defparam	b2v_ALU.data_width = 32;


TwotoOneMux	b2v_ALU_Shift_MUX(
	.select(ALU_Shift_Control),
	.input1(SYNTHESIZED_WIRE_3),
	.input2(SYNTHESIZED_WIRE_4),
	.out(SYNTHESIZED_WIRE_18));
	defparam	b2v_ALU_Shift_MUX.data_width = 32;


TwotoOneMux	b2v_ALU_Src_MUX(
	.select(ALU_Src),
	.input1(RD2_Out),
	.input2(SYNTHESIZED_WIRE_5),
	.out(SYNTHESIZED_WIRE_2));
	defparam	b2v_ALU_Src_MUX.data_width = 32;


Barrel_Shifter	b2v_barrel_shifter(
	.RL_Sel(Shift_Select),
	.RN_In(RD1_Out),
	.sh(Instr[2:0]),
	.Shift_Out(SYNTHESIZED_WIRE_4));
	defparam	b2v_barrel_shifter.N = 32;
	defparam	b2v_barrel_shifter.shift = 3;


Data_Memory	b2v_Data_Memory(
	.Write_Enable(Mem_Write),
	.clk(clk),
	.reset(reset),
	.Data_Address(SYNTHESIZED_WIRE_18),
	.Write_Data(RD2_Out),
	.Data_RD(SYNTHESIZED_WIRE_9));
	defparam	b2v_Data_Memory.data_width = 32;


Extender	b2v_ExtIMM(
	.Ext_Input(Instr[11:0]),
	.Ext_Out(SYNTHESIZED_WIRE_5));
	defparam	b2v_ExtIMM.data_width = 32;


Instruction_Memory	b2v_Inst_Mem(
	.Inst_Address(SYNTHESIZED_WIRE_16),
	.Instr_Out(Instr));
	defparam	b2v_Inst_Mem.datawidth = 32;


TwotoOneMux	b2v_Mem_to_Reg_MUX(
	.select(Mem_to_Reg),
	.input1(SYNTHESIZED_WIRE_18),
	.input2(SYNTHESIZED_WIRE_9),
	.out(SYNTHESIZED_WIRE_19));
	defparam	b2v_Mem_to_Reg_MUX.data_width = 32;


TwotoOneMux	b2v_PC_MUX(
	.select(PC_Src),
	.input1(SYNTHESIZED_WIRE_17),
	.input2(SYNTHESIZED_WIRE_19),
	.out(SYNTHESIZED_WIRE_12));
	defparam	b2v_PC_MUX.data_width = 32;


Program_Counter	b2v_Program_Counter(
	.clk(clk),
	.reset(reset),
	.in(SYNTHESIZED_WIRE_12),
	.out(SYNTHESIZED_WIRE_16));
	defparam	b2v_Program_Counter.data_width = 32;


RegFile	b2v_REG_FILE(
	.clk(clk),
	.reset(reset),
	.write_enable(Reg_Write),
	.A1(Instr[19:16]),
	.A2(SYNTHESIZED_WIRE_13),
	.A3(Instr[15:12]),
	.R15_In(SYNTHESIZED_WIRE_14),
	.WD3(SYNTHESIZED_WIRE_19),
	.RD1(RD1_Out),
	.RD2(RD2_Out),
	.RD3(R_Destination_Out));
	defparam	b2v_REG_FILE.datawidth = 32;


TwotoOneMux	b2v_RM_RD_MUX(
	.select(Reg_Src),
	.input1(Instr[3:0]),
	.input2(Instr[15:12]),
	.out(SYNTHESIZED_WIRE_13));
	defparam	b2v_RM_RD_MUX.data_width = 4;

assign	ALU_Flag = ALU_Flag_ALTERA_SYNTHESIZED;
assign	O_Instr = Instr;
assign	O_RD1_Out = RD1_Out;

endmodule