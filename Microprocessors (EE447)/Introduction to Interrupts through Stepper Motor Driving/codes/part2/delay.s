;****************************
;delay.s
;****************************
hundred_msec_delay EQU 533333 ; 5*16M/(3) 5sec delay
;LABEL DIRECTIVE VALUE COMMENT
				AREA delay_SR , CODE, READONLY
				THUMB
				EXPORT delay
delay PROC
			PUSH{R0}
			
			LDR R0,=hundred_msec_delay
			
loop 		SUBS R0,#1
			BNE loop
			NOP

			POP{R0}
			
			BX LR
			ENDP

			ALIGN 
			END
