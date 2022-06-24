module Instruction_Memory(Inst_Address, Instr_Out);

parameter datawidth=32;

input [datawidth-1:0] Inst_Address;

output reg[datawidth-1:0] Instr_Out;

initial 
begin
	Instr_Out=32'b0; 	
end

always @*
begin

	case(Inst_Address)
	
	32'h 20004000:Instr_Out=32'h E5901004; //LDR R1, [R0,#4] 		 
	32'h 20004004:Instr_Out=32'h E5902008; //LDR R2, [R0,#8]	 
	32'h 20004008:Instr_Out=32'h E2813002; //ADD R3, R1, R2		
	32'h 2000400C:Instr_Out=32'h E2834002; //ADD R4, R3, R2
	32'h 20004010:Instr_Out=32'h E2444001; //SUB R4, R4, R1
	32'h 20004014:Instr_Out=32'h E2043002; //AND R3, R4, R2
	32'h 20004018:Instr_Out=32'h E3832001; //ORR R2, R3, R1
	32'h 2000401C:Instr_Out=32'h E2213002; //LSL R3, R1, 2
	32'h 20004020:Instr_Out=32'h E2634002; //LSR R4, R3, 2
	32'h 20004024:Instr_Out=32'h E2534000; //CMP R4, R3
	32'h 20004028:Instr_Out=32'h E2514000; //CMP R4, R1
	32'h 2000402C:Instr_Out=32'h E580400C; //STR R4, [R0,#12]
	32'h 20004030:Instr_Out=32'h E580200C; //STR R2, [R0,#12]
	default: Instr_Out=32'b0;	//not to create latch
	
	endcase

end

endmodule
