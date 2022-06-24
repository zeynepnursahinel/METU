;***************************************************************
; Convrt.s
; Def: Converts max 32-bit hex number's decimal equivalent to ascii
; Writes the ascii result sstarting from [R5] address
;***************************************************************
; Constants

ASCII		EQU			0x030

;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA convert , READONLY, CODE
			THUMB
			EXPORT Convrt ; Reference external subroutine
				
Convrt 		PROC
			;LDR			R5,=FIRST
			PUSH		{R0,R1,R2,R3,R4,R5,R6,R7,R8} 
			
			MOV			R1,#0x0A
			MOV 		R6,#0
			
start		UDIV		R2, R4,R1 ;divide by ten, div->R2
			MUL			R3, R2,R1 ;multiply div*10 -> R3
			SUB			R0,R4,R3; Least significant digit -> R0
			ADD			R0,#ASCII ;convert digits to ascii
			PUSH		{R0}
			MOV			R4,R2
			CMP 		R2,#0
			ADD			R6,#0x01 ; counts how many decimal digits exists in the number
			BNE			start
			;ascii equivalent of digits are pushed to stack, then write to location of R5
write_reg	SUB		R6,#0x01
			POP		{R7}
			STRB	R7,[R5],#1
			CMP		R6,#0x00
			BNE		write_reg
			MOV		R0,#0x0D
			STRB	R0,[R5],#1
			MOV		R0,#0x04
			STRB	R0,[R5]
			
			POP    {R0,R1,R2,R3,R4,R5,R6,R7,R8}
			BX LR
			ENDP
				
			ALIGN
			END
