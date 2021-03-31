.MODEL SMALL

.STACK 100H

.DATA
                 
TOTAL DW 0
OP1 DW 0
OPERATOR DB ?
OP2 DW 0
VALUE DW 0
PROMPT DB 'Wrong Operation $'
REM DW 0
;MSG1 DB 'QUOTIENT: $'
;MSG2 DB 'REMAINDER: $'
NEG_FLAG DB 0
NEG_FLAG1 DB 0
NEG_FLAG2 DB 0
n_line DB 0AH,0DH,"$"
RESULT DW 0    


.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    ; 1st number input
    XOR AX, AX 
    CALL READ_NUM
    MOV AX, TOTAL
    
    MOV BL, NEG_FLAG
    MOV NEG_FLAG1, BL            ; neg_flag of input 1
    MOV NEG_FLAG, 0
    
    CMP NEG_FLAG1, 0             ; checks if neg_flag is 1
    JE POSITIVE1
    NEG AX
    
POSITIVE1:    
    MOV OP1, AX
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H                     ; printing new line
    
    MOV AH, 1
    INT 21H                     ; input of operand
    
    CMP AL, 'q'
    JE EXIT
    CMP AL, '+'
    JE OP
    CMP AL, '-'
    JE OP
    CMP AL, '*'
    JE OP
    CMP AL, '/'
    JE OP
    
    MOV AH, 9
    LEA DX, PROMPT              ; prompt 'wrong operation' if not these symbols
    INT 21H
    JMP EXIT 
    
OP:    
    MOV OPERATOR, AL
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    
    XOR AX, AX
    MOV NEG_FLAG, 0
    MOV TOTAL, 0
    CALL READ_NUM               ; 2nd number input
    MOV AX, TOTAL
    
    MOV BL, NEG_FLAG
    MOV NEG_FLAG2, BL
    MOV NEG_FLAG, 0
    
    CMP NEG_FLAG2, 0            ; checks if neg_flag is 1
    JE POSITIVE2
    NEG AX
    
POSITIVE2:
    MOV OP2, AX
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    
    CMP OPERATOR, '+'
    JE ADD_NUM
    CMP OPERATOR, '-'
    JE SUB_NUM
    CMP OPERATOR, '*'
    JE MUL_NUM
    CMP OPERATOR, '/'
    JE DIV_NUM




ADD_NUM:                        ; calling addition
    CALL PRINT_RESULT
    CALL ADDITION
    
    CMP NEG_FLAG, 0
    JE PRINT_ADD
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    
PRINT_ADD:
    
    MOV AX, RESULT     
    CALL PRINT_NUM
    
    JMP EXIT



    
SUB_NUM:                        ; calling subtraction
    CALL PRINT_RESULT
    CALL SUBTRACTION
    
    CMP NEG_FLAG, 0
    JE PRINT_ADD
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    
PRINT_SUB: 
    MOV AX, RESULT
    CALL PRINT_NUM
    JMP EXIT



    
MUL_NUM:                        ; calling multiplication
    CALL PRINT_RESULT
    CALL MULTIPLICATION
    
    MOV BL, NEG_FLAG1
    XOR BL, NEG_FLAG2
    JZ PRINT_MUL                ; if both number has same sign, result is +
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H                     ; else print a - first         
    
PRINT_MUL:
    MOV AX, RESULT    
    CALL PRINT_NUM
    JMP EXIT



    
DIV_NUM:                        ; calling division
    CALL PRINT_RESULT
    CALL DIVISION
    
    MOV BL, NEG_FLAG1
    XOR BL, NEG_FLAG2
    JZ PRINT_DIV                ; if both number has same sign, result is +
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H                     ; else print a - first
        
PRINT_DIV:
    MOV AX, RESULT
    CALL PRINT_NUM

    ;MOV AH, 9
    ;LEA DX, MSG2
    ;INT 21H                     ; "QUOTIENT: "
    
    ;MOV AX, REM
    ;CALL PRINT_NUM              ; "REMAINDER: "
    
    JMP EXIT
    

    
EXIT:    
    ;return control to DOS
    MOV AH, 4CH
	INT	21H  
    
    MAIN ENDP



; stores the digit in AX

READ_NUM PROC    
    
    READ:
        MOV AH, 1
        INT 21H
    
        CMP AL, 13
        JE ENDOFNUMBER
        
        CMP AL, '-'
        JE NEGATIVE
        
        CMP AL, '0'
        JNGE READ
        CMP AL, '9'
        JNLE READ               ; ignoring characters except numbers
    
        XOR AH, AH
    
        MOV VALUE, AX
        SUB VALUE, 48
    
        MOV AX, TOTAL
        MOV BX, 10
        MUL BX
    
        ADD AX, VALUE
        MOV TOTAL, AX
    
        JMP READ
        
     NEGATIVE:
        INC NEG_FLAG            ; neg_flag = 1 when input < 0
        JMP READ

     ENDOFNUMBER:
        RET
    
READ_NUM ENDP



; call this proc while 16 bit number is in AX
PRINT_NUM PROC
        
        MOV CX, 0
        MOV DX, 0
        
        LABEL1:
            
            CMP AX, 0
            JE PRINT1
            
            MOV BX, 10
            DIV BX
            
            PUSH DX
            INC CX
            
            XOR DX, DX
            JMP LABEL1
            
        PRINT1:
             
             CMP CX, 0
             JE EXIT_PRINT
             
             POP DX
             ADD DX, 48
             
             MOV AH, 2
             INT 21H
             
             DEC CX
             JMP PRINT1
             
        
        EXIT_PRINT:
            RET

PRINT_NUM ENDP  



; ADDITION IS STORED IN AX
ADDITION PROC
    
    MOV CX, 0
    MOV AX, OP1
    MOV BX, OP2
    
    ADD AX, BX
    JNS NOT_NEG1                        ; if SF = 1, take AX's 2's complement
    NEG AX
    INC NEG_FLAG                       ; make the neg_flag = 1 
    
NOT_NEG1:
    MOV RESULT, AX    
    RET
    
ADDITION ENDP



SUBTRACTION PROC                        ; SUBTRACTION IS STORED IN AX
    
    MOV CX, 0
    MOV AX, OP1
    MOV BX, OP2
    
    SUB AX, BX
    
    JNS NOT_NEG2                        ; if SF = 1, take AX's 2's complement
    NEG AX
    INC NEG_FLAG                        ; make the neg_flag = 1
    
NOT_NEG2:
    MOV RESULT, AX    
    RET
    
SUBTRACTION ENDP

         
         
MULTIPLICATION PROC                     ; STORES THE RESULT IN AX
    
    MOV AX, OP1
    MOV BX, OP2
    
    CMP NEG_FLAG1, 0
    JE SECOND
    NEG AX

SECOND:
    CMP NEG_FLAG2, 0
    JE MULTIPLY
    NEG BX                              ; if any of the numbers are in 2's complement, negate them first

MULTIPLY:    
    MUL BX
    MOV RESULT, AX
    RET
        
MULTIPLICATION ENDP  



DIVISION PROC                           ; quotient is in AX, remainder is in DX
    
    MOV AX, OP1
    MOV BX, OP2
    
    XOR DX, DX
    
    CMP NEG_FLAG1, 0
    JE SECOND2
    NEG AX

SECOND2:
    CMP NEG_FLAG2, 0
    JE DIVIDE
    NEG BX                              ; if any of the numbers are in 2's complement, negate them first   
    
DIVIDE:        
    
    DIV BX
    
    MOV RESULT, AX
    MOV REM, DX
    
    RET
    
DIVISION ENDP



PRINT_RESULT PROC
    
    MOV AH, 2
    MOV DL, '['
    INT 21H
    
    XOR AX, AX
        
    MOV AX, OP1
    CMP NEG_FLAG1, 0
    JE FIRST_NUM
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    MOV AX, OP1
    NEG AX
    
FIRST_NUM:    
    CALL PRINT_NUM
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H
    
    XOR AX, AX
    
    MOV AH, 2
    MOV DL, '['
    INT 21H
    
    MOV AH, 2
    MOV DL, OPERATOR
    INT 21H
    
    MOV DL, ']'
    INT 21H
    
    XOR AX, AX
    
    MOV AH, 2
    MOV DL, '['
    INT 21H
    
    MOV AX, OP2
    CMP NEG_FLAG2, 0
    JE SECOND_NUM
    
    MOV AH, 2
    MOV DL, '-'
    INT 21H
    MOV AX, OP2
    NEG AX
    
SECOND_NUM:    
    CALL PRINT_NUM
    
    MOV AH, 2
    MOV DL, ']'
    INT 21H
    
    MOV AH, 2
    MOV DL, '='
    INT 21H
    
    RET
    
PRINT_RESULT ENDP
    
END MAIN