ADC0_RIS 			EQU 0x40038004 ; Raw Interrupt STATUS
ADC0_PSSI 			EQU 0x40038028 ; Sample Sequence Initiate	
ADC0_SSFIFO3 		EQU 0x400380A8 ; Sample Result 
ADC0_ISC			EQU	0x4003800C ; Interrupt Status and Clear
SSI0_DR				EQU	0x40008008 ; SSI Data Register 	
GPIO_PORTA_DATA		EQU	0x400043FC ; Port A Data Register
SMPL_ADD 			EQU 0x20000400 ; Addres where samples are stored 
	

			AREA    	main, READONLY, CODE
			THUMB
			
			EXTERN		ATD0_PE3_INIT
			EXTERN      InitSysTick
			EXTERN		Init_PortF
			EXTERN		MOTOR_INIT
			EXTERN		ROW1					
			EXTERN		ROW2
			EXTERN		ROW3
			EXTERN		ROW5
			EXTERN      ROW6
			EXTERN 		INIT_LCD
			EXPORT  	__main	

__main		PROC
	
			BL		INIT_LCD
			BL		ROW1
			BL		ROW2
			BL		ROW3
			BL		ROW5
			BL      ROW6
			
			MOV R11,#256       ;sample number
			LDR R4,=SMPL_ADD
			
			BL ATD0_PE3_INIT
			BL InitSysTick 
			BL Init_PortF      ;FOR LEDS and switches
			BL MOTOR_INIT
			
			;continuously takes samples
			
start		LDR R1, =ADC0_PSSI ; start sampling

			; Enable Sequencer 3 in ADC0_PSSI
Sample 		LDR R0, [R1]
			ORR R0, R0, #0x08 ; set bit 3 for SS3
			STR R0, [R1]
			B 	Sample

			ENDP
			ALIGN
			END