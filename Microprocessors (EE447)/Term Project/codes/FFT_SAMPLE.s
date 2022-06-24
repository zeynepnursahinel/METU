NVIC_ST_CTRL 	EQU 0xE000E010
SAMPLE_ADDR 		EQU 0x20000400

			AREA    	fftransform, READONLY, CODE
			THUMB
			EXTERN		arm_cfft_q15
			EXTERN		arm_cfft_sR_q15_len256
			EXTERN 		MAGNITUDE
			EXPORT  	FFT_SAMPLE	

FFT_SAMPLE	PROC
			PUSH { LR, R2, R3}
			
			LDR R1 ,=NVIC_ST_CTRL
			MOV R0,#0
			STR R0,[R1]
			LDR	R0, =arm_cfft_sR_q15_len256
			LDR	R1, =SAMPLE_ADDR
			MOV R2, #0
			MOV R3, #1
			BL arm_cfft_q15
			
			BL MAGNITUDE
			
			LDR R1 ,=NVIC_ST_CTRL
			MOV R0,#3
			STR R0,[R1]
    		POP { LR, R2, R3}
			BX LR
			
			ENDP
			ALIGN
			END