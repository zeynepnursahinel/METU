;LABEL DIRECTIVE VALUE COMMENT
				AREA main , CODE, READONLY
				THUMB
				EXTERN InitSysTick ; R e f e r e n c e e x t e r n a l s u b r o u ti n e
				EXPORT __main

__main PROC

Start 	BL PortBInit	; portb initialization
		BL InitSysTick	; initalize system timer
		CPSIE I 		; enable interrupts
	
	

	
	ENDP