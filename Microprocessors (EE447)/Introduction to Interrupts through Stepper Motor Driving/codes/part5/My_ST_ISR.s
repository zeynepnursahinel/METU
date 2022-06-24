; ********************************************************
;My_ST_ISR.s
GPIO_PORTB_DATA_WRITE EQU 0x400053C0 ; data address to write pins B4-B7 0011_1100_0000
;*********************************************************
; Register R8 is used for motor drive
; SysTick ISR area
;*********************************************************
;LABEL DIRECTIVE VALUE COMMENT
				AREA my_st_isr , CODE, READONLY, ALIGN=2
				THUMB
				EXPORT My_ST_ISR

My_ST_ISR PROC
		
			CMP R9,#0x01
			BEQ ccw
			BNE is_cw
			
ccw 		LDR R1,=GPIO_PORTB_DATA_WRITE
			CMP R8,#8
			MOVEQ R8,#128
			STR R8,[R1] ;write 1000_0000 to B7B6B5B4_0000 IN1: HIGH
			LSR R8,#1
			BX LR
			
is_cw 		CMP R9,#0x02
			BEQ cw
			BX LR
			
cw 			LDR R1,=GPIO_PORTB_DATA_WRITE
			CMP R8,#256
			MOVEQ R8,#16
			STR R8,[R1] ;write 1000_0000 to B7B6B5B4_0000 IN1: HIGH
			LSL R8,#1
			BX LR
			
			ENDP
			
			ALIGN
			END