			;************DELAY100**************
; Delay subroutine
; Input: R0  count
; Output: none
;When the delay subroutine is executed, the microp. does not execute other tasks.
					
				   AREA delayy, CODE, READONLY
				   THUMB
				   EXPORT DELAY
					   
DELAY			   PROC
				   SUBS R0, R0, #1                 ; R0 = R0 - 1 
				   BNE DELAY                    ; Until R0 = 0, it returns DELAY100 subroutine.
				   BX  LR                          ; returns to the main task
				   ENDP