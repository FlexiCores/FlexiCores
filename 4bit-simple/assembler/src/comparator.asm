; Perform unsigned comparison between two numbers
;    Inputs: R2 - first operand (MSB must be 0: 0xxx)
;            R3 - second operand (MSB must be 0: 0xxx)
;   Outputs: R0 - 1111 if R2 >= R3
;                 0000 otherwise

    nandi 0
    addi 1
    store r0        ; clear R0
    load r0
    addi 0          ; set first operand (R2)
    store r2        
    load r0 
    addi 0          ; set second operand (R3)
    store r3        

DECREMENT:
    load r3
    branch COMPARE
    load r2
    branch END
    load r2
    addi 0xf
    store r2
    load r3
    addi 0xf
    store r3
    branch DECREMENT
    xori 0xf
    branch DECREMENT

COMPARE:
    load r0
    addi 0xf
    store r0
    
END: