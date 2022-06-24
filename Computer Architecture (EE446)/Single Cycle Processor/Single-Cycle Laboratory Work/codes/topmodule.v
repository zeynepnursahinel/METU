module topmodule(clk, reset, CPSR, Data_Out, O_Instr, O_RD1_Out, O_WD3, R_Destination_Out);

parameter data_width=32;
 
input clk, reset;
output [data_width-1:0] Data_Out, O_RD1_Out, O_WD3, R_Destination_Out;

output wire [data_width-1:0] O_Instr;

output [3:0] CPSR;

wire PC_Src, Reg_Write, Reg_Src, ALU_Src, ALU_Shift_Control, Mem_Write,
Mem_to_Reg, Shift_Select;
wire [2:0] ALU_Control;
wire [3:0] ALU_Flag;

Datapath DATAPATH0(
	.PC_Src(PC_Src),
	.clk(clk),
	.reset(reset),
	.Reg_Write(Reg_Write),
	.Reg_Src(Reg_Src),
	.ALU_Src(ALU_Src),
	.ALU_Shift_Control(ALU_Shift_Control),
	.Mem_Write(Mem_Write),
	.Mem_to_Reg(Mem_to_Reg),
	.Shift_Select(Shift_Select),
	.ALU_Control(ALU_Control),
	.ALU_Flag(ALU_Flag),
	.Data_Out(Data_Out),//data memory read output
	.O_Instr(O_Instr),//to cehck instrution
	.O_RD1_Out(O_RD1_Out),//check out the Rn register (RD1 in the Reg File)
	.O_WD3(O_WD3),//check ALU result 
	.R_Destination_Out(R_Destination_Out)//not much important
);

	Controller(
	.Op(O_Instr[27:26]), 
	.func(O_Instr[25:20]), 
	.ALU_Flag(ALU_Flag), 
	.PC_Src(PC_Src), 
	.Reg_Src(Reg_Src), 
	.Reg_Write(Reg_Write), 
	.ALU_Src(ALU_Src), 
	.ALU_Control(ALU_Control), 
	.ALU_Shift_Control(ALU_Shift_Control), 
	.Mem_Write(Mem_Write), 
	.Mem_to_Reg(Mem_to_Reg),
	.Shift_Select(Shift_Select), 
	.CPSR(CPSR)
);


endmodule
