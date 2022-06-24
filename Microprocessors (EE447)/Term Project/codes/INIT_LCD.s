;BASE ADDRESS SSI0 = 0x40008000	
SYSCTL_RCGCSSI	EQU 0x400FE61C 		; SSI clock register
SYSCTL_PRSSI	EQU 0x400FEA1C 		; SSI Peripheral
SSI0_CR0		EQU	0x40008000 		; Control 0 to clk rate 
SSI0_CR1		EQU	0x40008004 		; Control 1 to enable SSI
SSI0_CPSR		EQU	0x40008010 		; Clock Prescale
SSI0_DR			EQU	0x40008008 		; ssi0 data register


SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO clock register
GPIO_PORTA_DIR 		EQU 0x40004400 ; PortA direction
GPIO_PORTA_AFSEL	EQU 0x40004420 ; PortA Alternate function select
GPIO_PORTA_DEN 		EQU 0x4000451C ; PORTA digital
GPIO_PORTA_AMSEL 	EQU 0x40004528 ; PortA Analog mode select
GPIO_PORTA_PCTL 	EQU 0x4000452C ; PORTA PCTL
GPIO_PORTA_PUR 		EQU 0x40004510
GPIO_PORTA_LOCK		EQU	0x40004520		
GPIO_PORTA_CR		EQU	0x40004524	
GPIO_PORTA_DATA		EQU	0x400043FC ;PortA Data Register 
	
					AREA 	subroutine, CODE, READONLY
					THUMB
					
					EXTERN	DELAY100
					EXPORT	INIT_LCD
					

INIT_LCD			PROC
	
					PUSH	{LR}
					
;------------------PORTA Init-------------------------------------------------					
					LDR 	R1,=SYSCTL_RCGCGPIO  ;1-enable PortA clk
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x01
					STR 	R0,[R1] 
					NOP
					NOP
					NOP
					
					LDR 	R1,=GPIO_PORTA_LOCK	;2-unlock porta		
					LDR 	R0,=0x4C4F434B				
					STR 	R0,[R1]
					LDR 	R1,=GPIO_PORTA_CR			
					MOV 	R0,#0xFF			
					STR 	R0,[R1]
					
					
					LDR 	R1,=GPIO_PORTA_DIR  ;3-set direction as output  
					LDR 	R0,[R1]
					ORR 	R0,R0,#0xEF
					STR 	R0,[R1]
					
					LDR 	R1,=GPIO_PORTA_AFSEL ;4-function select
					MOV 	R0,#0x3C
					STR 	R0,[R1]
					
					LDR 	R1,=GPIO_PORTA_DEN ;5-set porta pins as outputs 
					MOV 	R0,#0xFF
					STR 	R0,[R1]
					
					LDR 	R1,=GPIO_PORTA_PCTL ;6-set pctl 
					MOV32 	R0,#0x00222200
					;A2-ssi0clk
					;A3-ssi0Fss
					;A4-ssi0Rx------not used 
					;A5-ssi0Tx
					STR 	R0,[R1]
					
;--------------------SSI Init---------------------------------------------------
					
					LDR 	R1,=SYSCTL_RCGCSSI ;1-set ssi0clk
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x01
					STR 	R0,[R1] 
					
					LDR 	R1,=SYSCTL_PRSSI 
					
wait				LDR 	R0,[R1]           ;2-wait for the SSI peripheral to be ready
					AND 	R0,R0,#0x01
					CMP 	R0,#0x01
					BNE		wait
					
					LDR 	R1,=SSI0_CR1      ;3- Disable the SPI interface
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x02
					STR 	R0,[R1]
					
					LDR 	R1,=SSI0_CR0     ;4-Set the clock rate of the SPI Clock
					LDR 	R0,[R1]					
					MOV		R2,#0xFF3F
					BIC 	R0,R0,R2		;clear the all bits except sph and spio			
					MOV		R2,#0x01C7
					ORR 	R0,R0,R2	
					;scr =1   scr clock rate
					;sph=1    Data is captured on the second clock edge transition
					;spo=1    A steady state High value is placed on the SSInClk pin when
							  ;data is not being transferred.
					;frf=00   frescale spi frame format
					;dss=0111 data size select = 8 bit data
					STR 	R0,[R1]
					
					LDR 	R1,=SSI0_CPSR   ; clk prescale divisor
					LDR 	R0,[R1]
					MOV 	R0,#20          
					STR 	R0,[R1]
					
					LDR 	R1,=SSI0_CR1   ;7-Re-enable the SPI interface
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x02
					STR 	R0,[R1]
					
;-----------------Nokia 5110 LCD Config-----------------------------------------

					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					BIC 	R0,R0,#0x80    ;set reset pin (A7) low
					STR 	R0,[R1]
					
					BL		DELAY100       ;delay 100 msec
					
					ORR 	R0,R0,#0x80	   ;set reset pin (A7) high
					STR 	R0,[R1]
					
					BIC 	R0,R0,#0x40    ;clear DC(A6) pin ->command
					STR 	R0,[R1]
					
					LDR 	R1,=SSI0_DR 
					MOV 	R0,#0x21       ;power down control db5=1 H=1, V=0
					STR 	R0,[R1]
					
					MOV 	R0,#0xc0  	   ;vop6=1 
					STR 	R0,[R1]
					
					MOV 	R0,#0x07      ;temperature control
					STR 	R0,[R1]
					
					MOV 	R0,#0x13	  ;voltage bias 0x13
					STR 	R0,[R1]
					
					MOV 	R0,#0x20	  ;H=0
					STR 	R0,[R1]
					
					MOV 	R0,#0x0C
					STR 	R0,[R1]
					
					BL		DELAY100
					
					MOV 	R0,#0x40
					STR 	R0,[R1]
					
					MOV 	R0,#0x80       ; Configure for Normal Display Mode
					STR 	R0,[R1]
					
					BL		DELAY100
					
					LDR 	R1,=GPIO_PORTA_DATA 
					LDR 	R0,[R1]
					ORR 	R0,R0,#0x40			;Set Cursor to detemine the start address
					STR 	R0,[R1]
					
					POP		{LR}
					BX		LR
					ENDP						
					ALIGN
					END