;*************************************************************** 
; Program_Directives.s  
;***************************************************************
LOW EQU 0x00000028 ;160 cycle*250ns = 40us
FIRST EQU 0x20000400
; 16/31 Timer Registers
TIMER3_CFG EQU 0x40033000
TIMER3_TAMR EQU 0x40033004
TIMER3_CTL EQU 0x4003300C
TIMER3_IMR EQU 0x40033018
TIMER3_RIS EQU 0x4003301C ; Timer Interrupt Status
TIMER3_ICR EQU 0x40033024 ; Timer Interrupt Clear
TIMER3_TAILR EQU 0x40033028 ; Timer interval
TIMER3_TAPR EQU 0x40033038
TIMER3_TAR EQU 0x40033048 ; Timer register
	
;GPIO Registers B access
GPIO_PORTB_DATA EQU 0x40005010 ; Access BIT2
;***************************************************************
; Program section					      
;***************************************************************
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		PULSE_INIT
			EXTERN		Timer_init
			EXTERN		OutStr
			EXTERN		Convrt
			EXPORT  	__main	; Make available

__main		PROC
			BL PULSE_INIT
			BL Timer_init
			MOV R8,#LOW
start		MOV R4,#0x00 		;counter for edges
			
read_flag	LDR R1,=TIMER3_RIS	;polling for RIS 
			LDR R0,[R1]
			STR R0,[R4]
			CMP R0,#0x04		;if capture flag is high
			BNE read_flag
			BEQ flag_high		;go to flag_high 

flag_high 
			ADDS R4,#1			;add counter by 1
			LDR R1,=TIMER3_ICR 	;clear capture flag
			MOV R0,#0xFF
			STR R0,[R1]
			
			LDR R1,=TIMER3_TAR  ;loading current TAR value
			LDR R2,[R1]
			
			CMP R4,#1
			BEQ first_val		;first edge value
			
			CMP R4,#2
			BEQ second_val		;second edge value
			
			CMP R4,#3
			BEQ third_val		;third edge value
			
			CMP R4,#4			;when counter is 4 go to exit
			BEQ display
			
first_val  MOV R12,R2			;copying TAR value at the first edge
		   MOV R1,#62
		   MUL R12,R12,R1
		   B read_flag
		   
second_val MOV R6,R2			;copying TAR value at the second edge
		   MOV R1,#62
		   MUL R6,R6,R1
		   B read_flag
		   
third_val MOV R10,R2			;copying TAR value at the third edge
		  MOV R1,#62
		  MUL R10,R10,R1
		  B read_flag
		  

display		SUB R10,R6 ;high pulse-width
			LDR R5,=FIRST
			MOV R4,R10
			
			;in case of reverse
			;SUB R6,R12 ;high pulse-width
			;LDR R5,=FIRST
			;MOV R4,R6
			
			BL Convrt
			BL OutStr
			
			SUB R6,R12 ; low pulse-width
			ADD R11,R6,R10
			LDR R5,=FIRST
			MOV R4,R11 ;period (iki araligin toplami)
			
			;in case of reverse
			;SUB R11,R10,R12 ; low pulse-width
			;LDR R5,=FIRST
			;MOV R4,R11 ;period (iki araligin toplami)
			
			BL Convrt
			BL OutStr
			
			MOV R0,#100
			MUL R10,R10,R0
			UDIV R10,R11 ; duty cycle
			LDR R5,=FIRST
			MOV R4,R10
			
			;in case of reverse
			;MOV R0,#100
			;MUL R6,R6,R0
			;UDIV R6,R11 ; duty cycle
			;LDR R5,=FIRST
			;MOV R4,R6
			
			BL Convrt
			BL OutStr
	
			B exit
			
exit		NOP

			B start
		
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END
