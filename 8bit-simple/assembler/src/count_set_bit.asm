; Count number of 1s.
;    Inputs: R2 - only operand
;   Outputs: R0 - number of 1s in the operand (in the range of 1 to 4)

    nandi 0
    addi 1
    store r0        ; clear R0
    load r0
    addi 0xf          ; set operand (R2)
    store r2        
    load r0
    addi 3
    store r3

SHIFT:
    load r2
    branch INCREMENT
CONTINUE:
    load r2
    add r2
    store r2
    load r3
    addi 0xf
    store r3
    branch END
    branch SHIFT
    xori 0xf
    branch SHIFT
    

INCREMENT:
    load r0
    addi 1
    store r0
    branch CONTINUE
    xori 0xf
    branch CONTINUE

END: