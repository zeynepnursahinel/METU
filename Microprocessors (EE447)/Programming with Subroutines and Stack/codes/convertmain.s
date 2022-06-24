;LABEL DIRECTIVE VALUECOMMENT
				AREA sdata , DATA, READONLY
				THUMB
MSG DCB "You have found the correct number"
		DCB 0X0D
		DCB 0X04

NUM EQU 0X40

				AREA main , CODE, READONLY
				THUMB
				EXTERN OutStr
				EXTERN CONVRT
				EXTERN UPBND
				EXTERN InChar
				EXPORT __main
			ENTRY
			
__main PROC
	
		LDR R2,=NUM ;initial upper boundary
		LSR R4, R2, #1 ;initial mid value
		MOV R0,#0X00 ;initial low boundary

get BL InChar
	CMP R5, #0X43 ;if the input is C
	BEQ Cont
	BL UPBND ;else enter UPBND
	PUSH {R0-R4}
	BL CONVRT
	POP{R0-R4}
	LDR R5,=0X20000400
	B Final
	
Cont LDR R5, =MSG
Final BL OutStr
	B get

	ENDP
		ALIGN
		END
