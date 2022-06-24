module Sixteen_to_Four_Mux
(input0, input1, input2, input3, input4, 
input5, input6, input7, input8, input9, input10,
input11, input12, input13, input14, input15,
select, out);

parameter data_width=32;

input [data_width-1:0] input0,input1, input2, input3, input4, 
input5, input6, input7, input8, input9, input10,
input11, input12, input13, input14, input15;


input [3:0] select; //4 bit select input

output reg[data_width-1:0] out;

always @*
begin	
	case(select)	
	4'b0000: out=input0;
	4'b0001: out=input1;
	4'b0010: out=input2;
	4'b0011: out=input3;
	
	4'b0100: out=input4;
	4'b0101: out=input5;
	4'b0110: out=input6;
	4'b0111: out=input7;
	
	4'b1000: out=input8;
	4'b1001: out=input9;
	4'b1010: out=input10;
	4'b1011: out=input11;
	
	4'b1100: out=input12;
	4'b1101: out=input13;
	4'b1110: out=input14;
	4'b1111: out=input15;
	
	default: out=32'b0; //if nothing is selected out takes zero value
	
	endcase
end

endmodule
