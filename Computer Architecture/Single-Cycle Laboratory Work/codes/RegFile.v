module RegFile(clk, reset, write_enable, A1, A2, A3,
WD3, R15_In, RD1, RD2, RD3);

input clk;
input reset;
input write_enable; //Later it will take the RegWrite Signal

input [3:0] A1;
input [3:0] A2;
input [3:0] A3;

parameter datawidth=32;

input [datawidth-1:0] WD3; //write data to the destination register Rd (A3)
input [datawidth-1:0] R15_In;

output [datawidth-1:0] RD1; 
output [datawidth-1:0] RD2;
output [datawidth-1:0] RD3;


wire [15:0] dec_out0;
wire [15:0] dec_out1;
wire [15:0] dec_out2;

wire [datawidth-1:0] R0_out, R1_out, R2_out, R3_out, R4_out,
R5_out, R6_out, R7_out, R8_out, R9_out, R10_out, R11_out, 
R12_out, R13_out, R14_out, R15_out;

reg [3:0] A3_Reg, A3_holder; //to hold the previous value

initial begin
//In the 1st instruction RD=R1 thus A3_Reg should be 0001
	A3_Reg=4'b 00001;
	A3_holder=4'b 0001;
end 
///////
always @(posedge clk)
begin

	A3_Reg<=A3;
	//A3_holder<=A3_Reg;
end


FourtoSixteenDec D0(A1[3], A1[2], A1[1], A1[0],dec_out0); 

FourtoSixteenDec D1(A2[3], A2[2], A2[1],A2[0],dec_out1);

FourtoSixteenDec D2(A3[3], A3[2], A3[1], A3[0], dec_out2);

Reg_Res_En R0(clk, WD3, R0_out, reset, (write_enable & dec_out2[0]));

Reg_Res_En R1(clk, WD3, R1_out, reset, (write_enable & dec_out2[1]));

Reg_Res_En R2(clk, WD3, R2_out, reset, (write_enable & dec_out2[2]));

Reg_Res_En R3(clk, WD3, R3_out, reset, (write_enable & dec_out2[3]));

Reg_Res_En R4(clk, WD3, R4_out, reset, (write_enable & dec_out2[4]));

Reg_Res_En R5(clk, WD3, R5_out, reset, (write_enable & dec_out2[5]));

Reg_Res_En R6(clk, WD3, R6_out, reset, (write_enable & dec_out2[6]));

Reg_Res_En R7(clk, WD3, R7_out, reset, (write_enable & dec_out2[7]));

Reg_Res_En R8(clk, WD3, R8_out, reset, (write_enable & dec_out2[8]));

Reg_Res_En R9(clk, WD3, R9_out, reset, (write_enable & dec_out2[9]));

Reg_Res_En R10(clk, WD3, R10_out, reset, (write_enable & dec_out2[10]));

Reg_Res_En R11(clk, WD3, R11_out, reset, (write_enable & dec_out2[11]));

Reg_Res_En R12(clk, WD3, R12_out, reset, (write_enable & dec_out2[12]));

Reg_Res_En R13(clk, WD3, R13_out, reset, (write_enable & dec_out2[13]));

Reg_Res_En R14(clk, WD3, R14_out, reset, (write_enable & dec_out2[14]));

Reg_Res_En R15(clk, WD3, R15_out, reset, 1); //R15 takes the PC+8 value

Sixteen_to_Four_Mux M0(R0_out, R1_out, R2_out, R3_out, R4_out,
R5_out, R6_out, R7_out, R8_out, R9_out, R10_out, R11_out, 
R12_out, R13_out, R14_out, R15_out, A1, RD1);

Sixteen_to_Four_Mux M1(R0_out, R1_out, R2_out, R3_out, R4_out,
R5_out, R6_out, R7_out, R8_out, R9_out, R10_out, R11_out, 
R12_out, R13_out, R14_out, R15_out, A2, RD2);

Sixteen_to_Four_Mux M2(R0_out, R1_out, R2_out, R3_out, R4_out,
R5_out, R6_out, R7_out, R8_out, R9_out, R10_out, R11_out, 
R12_out, R13_out, R14_out, R15_out, A3_Reg, RD3);

endmodule

 