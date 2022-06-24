module TwotoOneMux (input1, input2, select, out);

parameter data_width=32;

input [data_width-1:0] input1;

input [data_width-1:0] input2;

input select;

output reg[data_width-1:0] out;


always @*

begin
	
	case(select)
	
		1'b0:out=input1;  //if select is zero input1 is displayed
		1'b1:out=input2;  //if select is one input1 is displayed
	
	endcase
end

endmodule
