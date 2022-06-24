module FourtoOneMux(input1, input2, input3, input4, select, out);

parameter data_width=32;
input [data_width-1:0] input1;
input [data_width-1:0] input2;
input [data_width-1:0] input3;
input [data_width-1:0] input4;
input [1:0] select; //2 bit select input
output reg[data_width-1:0] out;

always @*
begin	
	case(select)	
	2'b00: out=input1;
	2'b01: out=input2;
	2'b10: out=input3;
	2'b11: out=input4;	
	endcase
end

endmodule
