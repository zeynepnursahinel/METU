MAG_FREQ_ADDR					EQU 0x20000810
GPIO_PORTF_DATA_RED 			EQU 0x40025008 ; data address to all pins
GPIO_PORTF_DATA_GREEN 			EQU 0x40025020 ;
GPIO_PORTF_DATA_BLUE			EQU 0x40025010 ;
GPIO_PORTF_DATA_ALL 			EQU 0x400253FC ;
								AREA leds , READONLY, CODE
								THUMB
								EXPORT ledblink ; Reference external subroutine
								EXTERN Convrt
								EXTERN OutStr
				
ledblink						PROC
								PUSH{R0, R1, R2, R3, R8, R9}
								LDR R0,=MAG_FREQ_ADDR
								LDR R1, [R0] ;the magnitude
								ADD R0, R0, #4
								LDR R2, [R0] ;the freq
								
								MOV R3, #300 ;the threshold amplitude random
								MOV R8, #250 ;LOW FREQUENCY threshold
								MOV R9, #550 ;HIGH FREQUENCY threshold
								
								CMP R7, R3 ;compare the amplitude threshold
								BHI BigAmp ;R1-R2>0 so the amplitude is bigger than threshold
								
								B led_off
					
BigAmp							
								CMP R2, R8
								BHI MIDORHGH
								B LOW
								
MIDORHGH						CMP R2, R9
								BHI HIGH
								B MIDDLE
								
HIGH 							;blue led blinks
								MOV R0,#0x0
								LDR R1,=GPIO_PORTF_DATA_RED
								STR R0,[R1]
								MOV R0,#0x0
								LDR R1,=GPIO_PORTF_DATA_GREEN
								STR R0,[R1]
								MOV R0,#0xFFFFFFFF
								LDR R1,=GPIO_PORTF_DATA_BLUE
								STR R0,[R1]
								B FIN
								
MIDDLE							;green led blinks
								MOV R0,#0x0
								LDR R1,=GPIO_PORTF_DATA_RED
								STR R0,[R1]
								MOV R0,#0x0
								LDR R1,=GPIO_PORTF_DATA_BLUE
								STR R0,[R1]
								MOV R0,#0xFFFFFFFF
								LDR R1,=GPIO_PORTF_DATA_GREEN
								STR R0,[R1]
								B FIN
								
LOW								;red led blinks
								MOV R0,#0x0
								LDR R1,=GPIO_PORTF_DATA_GREEN
								STR R0,[R1]
								MOV R0,#0x0
								LDR R1,=GPIO_PORTF_DATA_BLUE
								STR R0,[R1]
								MOV R0,#0xFFFFFFFF
								LDR R1,=GPIO_PORTF_DATA_RED
								STR R0,[R1]
								B FIN
								
led_off							;led_off
								MOV R0,#0x00000000
								LDR R1,=GPIO_PORTF_DATA_ALL
								STR R0,[R1]
								
FIN
											
								POP { R0, R1, R2, R3, R8, R9}
								BX LR
								
								ENDP
								ALIGN
								END