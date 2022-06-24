;LABEL	DIRECTIVE	VALUE	COMMENT		
					AREA routines, CODE, READONLY
					THUMB
					EXPORT mFibonacci
						
mFibonacci 

				CMP R2, #0
				
				BEQ Exit
				
				PUSH{LR}
					
			    MOV R3, R1
				
			    LSL R1, #1
				
				ADD R1, R0
				
				MOV R0, R3
				
			
				PUSH{R1}
				
				SUB R2, #1
				
				BL mFibonacci
				
				POP{R1}
				
				POP{LR}
				
				STR R1, [R9], #4
				
Exit			BX LR
				
				ALIGN
				END