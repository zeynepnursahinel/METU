SSI0_DR				EQU	0x40008008 ; Data 	
GPIO_PORTA_DATA		EQU	0x400043FC

					AREA	subroutine, READONLY, CODE
					THUMB					
					
					EXTERN 	DELAY10					
					EXPORT	ROW6
						
ROW6				PROC
					PUSH	{LR, R0, R1}	
					
					LDR 	R1,=SSI0_DR
					
;;; 6th row ---------------------------------------------------------

					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x40			;DC=0 (command)
					STR 	R0,[R1]					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x20		;H=0
					STR 	R0,[R1]
					BL		DELAY10
					MOV 	R0,#0x45		;6th row
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
					MOV     R0,#0x00
					STR     R0, [R1]					
					BL		DELAY10

;;; L --------------------------------------------------										
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x10					
					STR 	R0,[R1]
					MOV 	R0,#0x10					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
;;; I ---------------------------------------------------
					MOV 	R0,#0x1F						
					STR 	R0,[R1]					
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
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
;;;D----------------------------------------------------
					MOV 	R0,#0x1F					
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x11						
					STR 	R0,[R1]					
					MOV 	R0,#0x0E						
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
;;; = -------------------------------------------------									
					MOV 	R0,#0x14						
					STR 	R0,[R1]					
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x14					
					STR 	R0,[R1]
					MOV 	R0,#0x00
					STR 	R0,[R1]
					BL		DELAY10
					
;;; DISPLAY AMPLITUDE ------------------------------------
;;;-------------------------------------------------------

					POP		{LR, R0, R1}
					BX		LR
					ENDP						
					ALIGN
					END