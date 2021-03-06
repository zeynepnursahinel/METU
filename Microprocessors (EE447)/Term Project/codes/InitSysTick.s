NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
SHP_SYSPRI3 	EQU 0xE000ED20
; 0x7D0 = 2000 -> 2000*250 ns = 500mus
RELOAD_VALUE 	EQU 0x000007D0

			AREA init_isr , CODE, READONLY, ALIGN=2
			THUMB
			EXPORT InitSysTick
				
InitSysTick PROC
			PUSH {LR}
			LDR R1 ,=NVIC_ST_CTRL
			MOV R0,#0
			STR R0,[R1]
			LDR R1,=NVIC_ST_CURRENT
			STR R0,[R1]
			LDR R1,=NVIC_ST_RELOAD
			MOV R0,#2000 ;reload value for 0.5msec
			STR R0,[R1]
			LDR R1,=SHP_SYSPRI3
			MOV R0,#0x40000000
			STR R0,[R1]
			LDR R1,=NVIC_ST_CTRL
			MOV R0,#0x03
			STR R0,[R1]
			POP {LR}
			BX LR
			ENDP
			ALIGN
			END