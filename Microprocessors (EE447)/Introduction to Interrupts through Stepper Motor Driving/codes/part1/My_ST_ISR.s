;LABEL DIRECTIVE VALUE COMMENT

		;AREA niye yok?????
		
					EXPORT My_ST_ISR
My_ST_ISR PROC

	 ;BL Init_PortB
	 
Loop1 	MOV R4, #0x08 ;first full step1
		MOV R3, #4    ;step counter

Loop2  LSR R4, #1     ;clockwise
	   SUBS R3, #1
       BEQ	Loop2	 
	 
	   B Loop1	




	BX LR
	
	ENDP