module ArithmeticLogicUnit (inA,inB,alu_control,N,Z,C,V, data_out);

parameter data_width=32;
input [data_width-1:0] inA;
input [data_width-1:0] inB;
input [2:0] alu_control;
output reg [data_width-1:0] data_out;
output reg N,Z,C,V;	 
reg [data_width:0] tmp;	


always @*
begin

	if(data_out[data_width-1]==1) //negative flag
			N=1;
	else 
			N=0;
			
	if(data_out==0)
			Z=1;
			
	else 
			Z=0;
			
end 

always @*

begin

	case(alu_control)
	
	3'b000: begin //addition
				data_out=inA+inB;  

				tmp = {1'b0,inA} + {1'b0,inB};
				
				C = tmp[data_width]; // Carryout flag
				
				if((inA[data_width-1]==1 & inB[data_width-1]==1 & 
				data_out[data_width-1]==0) | (inA[data_width-1]==0 
				& inB[data_width-1]==0 & data_out[data_width-1]==1))
			
					V=1; //overflow flag
				
				else
					V=0;
			
				end
			  
	3'b001: begin //substraction A to B
	
				tmp = {1'b0,inA} - {1'b0,inB};
				
				C=tmp[data_width];
				
				data_out=inA-inB;  
					
				if((inA[data_width-1]==0 & inB[data_width-1]==1 & 
				data_out[data_width-1]==1) | (inA[data_width-1]==1 & 
				inB[data_width-1]==0 & data_out[data_width-1]==0))
			
						V=1; //Overflow
					
				else
						V=0;
				
				end
				
	3'b010: begin  //substraction B to A
	
				tmp = {1'b0,inB} - {1'b0,inA};
				
				C=tmp[data_width]; //carry Out
	
				data_out=inB-inA;  

				
				if((inA[data_width-1]==1 & inB[data_width-1]==0 
				& data_out[data_width-1]==1) | (inA[data_width-1]==0 
				& inB[data_width-1]==1 & data_out[data_width-1]==0))
			
						V=1; //Overflow Flag
					
				else
						V=0;
								
				end
				
	3'b011: begin
				
				data_out=inA & (~inB); //bit clear
				C=0;
				V=0;
				end
				
	3'b100: begin
				
				data_out=inA & inB; //and	
				C=0;
				V=0;
				end
				
	3'b101: begin
				
				data_out=inA | inB; //or
				C=0;
				V=0;		
				end
				
	3'b110: begin 
				
				data_out=inA ^ inB; //xor
				C=0;
				V=0;
				end
				
	3'b111: begin 
				
				data_out=inA ~^ inB; //xnor
				C=0;
			   V=0;
				end
				
	endcase
	
end

endmodule
