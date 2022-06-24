module Controller(Op, func, ALU_Flag, PC_Src, Reg_Src, Reg_Write, 
ALU_Src, ALU_Control, ALU_Shift_Control, Mem_Write, Mem_to_Reg,
Shift_Select, CPSR);

input [1:0] Op;
input [5:0] func;
input [3:0] ALU_Flag;

output reg PC_Src;
output reg Reg_Src;
output reg Reg_Write;
output reg ALU_Src;
output reg [2:0] ALU_Control;
output reg ALU_Shift_Control;
output reg Mem_Write;
output reg Mem_to_Reg;
output reg Shift_Select;

output reg [3:0] CPSR;

initial begin
	
	//Initial instruction is LDR
	PC_Src=0;
	Reg_Src=1;
	Reg_Write=1;
	ALU_Src=1;
	ALU_Control=3'b000;
	ALU_Shift_Control=0;
	Mem_Write=0;
	Mem_to_Reg=1;
	Shift_Select=0;

end

always @*
begin

	if(Op==2'b00) //Data Processing 
	begin
		//Look Funct
		if(func==6'b101000)//ADD
			begin
				PC_Src=0;
				Reg_Src=0;
				Reg_Write=1;
				ALU_Src=0;
				ALU_Control=3'b000;
				ALU_Shift_Control=0;
				Mem_Write=0;
				Mem_to_Reg=0;
				//Shift_Select= x;
				
				CPSR =4'b 1110; //Uncondition
			end
			
		else if(func==6'b100100)//SUB
			begin
				PC_Src=0;
				Reg_Src=0;
				Reg_Write=1;
				ALU_Src=0;
				ALU_Control=3'b001;
				ALU_Shift_Control=0;
				Mem_Write=0;
				Mem_to_Reg=0;
				//Shift_Select= x;
				
				CPSR =4'b 1110;
			end
		
		else if(func==6'b100000)//AND
			begin
				PC_Src=0;
				Reg_Src=0;
				Reg_Write=1;
				ALU_Src=0;
				ALU_Control=3'b100;
				ALU_Shift_Control=0;
				Mem_Write=0;
				Mem_to_Reg=0;
				//Shift_Select= x;
				
				CPSR =4'b 1110;
			end
		
		else if(func==6'b111000)//ORR
			begin
				PC_Src=0;
				Reg_Src=0;
				Reg_Write=1;
				ALU_Src=0;
				ALU_Control=3'b101;
				ALU_Shift_Control=0;
				Mem_Write=0;
				Mem_to_Reg=0;
				//Shift_Select= x;
				
				CPSR =4'b 1110;
			
			end
			
		else if(func==6'b100110)//LSR
			begin
				PC_Src=0;
				//Reg_Src=0;
				Reg_Write=1;
				//ALU_Src=0;
				//ALU_Control=3'b001;
				ALU_Shift_Control=1;
				Mem_Write=0;
				Mem_to_Reg=0;
				Shift_Select=1;
				
				CPSR =4'b 1110;
			end
		
		else if(func==6'b100010)//LSL
			begin
				PC_Src=0;
				//Reg_Src=0;
				Reg_Write=1;
				//ALU_Src=0;
				//ALU_Control=3'b001;
				ALU_Shift_Control=1;
				Mem_Write=0;
				Mem_to_Reg=0;
				Shift_Select=0;
				
				CPSR =4'b 1110;
			end
			
		else if(func==6'b100101)//CMP
			begin
				PC_Src=0;
				Reg_Src=1;
				Reg_Write=0; //SO IMPORTANT no register writing
				ALU_Src=0;
				ALU_Control=3'b010; //SrcB-SrcA (RD-RN)
				ALU_Shift_Control=0;
				Mem_Write=0;
				Mem_to_Reg=0;
				//Shift_Select= x;
				
				
				//FLAG UPDATE ****************************
				if(ALU_Flag[2]==1)//Z==1
					begin
					
						CPSR =4'b 0100; //NOT SURE
					
					end
					
				else
				begin
						CPSR =4'b 1110;
				end
			end
		end

	else if(Op==2'b01) //Memory Operations
	begin
			if(func==6'b011000) //STR
				begin
					PC_Src=0;
					Reg_Src=1;
					Reg_Write=0;
					ALU_Src=1;
					ALU_Control=3'b000;
					ALU_Shift_Control=0;
					Mem_Write=1;
					//Mem_to_Reg=x;
					//Shift_Select= x;
			
					CPSR =4'b 1110;
				end
			
			else if(func==6'b011001) //LDR
				begin
					PC_Src=0;
					//Reg_Src=x;
					Reg_Write=1;
					ALU_Src=1;
					ALU_Control=3'b000;
					ALU_Shift_Control=0;
					Mem_Write=0;
					Mem_to_Reg=1;
					//Shift_Select= x;
				
					CPSR =4'b 1110;
				end
	end
	
end

endmodule
