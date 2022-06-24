;******* 
; Program_Directives.s  
; Copies the table from one location
; to another memory location.           
; Directives and Addressing modes are   
; explained with this program.   
;*******
ADC0_RIS 		EQU 0x40038004 ; Interrupt status
ADC0_PSSI 		EQU 0x40038028 ; Initiate sample	
ADC0_SSFIFO3 	EQU 0x400380A8 ; Channel 3 results
ADC0_ISC		EQU	0x4003800C	
MY_ADDR 		EQU 0x20000400
ONESEC			EQU 5333330
;*******
; Program section					      
;*******
;LABEL		DIRECTIVE	VALUE		COMMENT
			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		ATD_PORT_INIT
			EXTERN		OutStr
			EXTERN		OutChar
			EXTERN		Convrt
			EXTERN		DELAY
			EXPORT  	__main	; Make available

__main		PROC
			BL ATD_PORT_INIT
start	
			; start sampling routine
			LDR R3, =ADC0_RIS ; interrupt address
			LDR R1, =ADC0_SSFIFO3 ; result address
			LDR R2, =ADC0_PSSI ; sample sequence initiate address
			LDR R6,= ADC0_ISC ;interrupt status clear reg
			LDR R5,=MY_ADDR
			
			; initiate sampling by enabling sequencer 3 in ADC0_PSSI
Sample 		LDR R0, [R2]
			ORR R0, R0, #0x08 ; set bit 3 for SS3
			STR R0, [R2]
			
			; check for sample complete (bit 3 of ADC0_RIS set)
Cont 		LDR R0, [R3]
			ANDS R0, R0, #8
			BEQ Cont ;if flag is 0
			
			;branch fails if the flag is set so data can be read and flag is cleared
			LDR R0,[R1]
			;STR R0,[R5],#4 ;store the data
			SUB R0,#0x800 ;substract 2048 == 1.65V
			
			ANDS R7,R0,#0x80000000
			BNE negative
			
display_pos	
			MOV R8,#165
			MUL R0,R8
			MOV R8,#0x800
			UDIV R0,R8
			MOV R4,R0
			BL Convrt
			BL OutStr
			MOV R0, #8
			STR R0, [R6] ; clear flag
			LDR R0, =ONESEC
			BL DELAY
			B Sample
			
display_neg	
			MOV R8,#165
			MUL R0,R8
			MOV R8,#0x800
			UDIV R0,R8
			
;print minus
			PUSH {R5}
			MOV R5, "-"
			BL	OutChar
			POP {R5}
			
			MOV R4,R0
			BL Convrt
			BL OutStr
			MOV R0, #8
			STR R0, [R6] ; clear flag
			LDR R0, =ONESEC
			BL DELAY
			B Sample
			
negative	EOR R0,#0xFFFFFFFF
			ADD R0,R0,#1
			B display_neg
			
			B start
			ENDP
;*******
; End of the program  section
;*******
;LABEL      DIRECTIVE       VALUE                           COMMENT
			ALIGN
			END