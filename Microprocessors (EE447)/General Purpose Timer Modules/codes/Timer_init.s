;Pulse.s
; This uses Channel 0, and a 1MHz Timer Clock (_TAPR = 15)
; Uses Timer0B to read and measure width, period and duty cycle
; Timer0B loc: TIMER1 EQU 0 x40031000

; 16/31 Timer Registers
TIMER3_CFG EQU 0x40033000
TIMER3_TAMR EQU 0x40033004
TIMER3_CTL EQU 0x4003300C
TIMER3_IMR EQU 0x40033018
TIMER3_RIS EQU 0x4003301C ; Timer Interrupt Status
TIMER3_ICR EQU 0x40033024 ; Timer Interrupt Clear
TIMER3_TAILR EQU 0x40033028 ; Timer interval
TIMER3_TAPR EQU 0x40033038
TIMER3_TAR EQU 0x40033048 ; Timer register
	
;GPIO Registers B ile degistir!
GPIO_PORTB_DATA EQU 0x40005010 ; Access BIT2
GPIO_PORTB_DIR EQU 0x40005400 ; Port Direction
GPIO_PORTB_AFSEL EQU 0x40005420 ; Alt Function enable
GPIO_PORTB_DEN EQU 0x4000551C ; Digital Enable      
GPIO_PORTB_AMSEL EQU 0x40005528 ; Analog enable
GPIO_PORTB_PCTL EQU 0x4000552C ; Alternate Functions          

; System Registers        
SYSCTL_RCGCGPIO EQU 0x400FE608 ; GPIO Gate Control    
SYSCTL_RCGCTIMER EQU 0x400FE604 ; GPTM Gate Control 
COUNTER_MAX_VAL EQU	 0xFFFFFFFF	
	
					AREA Timer3_init, CODE, READONLY
					THUMB
					EXPORT Timer_init


Timer_init  PROC
			LDR R1 ,=SYSCTL_RCGCGPIO ; start GPIO clock       
			LDR R0 , [R1]
			ORR R0 , R0 , #0x02 ; set bit [1] for port B     
			STR R0 , [R1]
			NOP ; allow clock to settle           
			NOP
			NOP
			LDR R1 , =GPIO_PORTB_DIR ; set direction of PB2          
			LDR R0 , [R1]
			BIC R0 , R0 , #0x04 ; clear bit 2 for input    
			STR R0 , [R1]
			LDR R1 , =GPIO_PORTB_AFSEL ; regular port function         
			LDR R0 , [R1]
			ORR R0 , R0 , #0x04
			STR R0 , [R1]
			LDR R1 , =GPIO_PORTB_PCTL ; Timer3A alternate func select              
			LDR R0 , [R1]
			ORR R0 , R0 , #0x00000700
			STR R0 , [R1]
			LDR R1 , =GPIO_PORTB_AMSEL ; disable analog         
			MOV R0 , #0
			STR R0 , [R1]
			LDR R1 , =GPIO_PORTB_DEN ; enable port digital             
			LDR R0 , [R1]
			ORR R0 , R0 , #0x04
			STR R0 , [R1]
			LDR R1 , =SYSCTL_RCGCTIMER ; Start Timer3   
			LDR R2 , [R1]
			ORR R2 , R2 , #0x08 ;1000
			STR R2 , [R1]
			NOP ; alow clock to settle        
			NOP
			NOP
			
			LDR R1 , =TIMER3_CTL ; disable timer during setup              
			BIC R2 , R2 , #0x08
			STR R2 , [R1]
			
			LDR R1 , =TIMER3_CFG ; set 16 bit mode     
			MOV R2 , #0x04
			STR R2 , [R1]
			
			LDR R1 , =TIMER3_TAMR
			MOV R2 , #0x17 ; set to capture[1:0], edge-time[2], count-up[4]
			; [4][3][2][1:0] 1_0_1_11
			STR R2 , [R1]
			
			LDR R1 , =TIMER3_CTL ; initialize match clocks              
			LDR R2,[R1]
			ORR R2,R2,#0x0C
			STR R2 , [R1]
			
			LDR R1 , =TIMER3_TAILR ; initialize match clocks              
			MOV R2 ,#COUNTER_MAX_VAL
			STR R2 , [R1]
			LDR R1 , =TIMER3_TAPR
			MOV R2 , #15 ; divide clock by 16 to       
			STR R2 , [R1] ; get 1 us clocks         
			LDR R1 , =TIMER3_IMR ; disable timeout interrupt              
			MOV R2 , #0x00
			STR R2 , [R1]
			
; Enable timer  
			LDR R1 , =TIMER3_CTL
			LDR R2 , [ R1 ]
			ORR R2 , R2 , #0x03 ; set bit 0 to enable        
			STR R2 , [ R1 ] ; and bit 1 to stall on debug       
			BX LR ; return     
			ENDP