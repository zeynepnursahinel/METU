SAMPLE_ADDR 		EQU 0x20000404
MAG_FREQ_ADDR		EQU 0x20000810
	
					AREA find , READONLY, CODE
					THUMB
					EXPORT MAGNITUDE ; Reference external subroutine
					EXTERN Convrt
					EXTERN OutStr
					EXTERN ledblink
					EXTERN FREQ_DISP
					EXTERN	AMP_DISP
						
MAGNITUDE 		    PROC
					PUSH {LR, R0, R1, R2, R3, R5, R6, R7, R8}
					
					MOV R9,#0   ;make the amplitude zero
					MOV R6,#127 ; counter(max 128 not 256 since fft is symmetric)
					MOV R7,#0 ;initialization of maximum value 
					
					LDR R0,=SAMPLE_ADDR 
					
mag_seek			LDR R1, [R0];real
					LDR R2, [R0],#4;imaginary
					LSR R2, #16
					MOV R3,#0x0000FFFF
					AND R1, R3
					NOP


					MOV R3,#0x00008000
					CMP R1,R3
					
					BHI real_neg	
real_pos			
					MUL R1, R1, R1  ;take it square to find mag 
					
					B imag_check
					
real_neg		    MOV R3,#0x0000FFFF
					EOR R1,R3
					ADD R1,#1
					MUL R1,R1,R1     ;take it square to find mag 
					
					B imag_check
					
imag_check		
					MOV R3,#0x00008000
					CMP R2,R3
					BHI neg_imag
					
pos_imag	
					MUL R2,R2,R2
					B finish
					
neg_imag  			MOV R3,#0x0000FFFF
					EOR R2,R3
					ADD R2,#1
					MUL R2,R2,R2
					B finish

finish				ADD R8,R1,R2
					CMP R8,R7
					
					MOVHI R7,R8
					
					MOVHI R9,R6 ; holds the counter of max mag
					
					SUBS R6,#1
					
					BNE mag_seek
					
					BL	AMP_DISP ;go to amplitude display subroutine
					
					MOV R3,#128 
					SUB R9,R3,R9; finding proper index value
					
					MOV R3,#2000
					MUL R9,R9,R3 ; index*2kHZ
					
					MOV R3,#256
					UDIV R9,R9,R3 ; index*2kHz/256 = max_mag_Frekans (fft formula)
					
					BL	FREQ_DISP ; go to frequency display subroutine		
					

					LDR R0,=MAG_FREQ_ADDR
					STR R7,[R0],#4	
					STR R9,[R0]
					BL ledblink
					POP {LR, R0, R1, R2, R3, R5, R6, R7, R8}
					BX LR
					
					ENDP
					ALIGN
					END