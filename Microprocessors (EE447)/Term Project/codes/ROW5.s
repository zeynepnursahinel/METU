SSI0_DR				EQU	0x40008008 ; Data 	
GPIO_PORTA_DATA		EQU	0x400043FC

					AREA	subroutine, READONLY, CODE
					THUMB					
					
					EXTERN 	DELAY10					
					EXPORT	ROW5
						
ROW5			PROC
					PUSH	{LR, R0, R1}	
					
					LDR 	R1,=SSI0_DR

;;; 5th row ------------------------------------------------------

					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40	    ;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					BL		DELAY10
					MOV 	R0,#0x44		;5th row
					STR 	R0,[R1]
					MOV 	R0,#0x80
					STR 	R0,[R1]
					BL		DELAY10
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40	    ;DC=1 (data)
					STR 	R0,[R1]
					LDR 	R1,=SSI0_DR	
;;; F -----------------------------------------------------									
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x05					
					STR 	R0,[R1]
					MOV 	R0,#0x01					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]	
					BL		DELAY10
;;; R -----------------------------------------------------									
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x05					
					STR 	R0,[R1]					
					MOV 	R0,#0x0D
					STR 	R0,[R1]
					MOV 	R0,#0x17
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
					
;;; E --------------------------------------------------						
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]														
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
					
;;; Q -----------------------------------------------------									
					MOV 	R0,#0x06						
					STR 	R0,[R1]					
					MOV 	R0,#0x09					
					STR 	R0,[R1]
					MOV 	R0,#0x09					
					STR 	R0,[R1]
					MOV 	R0,#0x16
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;; U --------------------------------------------------						
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x10						
					STR 	R0,[R1]					
					MOV 	R0,#0x10						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;; E --------------------------------------------------						
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]														
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
										
;;; N --------------------------------------------------						
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x02						
					STR 	R0,[R1]					
					MOV 	R0,#0x04						
					STR 	R0,[R1]					
					MOV 	R0,#0x08						
					STR 	R0,[R1]	
					MOV 	R0,#0x1F					
					STR 	R0,[R1]	
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; C --------------------------------------------------						
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]	
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; Y --------------------------------------------------						
					MOV 	R0,#0x03					
					STR 	R0,[R1]					
					MOV 	R0,#0x1C						
					STR 	R0,[R1]					
					MOV 	R0,#0x03						
					STR 	R0,[R1]					
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; = ------------------------------------------------------------									
					MOV 	R0,#0x14						
					STR 	R0,[R1]					
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;; DISPLAY FREQUENCY VALUE ---------------------------------------				
;;----------------------------------------------------------------


					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40			;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					MOV 	R0,#0xC6		;horizontal
					STR 	R0,[R1]
					BL		DELAY10
					
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40			;DC=1 (data)
					STR 	R0,[R1]	
					
					LDR 	R1,=SSI0_DR	
;;; H ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x04					
					STR 	R0,[R1]
					MOV 	R0,#0x04					
					STR 	R0,[R1]
					MOV 	R0,#0x1F						
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; Z ------------------------------------------------------------									
					MOV 	R0,#0x19						
					STR 	R0,[R1]					
					MOV 	R0,#0x15					
					STR 	R0,[R1]
					MOV 	R0,#0x13					
					STR 	R0,[R1]
					MOV 	R0,#0x00						
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
					




					POP		{LR, R0, R1}
					BX		LR
					ENDP						
					ALIGN
					END