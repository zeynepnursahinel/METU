count		EQU         0x1770;0x5E24             			
			

			AREA    	main, READONLY, CODE
			THUMB
			EXPORT		DELAY10
				

DELAY10	    PROC
			PUSH{LR, R0}
            LDR		     R0,=count
			
loop	    SUBS		 R0,#0x1 		; approx 20ms	
            NOP                 		; approx 20ms		
			BNE			 loop  			; approx 60ms		
			
			POP{LR, R0}
			BX			  LR
			ALIGN
			END
			ENDP