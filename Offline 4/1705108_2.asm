INCLUDE 'EMU8086.INC'
.MODEL SMALL


.STACK 100H


.DATA
n_line DB 0AH,0DH,"$"
space DB 20H,"$"
VALUE DW 0
TOTAL DW 0
COUNT DB 0 

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    CALL READ_NUM
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    
    MOV AX, TOTAL
        
    MOV CX, AX
    XOR AX, AX
    XOR DX, DX


LABEL:                                      
    CMP DX, CX                              
    JE END_LOOP
    
    PUSH DX                                 ; fibonacci will be called upon this value
    CALL FIB
    
    ; if ax = 0, print 0
    PUSH DX
    CMP AX, 0
    JNE ELSE
    MOV AH, 2
    MOV DL, 0
    ADD DL, 48
    INT 21H
    MOV AH, 9                           
    LEA DX, space
    INT 21H

    POP DX
    
    XOR AX, AX
    JMP INCREASE
    
    ; else print the number
    ELSE:    
        PUSH DX                             ; printing the number and a space
        CALL PRINT_NUM                      ; pushing and popping the value of DX
        MOV AH, 9                           ; so DX does not change while printing
        LEA DX, space
        INT 21H
        POP DX
    
        XOR AX, AX                          ; clearing the AX register

    INCREASE:    
        INC DX
        JMP LABEL
    
END_LOOP:
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP




FIB PROC
    
    PUSH BP
    MOV BP, SP
    PUSH BX
    
    CMP [BP+4], 0                           ; if n == 0, return 0
    JNE L2
    MOV AX, 0
    JMP L3

L2:
    CMP [BP+4], 1                           ; if n == 1, return 1
    JNE L4
    MOV AX, 1
    JMP L3

L4:
    MOV AX, [BP+4]
    SUB AX, 1                               
    PUSH AX
    
    CALL FIB                                ; fib(n-1)
    
    MOV BX, AX
    MOV AX, [BP+4]
    SUB AX, 2
    PUSH AX
    
    CALL FIB                                ; fib(n-2)
    
    ADD AX, BX  
    
L3:
    POP BX
    POP BP
    RET 2
    
    
    
    
    
; stores the digit in AX
READ_NUM PROC    
    
    READ:
        MOV AH, 1
        INT 21H
    
        CMP AL, 13
        JE ENDOFNUMBER
        
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

     ENDOFNUMBER:
        RET
    
READ_NUM ENDP




PRINT_NUM PROC              ; call this proc while 16 bit number is in AX
    
    PUSH AX    
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
        POP AX
        RET

PRINT_NUM ENDP  
    

END MAIN