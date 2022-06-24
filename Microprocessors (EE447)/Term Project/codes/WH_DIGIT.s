SSI0_DR				EQU	0x40008008 ; Clock Prescale
GPIO_PORTA_DATA		EQU	0x400043FC

					AREA	subroutine, READONLY, CODE
					THUMB				
					
					EXTERN 	DELAY10					
					EXPORT	wh_digit
						
wh_digit			PROC
					PUSH	{LR, R0, R1}
					
					TEQ		R10,#0     ;teq=eors
					BEQ		zero
					TEQ		R10,#1
					BEQ		one
					TEQ		R10,#2
					BEQ		two
					TEQ		R10,#3
					BEQ		three
					TEQ		R10,#4
					BEQ		four
					TEQ		R10,#5
					B		cont

					
zero				MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10					
					B		fin
					
one					MOV 	R0,#0x00					
					STR 	R0,[R1]					
					MOV 	R0,#0x00						
					STR 	R0,[R1]					
					MOV 	R0,#0x00						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10						
					B		fin
					
two					MOV 	R0,#0x1D					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x17						
					STR 	R0,[R1]										
					BL		DELAY10					
					B		fin
					
three				MOV 	R0,#0x15					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10					
					B		fin
					
four				MOV 	R0,#0x07					
					STR 	R0,[R1]					
					MOV 	R0,#0x04						
					STR 	R0,[R1]					
					MOV 	R0,#0x04						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10					
					B		fin
					
five				MOV 	R0,#0x17					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1D						
					STR 	R0,[R1]										
					BL		DELAY10						
					B		fin
					
cont				BEQ		five
					TEQ		R10,#6
					BEQ		six
					TEQ		R10,#7
					BEQ		seven
					TEQ		R10,#8
					BEQ		eight					
					TEQ		R10,#9
					BEQ		nine
					
six					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1D						
					STR 	R0,[R1]										
					BL		DELAY10					
					B		fin
					
seven				MOV 	R0,#0x01					
					STR 	R0,[R1]					
					MOV 	R0,#0x01						
					STR 	R0,[R1]					
					MOV 	R0,#0x01						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10					
					B		fin
					
eight				MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10				
					B		fin
					
nine				MOV 	R0,#0x17					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					BL		DELAY10					
					
fin				    POP		{LR, R0, R1}
					BX		LR
					ENDP						
						
					ALIGN
					END