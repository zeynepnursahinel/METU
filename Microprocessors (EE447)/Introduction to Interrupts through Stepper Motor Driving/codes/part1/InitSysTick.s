;*********************************************************
; Your SystemTimer . s s o u r c e f i l e t o implement
; i n i t i a l i z a t i o n and ISR
;*********************************************************
; D e f i n i t i o n o f the l a b e s s t a n di n g f o r
; the a d d r e s s o f the r e g i s t e r s
NVIC_ST_CTRL 	EQU 0xE000E010
NVIC_ST_RELOAD 	EQU 0xE000E014
NVIC_ST_CURRENT EQU 0xE000E018
SHP_SYSPRI3 	EQU 0xE000ED20
; end o f the r e g i s t e r l a b e l d e f i n i t i o n s
; 0x7D0 = 2000 -> 2000*250 ns = 500mus
RELOAD_VALUE 	EQU 0x000007D0
;*********************************************************
; I n i t i a l i z a t i o n a r e a
;*********************************************************
;LABEL DIRECTIVE VALUE COMMENT
			AREA initisr , CODE, READONLY, ALIGN=2
			THUMB
			EXPORT InitSysTick

InitSysTick PROC
; f i r s t d i s a b l e system tim e r and the r e l a t e d i n t e r r u p t
; then c o n f i g u r e i t t o u se i s t e r n a l o s c i l l a t o r PIOSC/4
	LDR R1 , =NVIC_ST_CTRL
	MOV R0 , #0
	STR R0 , [ R1 ]
; now s e t the time out p e ri o d
	LDR R1 , =NVIC_ST_RELOAD
	LDR R0 , =RELOAD_VALUE
	STR R0 , [ R1 ]
; time out p e ri o d i s s e t
; now s e t the c u r r e n t time r v al u e t o the time out v al u e
	LDR R1 , =NVIC_ST_CURRENT
	STR R0 , [ R1 ]
; c u r r e n t tim e r = time out p e ri o d
; now s e t the p r i o r i t y l e v e l
	LDR R1 , =SHP_SYSPRI3
	MOV R0 , #0x40000000
	STR R0 , [ R1 ]
; p r i o r i t y i s s e t t o 2
; now e n a bl e system tim e r and the r e l a t e d i n t e r r u p t
	LDR R1 , =NVIC_ST_CTRL
	MOV R0 , #0x03
	STR R0 , [ R1 ]
; s e t up f o r system time i s now c omple te
	BX LR

	ENDP