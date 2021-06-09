; Calculator Operation: unsigned comparison between two numbers
; Return to linkage after opertion completed.
;    Inputs: R2 - first operand (MSB must be 0: 0xxx)
;            R3 - second operand (MSB must be 0: 0xxx)
;   Outputs: R0 - 1111 if R2 >= R3
;                 0000 otherwise

    load r5
    addi 3
    store r0
    load r5
    store r0     

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
    load r7
    addi 0xf
    store r7

; Strobe the lower half of R0 over three cycles: xx10 xx00 xx10

END:
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0
    load r7
    store r0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0
    xori 0