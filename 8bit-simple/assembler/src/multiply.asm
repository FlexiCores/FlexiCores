; Multiply two numbers together.
;    Inputs: R2 - first operand
;            R3 - second operand
;   Outputs: R0 - product of multiplication
; Important: Overflow not accounted for.

    nandi 0
    addi 1
    store r0        ; clear R0
    load r0
    addi 0xf          ; set first operand (R2)
    store r2        
    load r0 
    addi 0x7          ; set second operand (R3)
    store r3        
    branch OPERAND
    load r3
    addi 0xf
    store r3
    branch END      ; check if second operand is 0

MULTIPLY:
    load r2
    add r0
    store r0
    load r3
    addi 0xf
    store r3
    branch END
    xori 0xf
    branch MULTIPLY

OPERAND:
    load r2
    add r0
    store r0
    load r3
    addi 0xf
    store r3
    branch OPERAND
    load r3
    addi 0xf
    store r3
    xori 0xf
    branch MULTIPLY

END: