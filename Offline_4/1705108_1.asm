.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH
n_line DB 0AH,0DH,"$"
space DB 20H,"$"
PROMPT DB "The resultant matrix is: $"

ARR1 DB 4 DUP(0)
ARR2 DB 4 DUP(0)
ARR3 DB 4 DUP(0)
COUNT DB 0  

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX



; INPUT FOR MATRIX 1
    MOV CX, 4
    XOR SI, SI   
    
INPUT_LOOP1:
    
    MOV AH, 1
    INT 21H
    
    SUB AL, 30H
    MOV ARR1[SI], AL
    INC SI
    
    MOV AH, 9
    LEA DX, space
    INT 21H
    
    CMP SI, 2
    JNE LOOP_AGAIN1
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H

LOOP_AGAIN1:    
    LOOP INPUT_LOOP1                        


; PRINT TWO NEW LINES    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    INT 21H                  
    


; INPUT FOR MATRIX 2    
    MOV CX, 4
    XOR SI, SI

INPUT_LOOP2:
    
    MOV AH, 1
    INT 21H
    
    SUB AL, 30H
    MOV ARR2[SI], AL
    INC SI
    
    MOV AH, 9
    LEA DX, space
    INT 21H
    
    CMP SI, 2
    JNE LOOP_AGAIN2
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H

LOOP_AGAIN2:    
    LOOP INPUT_LOOP2            

    
; PRINT A NEW LINE    
    MOV AH, 9
    LEA DX, n_line
    INT 21H                  
    
    
; LOOP FOR MATRIX ADDITION    
    XOR SI, SI
    MOV CX, 4
    
LOOP_ADDITION:
    
    MOV AL, ARR1[SI]
    ADD AL, ARR2[SI]
    MOV ARR3[SI], AL
    INC SI
    
    LOOP LOOP_ADDITION          
    
; PRINT A NEW LINE    
    MOV AH, 9
    LEA DX, n_line
    INT 21H                  

    LEA DX, PROMPT
    INT 21H
    LEA DX, n_line
    INT 21H    
    
    
; OUPUT THE RESULTANT MATRIX    
    XOR SI, SI
    MOV CX, 4
    ;MOV AH, 2    
            
OUTPUT_LOOP:
    
    XOR AX, AX
    MOV AL, ARR3[SI]
    CALL PRINT_NUM
    
    ; PRINT A SPACE
    MOV AH, 9
    LEA DX, space
    INT 21H
    
    INC SI
    
    CMP SI, 2
    JNE LOOP_AGAIN3
    
    ; AFTER A ROW, PRINT A NEW LINE
    MOV AH, 9
    LEA DX, n_line
    INT 21H

LOOP_AGAIN3:    
    LOOP OUTPUT_LOOP            


    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP 



PRINT_NUM PROC              ; call this proc while 16 bit number is in AX
        
    MOV COUNT, 0    
    MOV DX, 0 
        
    LABEL1:
            
        CMP AX, 0
        JE PRINT1
            
        MOV BX, 10
        DIV BX
            
        PUSH DX
        INC COUNT
            
        XOR DX, DX
        JMP LABEL1
         
    PRINT1:
             
        CMP COUNT, 0
        JE EXIT_PRINT
            
        POP DX
        ADD DX, 48
             
        MOV AH, 2
        INT 21H
             
        DEC COUNT
        JMP PRINT1
             
        
    EXIT_PRINT:
        RET

PRINT_NUM ENDP  
          
          
          
END MAIN