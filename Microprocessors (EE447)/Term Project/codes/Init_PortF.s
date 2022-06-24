;***************************************************************
;PortFInit.s
;***************************************************************
GPIO_PORTF_DIR 			EQU 0x40025400
GPIO_PORTF_AFSEL 		EQU 0x40025420
GPIO_PORTF_PUR_R		EQU 0x40025510 ; PUR actual address
GPIO_PORTF_DEN 			EQU 0x4002551C
GPIO_PORTF_AMSEL		EQU	0x40025528
SYSCTL_RCGCGPIO 		EQU 0x400FE608
;PUB						EQU 0x0F
IOB 					EQU 0xFF
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA port_f_init , READONLY, CODE
			THUMB
			EXPORT Init_PortF ; Reference external subroutine
Init_PortF 	PROC ;B0-B3 input, B4-B7 output
			LDR R1 ,=SYSCTL_RCGCGPIO
			LDR R0,[R1]
			ORR R0,R0,#0xFF
			STR	R0,[R1]
			NOP
			NOP
			NOP
			LDR R1,=GPIO_PORTF_AMSEL
			LDR R0,[R1]
			BIC	R0,#0xFF
			STR R0,[R1]
			LDR R1,=GPIO_PORTF_DIR
			LDR R0,[R1]
			BIC R0,#0xFF
			ORR R0,#IOB
			STR R0,[R1]
			LDR R1,=GPIO_PORTF_AFSEL
			LDR R0,[R1]
			BIC R0,#0xFF
			STR R0,[R1]
			LDR R1,=GPIO_PORTF_DEN
			LDR R0,[R1]
			ORR R0,#0xFF
			STR R0,[R1]
		
			BX LR
			ENDP
			ALIGN
			END