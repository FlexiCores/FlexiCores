; Calculator Operation: add two numbers together.
; Return to linkage after opertion completed.
;    Inputs: R2 - first operand
;            R3 - second operand
;   Outputs: R0 - sum of addition
; Registers: R7 - temporary buffer for sum of addition
;  Overflow: not handled.

    load r5
    addi 3
    store r0
    load r5
    store r0
    
    load r2
    add r3
    store r7

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
    load r6
    store r0
    xori 0
    xori 0
    xori 0
    xori 0
