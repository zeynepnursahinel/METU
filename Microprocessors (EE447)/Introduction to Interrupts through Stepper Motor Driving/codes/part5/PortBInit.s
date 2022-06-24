;***************************************************************
;PortBInit.s
GPIO_PORTB_DIR EQU 0x40005400
GPIO_PORTB_AFSEL EQU 0x40005420
GPIO_PORTB_PUR_R EQU 0x40005510 ; PUR actual address
GPIO_PORTB_DEN EQU 0x4000551C
GPIO_PORTB_AMSEL EQU 0x40005528
SYSCTL_RCGCGPIO EQU 0x400FE608
PUB EQU 0x0F
IOB EQU 0xF0
;***************************************************************
; Program section 
;***************************************************************
;LABEL DIRECTIVE VALUE COMMENT
					AREA port_b_init , READONLY, CODE
					THUMB
					EXPORT PortBInit ; Reference external subroutine

PortBInit PROC ;B0-B3 input, B4-B7 output
		
		LDR R1 ,=SYSCTL_RCGCGPIO
		LDR R0,[R1]
		ORR R0,R0,#0xFF
		STR R0,[R1]
		NOP
		NOP
		NOP

		LDR R1,=GPIO_PORTB_AMSEL
		LDR R0,[R1]
		BIC R0,#0xFF
		STR R0,[R1]
		
		LDR R1,=GPIO_PORTB_DIR
		LDR R0,[R1]
		BIC R0,#0xFF
		ORR R0,#IOB
		STR R0,[R1]

		LDR R1,=GPIO_PORTB_AFSEL
		LDR R0,[R1]
		BIC R0,#0xFF
		STR R0,[R1]
	
		LDR R1,=GPIO_PORTB_DEN
		LDR R0,[R1]
		ORR R0,#0xFF
		STR R0,[R1]
	
		LDR R1,=GPIO_PORTB_PUR_R
		MOV R0,#PUB
		STR R0,[R1]
		
		BX LR
		ENDP

		ALIGN
		END