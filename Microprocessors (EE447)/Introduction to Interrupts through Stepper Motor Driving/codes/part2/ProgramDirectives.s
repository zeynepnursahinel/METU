;*************************************************************** 
; Program_Directives.s
; Two buttons from 4*4 Keypad
RELOAD_VALUE_ADDR EQU 0xE000E014
GPIO_PORTB_DATA_READ EQU 0x4000503C ; data address to read pins B0-B3 0000_0011_1100
GPIO_PORTB_DATA EQU 0x400053FC ; data address to all pins
;***************************************************************
; Program section 
;***************************************************************
;LABEL DIRECTIVE VALUE COMMENT
				AREA main, READONLY, CODE
				THUMB
				EXTERN PortBInit
				EXTERN InitSysTick
				EXTERN delay
				EXPORT __main ; Make available

__main PROC
				BL PortBInit
				LDR R0,=RELOAD_VALUE_ADDR

				MOV R1,#8000
				STR R1,[R0]
				
				BL InitSysTick ; initialize system timer
				CPSIE I ; enable interrupts
				BIC R8,#0xFF
				MOV R8,#128;
				
start_line1 	LDR R1,=GPIO_PORTB_DATA
				LDR R0,[R1]
				BIC R0,#0xFF
				MOV R0,#0x70;
				STR R0,[R1] ;write 0111_0000 to B7B6B5B4_0000 B7 line is activated
				
loop1 			LDR R1,=GPIO_PORTB_DATA_READ
				BIC R2,#0xFF
				LDR R2,[R1]
				PUSH {R2,R1}
				BL delay
				POP {R2,R1}
				BIC R3,#0xFF
				LDR R3,[R1]
				CMP R3,R2 ;R3 = R2 = read_data = 0000_B3B2B1B0
				BNE loop1 ;debouncing
				
				CMP R3,#0x07
				MOVEQ R4,#1 ;button 1 is pressed
				BEQ button1
				
				CMP R3,#0x0B
				MOVEQ R4,#2 ;button 2 is pressed
				BEQ button2

				B start_line1
button1 
loop5 			LDR R1,=GPIO_PORTB_DATA_READ
				BIC R2,#0xFF
				LDR R2,[R1]
				CMP R2,#0x0F
				BNE loop5 ;debouncing
				PUSH {R2,R1}
				BL delay
				POP {R2,R1}
				
				BIC R3,#0xFF
				LDR R3,[R1]
				CMP R3,R2 ;R3 = R2 = read_data = 0000_B3B2B1B0
				BNE loop5 ;debouncing
				MOV R9,#1				
				B start_line1
button2
loop6 			LDR R1,=GPIO_PORTB_DATA_READ
				BIC R2,#0xFF
				LDR R2,[R1]
				CMP R2,#0x0F
				BNE loop6 ;debouncing
				PUSH {R2,R1}
				BL delay
				POP {R2,R1}
				BIC R3,#0xFF
				LDR R3,[R1]
				CMP R3,R2 ;R3 = R2 = read_data = 0000_B3B2B1B0
				BNE loop5 ;debouncing
				MOV R9,#2
				B start_line1
				
				ENDP
				ALIGN
				END


