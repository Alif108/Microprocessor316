.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH

X DB 0
Y DB 0
Z DB 0 
PROMPT_I DB 'Invalid Password$'
PROMPT_V DB 'Valid Password$' 
n_line DB 0AH,0DH,"$"

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX   
    
    MOV AH, 1
    INT 21H
    
WHILE:
    
    CMP AL, 21H                     ; check if printable character
    JNGE END_WHILE
    CMP AL, 7EH
    JNLE END_WHILE

FIRST:                              ; check if between 'A' and 'Z'    
    CMP AL, 'A'
    JNGE SECOND
    CMP AL, 'Z'
    JNLE SECOND
    INC X

SECOND:                             ; check if between 'a' and 'z'
    CMP AL, 'a'
    JNGE THIRD
    CMP AL, 'z'
    JNLE THIRD
    INC Y

THIRD:                              ; check if between 0 and 9
    CMP AL, '0'
    JNGE END_IF
    CMP AL, '9'
    JNLE END_IF
    INC Z
        
END_IF:
    INT 21H
    JMP WHILE:


END_WHILE:
    
    CMP X, 0
    JE STATEMENT
    CMP Y, 0
    JE STATEMENT
    CMP Z, 0
    JE STATEMENT
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    LEA DX, PROMPT_V
    INT 21H
    JMP EXIT 
    
STATEMENT:
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    LEA DX, PROMPT_I
    INT 21H        
    
    
EXIT:
        
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN