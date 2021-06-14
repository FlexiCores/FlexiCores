; Calculator Operation: divide one number from another.
; Return to linkage after opertion completed.
;    Inputs: R2 - first operand (must be positive in 2's complement)
;            R3 - second operand (must be positive in 2's complement)
;   Outputs: R0 - quotient and remainder (displayed over 2 cycles, first R7 then R6)
; Registers: R7 - temporary buffer for quotient
;            R6 - temporary buffer for remainder

    load r5
    addi 3
    store r0
    load r5
    store r0
    
    load r3                 ; Negate R3
    nandi 0xf
    addi 1
    store r3                ; Negate R3

SUBTRACT:
    load r2
    add r3
    branch REMAINDER
    store r2
    load r7
    addi 1
    store r7
    branch SUBTRACT
    xori 0xf
    branch SUBTRACT

REMAINDER:
    load r2
    store r6
    branch END

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
