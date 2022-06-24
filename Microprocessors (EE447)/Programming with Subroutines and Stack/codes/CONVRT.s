;LABEL	DIRECTIVE	VALUE	COMMENT

	
					AREA routines, CODE, READONLY
					THUMB
					EXPORT CONVRT
						

CONVRT 	PUSH {LR}

				
		LDR R5,=0X20000400
		MOV R0, #10			; for division by ten
		MOV R7, #0			;counter
		
Loop1	UDIV R2, R4, R0		; R2 is quotient
		MUL  R6, R0, R2
		SUB  R3, R4, R6		; R3 remainder 
		
		MOV R4, R2			; copy r2 to r4
		
		ADD R7, #1 			;counter increases
		
		CMP R4, #0
		
		PUSH {R3}
		
		BNE Loop1
		
Loop2   SUBS R7, #1         ;counter=counter-1
		
		POP{R3}
		
		MOV R0, R3
				
		ADD R0, #0X30

		STR R0, [R5], #1
		
		CMP R7, #0		;IF R7=!0 LOOP2 continues
		
		BNE Loop2
		
		
		MOV R0, #0X0d
		
		STR R0, [R5], #1

		MOV R0, #0X04
		
		STR R0, [R5]
		
		POP {LR}
		
		BX LR
						 
;LABEL DIRECTIVE VALUE COMMENT
		ALIGN
		END