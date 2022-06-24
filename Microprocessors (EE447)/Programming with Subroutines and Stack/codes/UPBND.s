;LABEL	DIRECTIVE	VALUE	COMMENT		
					AREA routines, CODE, READONLY
					THUMB
					EXPORT UPBND
						
UPBND PUSH{LR}

	CMP R5, #0X55      ;if the input is U
	
	BEQ Cont1
	
	CMP R5, #0x44	    ;if the input is D

	BEQ Cont2
	
Cont1 MOV R0, R4        ;LOW<-MID
	 
	B mid

Cont2 MOV R2, R4		;UP<-MID
	
mid	ADD R4, R0, R2      ;MID=(LOW+UP)/2
	
	LSR R4, #1


	POP {LR}

	BX LR
	
	ALIGN
	END