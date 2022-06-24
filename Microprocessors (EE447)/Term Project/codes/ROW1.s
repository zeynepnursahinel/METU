SSI0_DR				EQU	0x40008008 ; Data 	
GPIO_PORTA_DATA		EQU	0x400043FC

					AREA	subroutine, READONLY, CODE
					THUMB					
					
					EXTERN 	DELAY10					
					EXPORT	ROW1
						
ROW1			   	PROC
					PUSH	{LR, R0, R1}	
					
					LDR 	R1,=SSI0_DR

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40			;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					BL		DELAY10
					MOV 	R0,#0x40		;1st row
					STR 	R0,[R1]
					MOV 	R0,#0x80
					STR 	R0,[R1]
					BL		DELAY10
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40			;DC=1 (data)
					STR 	R0,[R1]
					LDR 	R1,=SSI0_DR	
;;; A ------------------------------------------------------						
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x05						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]															
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;; M -------------------------------------------------------										
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x01					
					STR 	R0,[R1]
					MOV 	R0,#0x07					
					STR 	R0,[R1]
					MOV 	R0,#0x01						
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
;;;  --------------------------------------------------------										
					MOV 	R0,#0x00						
					STR 	R0,[R1]	
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;; T -------------------------------------------------------									
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
					
;;; = --------------------------------------------------------------									
					MOV 	R0,#0x14						
					STR 	R0,[R1]					
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;;; DISPLAY NUMBER ------------------------------------------------					
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40		;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					MOV 	R0,#0xB2		;horizontal
					STR 	R0,[R1]
					BL		DELAY10
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40		;DC=1 (data)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR	
;;; 3 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
					MOV 	R0,#0x15					
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x15						
					STR 	R0,[R1]					
					MOV 	R0,#0x1F						
					STR 	R0,[R1]										
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10	
;;; 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
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
;;; 0 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;									
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

					POP		{LR, R0, R1}
					BX		LR
					ENDP
						
						
					ALIGN
					END