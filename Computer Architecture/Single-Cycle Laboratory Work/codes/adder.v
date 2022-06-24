module Adder(inpA, outp);

parameter data_width=32;

input [data_width-1:0] inpA;

output [data_width-1:0] outp;

assign outp=inpA+32'h 00000004;


endmodule
