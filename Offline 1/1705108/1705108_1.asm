INCLUDE 'EMU8086.INC'
.MODEL SMALL


.STACK 100H


.DATA
CR EQU 0DH
LF EQU 0AH  

X DB ?
Y DB ?
Z DB ?   

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    
    ; INPUT X
    
    PRINT 'INPUT X:' 
    MOV AH, 1
    INT 21H
    SUB AL, 48
    MOV X, AL
    PRINTN
    
                    
    ; INPUT Y
    
    PRINT 'INPUT Y: '
    MOV AH, 1
    INT 21H
    SUB AL, 48
    MOV Y, AL
    PRINTN 

    PRINTN
    
    
    ;OUTPUT --> Z = X - 2Y
    
    MOV BL, X
    SUB BL, Y
    SUB BL, Y
    ADD BL, 48
    MOV Z, BL
    
    PRINT 'X - 2Y : ' 
    MOV AH, 2
    MOV DL, BL
    INT 21H
    
    PRINTN  
    

    
    ; OUTPUT --> 25 - (X + Y)
    
    MOV BL, 25
    SUB BL, X
    SUB BL, Y
    ADD BL, 48
    MOV Z, BL
    
    PRINT '25 - (X+Y): '
    MOV AH, 2
    MOV DL, Z
    INT 21H
    PRINTN
    
    
    
    ;OUTPUT --> Z = 2X - 3Y
    
    MOV BL, X
    ADD BL, X
    SUB BL, Y
    SUB BL, Y
    SUB BL, Y
    ADD BL, 48
    MOV Z, BL
    
    PRINT '2X - 3Y: ' 
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    PRINTN 
    
    
    ;OUPUT --> Z = Y-X+1
    MOV BL, Y
    SUB BL, X
    INC BL
    ADD BL, 48
    MOV Z, BL
    
    PRINT 'Y - X + 1: '  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN