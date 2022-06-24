module Barrel_Shifter(RN_In, Shift_Out, sh, RL_Sel);

parameter N=32;
parameter shift=3; 

input [shift-1:0] sh;
input RL_Sel; 

input [N-1:0] RN_In;
output reg[N-1:0] Shift_Out;


always @(sh or RN_In or RL_Sel)
	
	if(RL_Sel==1) //Right Shift
	begin
		case (sh)
			3'b000: Shift_Out = RN_In;
			3'b001: Shift_Out = RN_In>>1;
			3'b010: Shift_Out = RN_In>>2;
			3'b011: Shift_Out = RN_In>>3;
			3'b100: Shift_Out = RN_In>>4;
			3'b101: Shift_Out = RN_In>>5;
			3'b110: Shift_Out = RN_In>>6;
			3'b111: Shift_Out = RN_In>>7;
		endcase
	 end
	 
	 else //Left Shift
	 begin
		case (sh)
			3'b000: Shift_Out = RN_In;
			3'b001: Shift_Out = RN_In<<1;
			3'b010: Shift_Out = RN_In<<2;
			3'b011: Shift_Out = RN_In<<3;
			3'b100: Shift_Out = RN_In<<4;
			3'b101: Shift_Out = RN_In<<5;
			3'b110: Shift_Out = RN_In<<6;
			3'b111: Shift_Out = RN_In<<7;
		endcase
	 end

endmodule

