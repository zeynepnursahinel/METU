;*********************
; Program_Drectves.s
;*********************
ADC0_RIS EQU 0x40038004 ; Interrupt status
ADC0_PSSI EQU 0x40038028 ; Intate sample
ADC0_SSFIFO3 EQU 0x400380A8 ; Channel 3 results
ADC0_ISC EQU 0x4003800C
;*********************
; Program secton
;*********************
;LABEL DIRECTIVE VALUE COMMENT
				AREA man, READONLY, CODE
				THUMB
				EXTERN ATD_PORT_INIT
				EXTERN OutStr
				EXTERN Convrt
				EXPORT __main; Make avalable
__main PROC
				BL ATD_PORT_INIT
start
; start samplng routne
				LDR R3, =ADC0_RIS ; nterrupt address
				LDR R1, =ADC0_SSFIFO3 ; result address
				LDR R2, =ADC0_PSSI ; sample sequence ntate address
				LDR R6,= ADC0_ISC ;nterrupt status clear reg
				; ntate samplng by enablng sequencer 3 n ADC0_PSSI
Sample  		LDR R0, [R2]
				ORR R0, R0, #0x08 ; set bt 3 for SS3
				STR R0, [R2]
				; check for sample complete (bt 3 of ADC0_RIS set)
Cont 			LDR R0, [R3]
				ANDS R0, R0, #8
				BEQ Cont ;f flag s 0
				;branch fals f the flag s set so data can be read and flag s cleared
				LDR R0,[R1]
				;STR R0,[R5],#4 ;store the data
				MOV R4,R0
				BL Convrt
				BL OutStr
				MOV R0, #8
				STR R0, [R6] ; clear flag
				B Sample
				B ext
ext 			NOP
				B start
				ENDP
				;*********************
				; End of the program secton
				;*********************
				;LABEL DIRECTIVE VALUE COMMENT
				ALIGN
				END