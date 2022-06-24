
;Nested Vector Interrupt Controller registers
NVIC_EN0_INT19		EQU 0x00080000 ; Interrupt 19 enable
NVIC_EN0			EQU 0xE000E100 ; IRQ 0 to 31 Set Enable Register
NVIC_PRI4			EQU 0xE000E410 ; IRQ 16 to 19 Priority Register
	
; 16/32 Timer Registers
TIMER0_CFG			EQU 0x40030000
TIMER0_TAMR			EQU 0x40030004
TIMER0_CTL			EQU 0x4003000C
TIMER0_IMR			EQU 0x40030018
TIMER0_RIS			EQU 0x4003001C ; Timer Interrupt Status
TIMER0_ICR			EQU 0x40030024 ; Timer Interrupt Clear
TIMER0_TAILR		EQU 0x40030028 ; Timer interval
TIMER0_TAPR			EQU 0x40030038
TIMER0_TAR			EQU	0x40030048 ; Timer register
	
;GPIO Registers


GPIO_PORTD_DATA		EQU 0x4000703C ; Access BIT2
GPIO_PORTD_DIR 		EQU 0x40007400 ; Port Direction
GPIO_PORTD_AFSEL	EQU 0x40007420 ; Alt Function enable
GPIO_PORTD_DEN 		EQU 0x4000751C ; Digital Enable

GPIO_PORTF_DATA		EQU 0x40025044 ; Access BIT 0&4
GPIO_PORTF_DIR 		EQU 0x40025400 ; Port Direction
GPIO_PORTF_AFSEL	EQU 0x40025420 ; Alt Function enable
GPIO_PORTF_DEN 		EQU 0x4002551C ; Digital Enable
GPIO_PORTF_PUR		EQU 0x40025510 ; PullDown
GPIO_PORTF_IS		EQU 0x40025404 ; Interrupt
GPIO_PORTF_IBE		EQU 0x40025408 ; Interrupt
GPIO_PORTF_IEV		EQU 0x4002540C ; Interrupt
GPIO_PORTF_IM		EQU 0x40025410 ; Interrupt
GPIO_PORTF_RIS		EQU 0x40025414 ; Interrupt Status
GPIO_PORTF_ICR		EQU 0x4002541C ; Interrupt Clear
GPIO_PORTF_LOCK 	EQU 0x40025520	
GPIO_PORTF_OCR		EQU	0x40025524
;System Registers
SYSCTL_RCGCGPIO 	EQU 0x400FE608 ; GPIO Gate Control
SYSCTL_RCGCTIMER 	EQU 0x400FE604 ; GPTM Gate Control

;---------------------------------------------------
FREQ_ADR	EQU	0x20000814
FREQ_CONST	EQU	16000; 
Motor_Ctr	EQU 0x20002400	;bit 0: 0=cw,1=ccw
;---------------------------------------------------
					
			AREA 	routines, CODE, READONLY
			THUMB
			EXPORT 	MOTOR_CNTRL
			EXPORT	MOTOR_INIT
			EXPORT	BUTTON_CHECK

;---------------------------------------------------					
MOTOR_CNTRL	PROC
				PUSH { R0, R1, R2, R3, R4}
;-----------------------------------
			LDR R1, =TIMER0_TAILR ; initialize laod register
			LDR R2, =FREQ_ADR
			
			LDR	R2, [R2]
			MOV R3,#FREQ_CONST
			
			MOV R5,#0x0E
			MUL R2,R5
			
			SUB R2,R3,R2
			STR	R2, [R1] ;arrange tailr register acc to frequency
			
			; Rotation bit=0 cw, bit=1 ccw
start		LDR R1,=Motor_Ctr
			LDRB R2,[R1]
			AND  R2,#0x01
			CMP R2,#0x01
			BEQ ccw
			BNE is_cw
			
ccw			;counter clock wise return
			LDR R1,=GPIO_PORTD_DATA
			LDR R8,[R1]
			
			LSR R8,#1
			CMP R8,#0
			
			MOVEQ R8,#8
			
			STR R8,[R1] ; 1000_0000 to B7B6B5B4_0000 IN3: HIGH
		   
			B finish
			
is_cw 		CMP R2,#0x00
			BEQ cw
			B finish

cw			;clockwise return
			LDR R1,=GPIO_PORTD_DATA
			LDR R8,[R1]
			
			LSL R8,#1
			CMP R8,#16
			
			MOVEQ R8,#1
			
			STR R8,[R1] ;0001_0000 to B7B6B5B4_0000 IN1: HIGH
				
finish
				LDR	R1, =TIMER0_ICR
				MOV	R0,#0x01   ;clear interrupt register TATOCINT
				STR R0,[R1]
				
				POP { R0, R1, R2, R3, R4}
				BX 	LR 
				ENDP
;---------------------------------------------------
BUTTON_CHECK	PROC
				
				LDR	R0,=GPIO_PORTF_RIS
				LDR	R1,=GPIO_PORTF_ICR
				LDR	R3,=Motor_Ctr
				LDR	R2, [R0]
				
				ANDS R10, R2, #0x10	;check if cw
				BEQ	ccwcheck
				
				MOV R4,#0
				STR	R4,[R3]
				LDR	R5, [R1]
				MOV	R5,#0x11	;clear interrupts
				STR	R5, [R1]
				
ccwcheck		ANDS R10, R2, #0x1	;check if ccw
				BEQ	cnt
				
				MOV R4,#1
				STR	R4,[R3]
				
				LDR	R5, [R1]
				MOV	R5,#0x11	;clear interrupts
				STR	R5, [R1]
cnt	
				
				
				BX 	LR
				ENDP
;---------------------------------------------------
MOTOR_INIT	PROC
	
			
			LDR R1, =SYSCTL_RCGCGPIO ; start GPIO clock
			LDR R0, [R1]
			ORR R0, R0, #0x28 ; set bit 5,7 for port D, F
			STR R0, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			
			LDR 	R1 , =GPIO_PORTF_LOCK	;unlock
			LDR 	R0 , [ R1 ]
			MOV32 	R0 , #0x4C4F434B
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_OCR	;give acces to write enable
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x1
			STR 	R0 , [ R1 ]
			;gpio setting FOR SW1&2
			LDR 	R1 , =GPIO_PORTF_DIR 
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_AFSEL
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTF_DEN
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x11
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_PUR
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x11
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IS
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IBE
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IEV
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x11	;trigger in falling edge
			STR 	R0 , [ R1 ] 
			LDR 	R1 , =GPIO_PORTF_IM
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x11	;trigger in falling edge
			STR 	R0 , [ R1 ] 
			
			LDR R1, =NVIC_EN0
			LDR	R0, [R1]
			ORR R0, #0x40000000
			STR R0, [R1]
			
			CPSIE  I
			
			;gpio setting
			LDR 	R1 , =GPIO_PORTD_DIR 
			LDR 	R0 , [ R1 ]
			MOV 	R0 , #0x0F
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTD_AFSEL
			LDR 	R0 , [ R1 ]
			BIC 	R0 , #0x0F
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTD_DEN
			LDR 	R0 , [ R1 ]
			ORR 	R0 , #0x0F
			STR 	R0 , [ R1 ]
			LDR 	R1 , =GPIO_PORTD_DATA
			LDR 	R0 , [ R1 ]
			BIC     R0,#0xFF
			ORR 	R0 , #0x01
			STR 	R0 , [ R1 ]
		
			LDR R1, =SYSCTL_RCGCTIMER ; Start Timer0
			LDR R2, [R1]
			ORR R2, R2, #0x01
			STR R2, [R1]
			NOP ; allow clock to settle
			NOP
			NOP
			LDR R1, =TIMER0_CTL ; disable timer during setup 
			LDR R2, [R1]
			BIC R2, R2, #0x01
			STR R2, [R1]
			LDR R1, =TIMER0_CFG ; set 16 bit mode
			MOV R2, #0x04
			STR R2, [R1]
			LDR R1, =TIMER0_TAMR
			MOV R2, #0x02 ; set to periodic, count down
			STR R2, [R1]
			LDR R1, =TIMER0_TAILR ; initialize match clocks
			LDR R2, =FREQ_ADR
			LDR	R2, [R2]
			STR R2, [R1]
			LDR R1, =TIMER0_TAPR
			MOV R2, #15 ; divide clock by 16 to
			STR R2, [R1] ; get 1us clocks
			LDR R1, =TIMER0_IMR ; enable timeout interrupt
			MOV R2, #0x01
			STR R2, [R1]
; Configure interrupt priorities
; Timer0A is interrupt #19.
; Interrupts 16-19 are handled by NVIC register PRI4.
; Interrupt 19 is controlled by bits 31:29 of PRI4.
; set NVIC interrupt 19 to priority 2
			LDR R1, =NVIC_PRI4
			LDR R2, [R1]
			AND R2, R2, #0x00FFFFFF ; clear interrupt 19 priority
			ORR R2, R2, #0x40000000 ; set interrupt 19 priority to 2
			STR R2, [R1]
; NVIC has to be enabled
; Interrupts 0-31 are handled by NVIC register EN0
; Interrupt 19 is controlled by bit 19
; enable interrupt 19 in NVIC
			LDR R1, =NVIC_EN0
			MOVT R2, #0x08 ; set bit 19 to enable interrupt 19
			STR R2, [R1]
; Enable timer
			LDR R1, =TIMER0_CTL
			LDR R2, [R1]
			ORR R2, R2, #0x03 ; set bit0 to enable
			STR R2, [R1] ; and bit 1 to stall on debug
			BX LR ; return
			ENDP
				
			ALIGN
			END