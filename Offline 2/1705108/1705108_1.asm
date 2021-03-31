.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH

A DB ?
B DB ?
C DB ?

PROMPT DB 'All the numbers are equal$'
PROMPT1 DB 'FIRST NUMBER: $'
PROMPT2 DB 'SECOND NUMBER: $'
PROMPT3 DB 'THIRD NUMBER: $'
PROMPT4 DB 'SECOND LARGEST NUMBER IS: $'
n_line DB 0AH,0DH,"$"   

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, PROMPT1
    INT 21H
     
    MOV AH, 1
    INT 21H
    MOV A, AL                               ;INPUT A
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    
    MOV AH, 9
    LEA DX, PROMPT2
    INT 21H

    
    MOV AH, 1
    INT 21H
    MOV B, AL                               ; INPUT B
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H
    
    MOV AH, 9
    LEA DX, PROMPT3
    INT 21H

    
    MOV AH, 1                               ; INPUT C
    INT 21H                 
    MOV C, AL
    
    MOV AH, 9
    LEA DX, n_line
    INT 21H                                  ; PRINT NEW LINE
    
    
    MOV BL, B
    CMP A, BL                               ; A>B ?
    JG AGBL                                 ; IF A>B, JUMP TO  A>B LEFT SUBTREE
    JMP ANGBR                               ; ELSE JUMP TO A!>B RIGHT SUBTREE
    
    
    AGBL:                                   ; A>B  LEFT SUBTREE
    MOV BL, C
    CMP A, AL               
    JG AGCL                                 ; IF A>C, JUMP TO A>C LEFT SUBTREE
    JMP ANS_A                               ; ELSE A IS ANSWER 
    
    
    AGCL:                                   ; A>C LEFT SUBTREE
    MOV BL, B
    CMP BL, C               
    JG ANS_B                                ; IF B>C, B IS ANSWER
    JMP ANS_C                               ; ELSE C IS ANSWER
    
    
    ANGBR:                                  ; A!>B RIGHT SUBTREE
    MOV BL, B
    CMP A, BL
    JE AEBR                                 ; IF A=B, JUMP TO A=B RIGHT SUBTREE
    JMP BGAR                                ; ELSE JUMP TO B>A RIGHT SUBTREE
    
    
    AEBR:                                   ; A=B RIGHT SUBTREE
    MOV BL, C
    CMP A, BL
    JG ANS_C                                ; IF A>C, ANSWER IS C
    JMP ANGCR                               ; ELSE JUMP TO A!>C RIGHT SUBTREE
    
    
    ANGCR:                                  ; A!>C RIGHT SUBTREE
    MOV BL, C
    CMP A, BL               
    JNE ANS_A                               ; IF A!= C, ANSWER IS A
    
    MOV AH, 9                               ; ELSE ALL NUMBERS EQUAL
    LEA DX, PROMPT
    INT 21H
    JMP END_P
         
         
    BGAR:                                   ; B>A IN THE RIGHT SUBTREE
    MOV BL, B
    CMP BL, C
    JG BGCR                                 ; IF B>C, JUMP TO B>C RIGHT SUBTREE
    JMP BNGCR                               ; ELSE JUMP TO B!>C RIGHT SUBTREE
    
    
    BNGCR:                                  ; B!>C RIGHT SUBTREE
    MOV BL, B
    CMP BL, C
    JE ANS_A                                ; IF B=C, ANSWER IS A
    JMP ANS_B                               ; ELSE ANSWER IS B
    
    
    BGCR:                                   ; A>C IN THE RIGHT SUBTREE
    MOV BL, A
    CMP BL, C                               ; A>C? 
    JG ANS_A                                ; IF A>C, A IS ANSWER
    JMP ANS_C                               ; ELSE C IS ANSWER
    
    
    
    
    ANS_A:
    MOV AH, 9
    LEA DX, PROMPT4
    INT 21H
    
    MOV AH, 2
    MOV DL, A
    INT 21H
    JMP END_P
    
    ANS_B:
    MOV AH, 9
    LEA DX, PROMPT4
    INT 21H
    
    MOV AH,2 
    MOV DL, B
    INT 21H
    JMP END_P
    
    ANS_C:
    MOV AH, 9
    LEA DX, PROMPT4
    INT 21H
    
    MOV AH,2
    MOV DL, C
    INT 21H
    JMP END_P
     

    END_P:
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN