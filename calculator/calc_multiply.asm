; Calculator Operation: multiply two numbers together.
; Return to linkage after opertion completed.
;    Inputs: R2 - first operand
;            R3 - second operand
;   Outputs: R0 - product of multiplication
; Important: Overflow not accounted for.

    load r5
    addi 3
    store r0
    load r5
    store r0
    load r3       
    branch OPERAND
    load r3
    addi 0xf
    store r3
    branch END      ; check if second operand is 0

MULTIPLY:
    load r2
    add r7
    store r7
    load r3
    addi 0xf
    store r3
    branch END
    xori 0xf
    branch MULTIPLY

OPERAND:
    load r2
    add r7
    store r7
    load r3
    addi 0xf
    store r3
    branch OPERAND
    load r3
    addi 0xf
    store r3
    xori 0xf
    branch MULTIPLY

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