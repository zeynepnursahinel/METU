module Program_Counter (clk, in, reset, out);

parameter data_width=32;

input clk;
input [data_width-1:0] in;
output reg [data_width-1:0] out;
input reset;

initial begin
	
	out=32'h 20004000; //initialy PC is 20004000 (pointing to the first address of the instruction memory)e

end

always @(posedge clk)

begin

	if(reset==0)
	
		out<=in;
		
	else
	
		out <=0;

end

endmodule
