module FourtoSixteenDec (input1, input2, input3, input4, out);

input input1;

input input2;

input input3;

input input4;

output [15:0] out;


assign out[0]=(~input1 & ~input2 & ~input3 & ~input4); //0000

assign out[1]=(~input1 & ~input2 & ~input3 & input4); //0001

assign out[2]=(~input1 & ~input2 & input3 & ~input4); //0010

assign out[3]=(~input1 & ~input2 & input3 & input4); //0011

assign out[4]=(~input1 & input2 & ~input3 & ~input4); //0100

assign out[5]=(~input1 & input2 & ~input3 & input4); //0101

assign out[6]=(~input1 & input2 & input3 & ~input4); //0110

assign out[7]=(~input1 & input2 & input3 & input4); //0111

assign out[8]=(input1 & ~input2 & ~input3 & ~input4); //1000

assign out[9]=(input1 & ~input2 & ~input3 & input4); //1001

assign out[10]=(input1 & ~input2 & input3 & ~input4); //1010

assign out[11]=(input1 & ~input2 & input3 & input4); //1011

assign out[12]=(input1 & input2 & ~input3 & ~input4); //1100

assign out[13]=(input1 & input2 & ~input3 & input4); //1101

assign out[14]=(input1 & input2 & input3 & ~input4); //1110

assign out[15]=(input1 & input2 & input3 & input4); //1111

endmodule
