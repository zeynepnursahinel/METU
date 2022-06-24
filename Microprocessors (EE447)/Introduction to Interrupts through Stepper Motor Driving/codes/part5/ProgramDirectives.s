;*************************************************************** 
; Program_Directives.s 
;LABEL DIRECTIVE VALUE COMMENT
OFFSET EQU 0x10
FIRST EQU 0x20000400
GPIO_PORTB_DATA_READ EQU 0x4000503C ; data address to read pins B0-B3 0000_0011_1100
RELOAD_VALUE_ADDR EQU 0xE000E014
;LABEL DIRECTIVE VALUE COMMENT
					AREA main, READONLY, CODE
					THUMB
					EXTERN PortBInit
					EXTERN InitSysTick
					EXTERN delay
					#
start 	BL PortBInit
		CPSIE I ; enable interrupts

		LDR R0,=RELOAD_VALUE_ADDR
		MOV R1,#8000
		STR R1,[R0]
		BL InitSysTick ; initialize system timer
		BIC R8,#0xFF
		MOV R8,#128;

debounce LDR R1,=GPIO_PORTB_DATA_READ
		BIC R2,#0xFF
		LDR R2,[R1]
		BL delay
		BIC R3,#0xFF
		LDR R3,[R1]
		CMP R2,R3 ;R3 = R2 = read_data = 0000_B3B2B1B0
		BNE debounce
		B release_check

release_check

debounce2 LDR R1,=GPIO_PORTB_DATA_READ
		  BIC R4,#0xFF
		  LDR R4,[R1]
		  BL delay
		  BIC R5,#0xFF
		  LDR R5,[R1]
		  CMP R4,R5 ;R4 = R5 = read_data = 0000_B3B2B1B0
		  BNE debounce2
		  
		  CMP R2,R4; R2 x= R4 = read_data = 0000_B3B2B1B0
		  BNE released
		  BEQ release_check
		  
released ;ccw if R9==1, cw if R9==2; 1110 for 1; 1101 for 2
		LDR R0,=RELOAD_VALUE_ADDR
		LDR R1,[R0]

		CMP R3,#14
		MOVEQ R9,#0x01
		BEQ debounce

		CMP R3,#13
		MOVEQ R9,#0x02
		BEQ debounce
		
		CMP R3,#11 ;yavaslama
		BEQ yavaslama
		
		
		CMP R3,#7 ;hizlanma
		BEQ hizlanma
		B debounce
		
yavaslama ADD R1,#2000
		  STR R1,[R0]
		  B debounce
		  
hizlanma CMP R1,#8000
		 SUB R1,#2000
		 MOVEQ R1,#8000
		 STR R1,[R0]
		 B debounce

		ENDP
		ALIGN
		END
