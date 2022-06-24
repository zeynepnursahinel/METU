			AREA    	main, READONLY, CODE
			THUMB
			EXPORT		DELAY100
				
count		EQU         0x3AD68             ; its decimal equivalent is 241 000			
			
DELAY100    PROC
			PUSH{LR}
            LDR		     R0,=count
			
loop	    SUBS		 R0,#0x1 		; approximately 20ms	
            NOP                 		; approximately 20ms		
			BNE			 loop  			; approximately 60ms		
			
			POP{LR}
			BX			  LR
			ALIGN
			END
			ENDP