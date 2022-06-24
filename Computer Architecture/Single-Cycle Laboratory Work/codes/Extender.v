module Extender(Ext_Input, Ext_Out);

input [11:0] Ext_Input;

parameter data_width=32;

output [data_width-1:0] Ext_Out;

assign Ext_Out= {20'b0, Ext_Input};

endmodule

