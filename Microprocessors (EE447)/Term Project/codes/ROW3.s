SSI0_DR				EQU	0x40008008 ; Data 	
GPIO_PORTA_DATA		EQU	0x400043FC

					AREA	subroutine, READONLY, CODE
					THUMB					
					
					EXTERN 	DELAY10					
					EXPORT	ROW3
						
ROW3			   	PROC
					PUSH	{LR, R0, R1}	
					
					LDR 	R1,=SSI0_DR


;3rd row---------------------
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40			;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					BL		DELAY10
					MOV 	R0,#0x42		;3rd row
					STR 	R0,[R1]
					MOV 	R0,#0x80
					STR 	R0,[R1]
					BL		DELAY10
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40			;DC=1 (data)
					STR 	R0,[R1]
					LDR 	R1,=SSI0_DR	
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
;;; P --------------------------------------------------										
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x05					
					STR 	R0,[R1]
					MOV 	R0,#0x05					
					STR 	R0,[R1]
					MOV 	R0,#0x07
					STR 	R0,[R1]
					BL		DELAY10
;;; P ----------------------------------------------------								
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x05					
					STR 	R0,[R1]
					MOV 	R0,#0x05					
					STR 	R0,[R1]
					MOV 	R0,#0x07
					STR 	R0,[R1]
					BL		DELAY10
;;;'  '----------------------------------------------------											
					MOV 	R0,#0x00						
					STR 	R0,[R1]	
					MOV 	R0,#0x00
					STR 	R0,[R1]
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
;;; Q -----------------------------------------------------									
					MOV 	R0,#0x06						
					STR 	R0,[R1]					
					MOV 	R0,#0x09					
					STR 	R0,[R1]
					MOV 	R0,#0x09					
					STR 	R0,[R1]
					MOV 	R0,#0x16
					STR 	R0,[R1]
					BL		DELAY10
;;; ' '------------------------------------------------------											
					MOV 	R0,#0x00						
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
;;; T --------------------------------------------------------									
					MOV 	R0,#0x01						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F					
					STR 	R0,[R1]
					MOV 	R0,#0x01					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
					
;;; H --------------------------------------------------------									
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
;;; R ---------------------------------------------------------									
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
;;; ' '---------------------------------------------------------											
					MOV 	R0,#0x00						
					STR 	R0,[R1]				
;;; = ----------------------------------------------------------									
					MOV 	R0,#0x14						
					STR 	R0,[R1]
					MOV 	R0,#0x14						
					STR 	R0,[R1]					
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;; display ----------------------------------------------------

					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40			;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					MOV 	R0,#0xB2		;horizontal
					STR 	R0,[R1]
					BL		DELAY10
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40			;DC=1 (data)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR	
;;; 5 ------------------------------------------------------------									
					MOV 	R0,#0x17					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1D						
					STR 	R0,[R1]										
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; 5 -------------------------------------------------------------									
					MOV 	R0,#0x17					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1D						
					STR 	R0,[R1]										
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; 0 --------------------------------------------------------------									
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
					
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
;;; H -----------------------------------------------------------									
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