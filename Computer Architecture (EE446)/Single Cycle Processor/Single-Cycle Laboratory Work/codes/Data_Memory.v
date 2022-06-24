module Data_Memory (Data_Address, Write_Data, Write_Enable, clk, reset, Data_RD);

parameter data_width=32;

input [data_width-1:0] Data_Address; 

input [data_width-1:0] Write_Data;

input Write_Enable, clk, reset;

output [data_width-1:0] Data_RD;

reg [data_width-1:0] R0_Mem, R1_Mem, R2_Mem, R3_Mem; //registers inside the data memory

reg [1:0] select; //select for the 4 to 1 MUX

initial begin
	
	R0_Mem=32'h 00000005;
	R1_Mem=32'h 00000003;
	R2_Mem=32'h 00000007;
	R3_Mem=32'h 00000000;
end

always @*
begin
	
	case(Data_Address)
	
	32'h 00000000: select=2'b00; //select R0		
	
	32'h 00000004: select=2'b01; //select R1
		
	32'h 00000008: select=2'b10; //select R2
	
	32'h 0000000C: select=2'b11; //select R3
	
	default: select=2'b00; //select R0	
	
	endcase
end

always @(posedge clk) 
begin 

	case(Data_Address)
	
	32'h 00000000: begin
		if(Write_Enable==1)
			R0_Mem<=Write_Data;	
	end
	
	32'h 00000004: begin		
		if(Write_Enable==1)
			R1_Mem<=Write_Data;
	end
	
	32'h 00000008: begin
		if(Write_Enable==1)
			R2_Mem<=Write_Data;	
	end
	
	32'h 0000000C: begin
		if(Write_Enable==1)
			R3_Mem<=Write_Data;	
	end
	
	endcase
end


FourtoOneMux MUX0(R0_Mem, R1_Mem, R2_Mem, R3_Mem, select, Data_RD); 

endmodule
