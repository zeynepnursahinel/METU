module Reg_Res_En (clk, in, out, reset, write_enable);

parameter data_width=32;

input clk;

input [data_width-1:0] in; //32-bit input

input write_enable;

output reg [data_width-1:0] out;

input reset;

initial begin

	out=0;

end

always @(posedge clk)

begin

	if(reset==0 & write_enable==1)
			out<=in;	
		
	else if(reset==1)
		out <=0;
end

endmodule
