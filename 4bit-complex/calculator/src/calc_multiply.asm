; Calculator Operation: multiply two numbers together.
; Return to linkage after opertion completed.
;    Inputs: R2 - first operand
;            R3 - second operand
;   Outputs: R0 - product of multiplication (displayed over 2 cycles, first R7 then R6)
; Registers: R6:R7 - temporary buffer for product of multiplication
;  Overflow: not possible.

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
    branch ONE_X
    load r7
    branch ONE_ZERO_ZERO_ONE
    load r2
    add r7
    store r7
CONTINUE:
    load r3
    addi 0xf
    store r3
    branch END
    xori 0xf
    branch MULTIPLY

OPERAND:
    load r2
    branch ONE_X
    load r7
    branch ONE_ZERO_ZERO_ONE
    load r2
    add r7
    store r7
CONTINUE_OPERAND:
    load r3
    addi 0xf
    store r3
    branch OPERAND
    load r3
    addi 0xf
    store r3
    xori 0xf
    branch MULTIPLY

ONE_X:
    load r7
    branch ONE_ONE
    xori 0xf
    branch ONE_ZERO_ZERO_ONE

ONE_ONE:
    load r6
    addi 1
    store r6
    load r2
    add r7
    store r7
    load r3
    branch CONTINUE_OPERAND
    xori 0xf
    branch CONTINUE

ONE_ZERO_ZERO_ONE:
    load r2
    add r7
    store r7
    branch SKIP
    load r6
    addi 1
    store r6
SKIP:
    load r3
    branch CONTINUE_OPERAND
    xori 0xf
    branch CONTINUE

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
