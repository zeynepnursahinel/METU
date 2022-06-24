PB_IN				EQU		0X4000503C	; data adress to all input pins
PB_OUT				EQU		0X400053C0	; data adress to all input pins	

GPIO_PORTB_DIR_R 	EQU 0x40005400
GPIO_PORTB_AFSEL_R 	EQU 0x40005420
GPIO_PORTB_PUR_R 	EQU 0x40005510
	
GPIO_PORTB_DEN_R 	EQU 0x4000551C
GPIO_PORTB_LOCK_R 	EQU 0x40005520
GPIO_PORTB_CR_R 	EQU 0x40005524
	
SYSCTL_RCGCGPIO_R 	EQU 0x400FE608
	
					AREA |.text|, CODE, READONLY, ALIGN=2
					THUMB
					EXTERN OutChar
					EXPORT __main
			
__main  

		BL PortB_Init
loop
		
		LDR R0, =HUNDREDMSEC
		BL DELAY
		
		
		LDR R1,=PB_IN		;r1=0x4000503c
		LDR R2, [R1]		;read pb0-pb3
		LDR R1,=PB_OUT
		LDR R3, [R1]		;read pb4-pb7
		
		CMP R2, #0x0F ;all switches are off
		BEQ loop
	
		LSL R2, #4			;to compare pb7-4 with related switch
		EOR R3, R3, R2		;toggling acc to switch values
		EOR R3, R3,#0xF0	;Since switches are 0 when they are closed, and 1 when open
		;however toggling happens when they are 1(open).
	    ;therefore we need to EOR here. 
		
		LDR R0, =HUNDREDMSEC
	    BL DELAY

		LDR R1, =PB_OUT
		STR R3, [R1] ; write to PB4-7
		
		B loop
	
;**************DELAY***************
HUNDREDMSEC 	EQU 240963 ; 100ms delay at ~16 MHz clock,

DELAY
	NOP
	NOP
	SUBS R0, R0, #1 ; R0 = R0 - 1
	BNE DELAY
	BX LR
 
PortB_Init
	LDR R1, =SYSCTL_RCGCGPIO_R ; 1) activate clock for Port B
	LDR R0, [R1]
	ORR R0, R0, #0x02 ; set bit 5 to turn on clock
	STR R0, [R1]
	NOP
	NOP
	NOP ; allow time for clock to finish
	
	LDR R1, =GPIO_PORTB_LOCK_R ; 2) unlock the lock register
	LDR R0, =0x4C4F434B
	STR R0, [R1]
	LDR R1, =GPIO_PORTB_CR_R ; enable commit for Port B
	MOV R0, #0xFF
	STR R0, [R1] 
	
	; set direction register
	LDR R1, =GPIO_PORTB_DIR_R 
	MOV R0,#0xF0 ; PB 0-3 input, PB 4-7 output
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_AFSEL_R
	MOV R0, #0 ; 0: disable alternate function
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_PUR_R ; pull-up resistors for PB0-3
	MOV R0, #0x0F ; enable weak pull-up
	STR R0, [R1]
	
	LDR R1, =GPIO_PORTB_DEN_R ; 7) enable Port B digital port
	MOV R0, #0xFF ; 1: enable digital I/O
	STR R0, [R1]
	
	BX LR
		
	ALIGN
	END
