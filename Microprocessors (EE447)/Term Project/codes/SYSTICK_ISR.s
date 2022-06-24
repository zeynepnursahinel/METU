ADC0_RIS EQU 0x40038004 ; Interrupt status
ADC0_PSSI EQU 0x40038028 ; Initiate sample	
ADC0_SSFIFO3 EQU 0x400380A8 ; Channel 3 results
ADC0_ISC	EQU	0x4003800C	
SAMPLE_ADDR EQU 0x20000400
NVIC_ST_CTRL 	EQU 0xE000E010	

			AREA    	main, READONLY, CODE
			THUMB
			EXTERN		FFT_SAMPLE
			EXPORT  	SYSTICK_ISR	

SYSTICK_ISR	PROC

    		PUSH {LR, R1, R2, R3, R9}
			
			; start sampling routine
			LDR R1, =ADC0_RIS 		; raw interrupt status address
			LDR R2, =ADC0_SSFIFO3 	; result register address
			LDR R3,= ADC0_ISC       ;interrupt status clear reg

Cont 		LDR R0, [R1]
			ANDS R0, R0, #8
			BEQ Cont ;if flag is 0
			;branch fails if the flag is set so data can be read and flag is cleared
			LDR R9,[R2]
			SUB R9,#0x610 ;substract 1552 == 1.25V
			
			LSL R9, #16
			
			STR R9,[R4],#4 ;store the data
			
			MOV R0, #8
			STR R0, [R3] ; clear flag
			
			SUB R11,#1
			CMP R11,#0
			
			BEQ FFT
			
			BNE Finish
			
FFT			BL FFT_SAMPLE	
			LDR R4,=SAMPLE_ADDR
			MOV R11,#256
			NOP
			
Finish		POP {LR, R1, R2, R3, R9}
			BX LR
			ENDP
			ALIGN
			END