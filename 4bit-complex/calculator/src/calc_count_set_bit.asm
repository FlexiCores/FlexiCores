; Calculator Operation: count number of 1s.
; Return to linkage after opertion completed.
;    Inputs: R2 - only operand
;   Outputs: R0 - number of 1s in the operand (in the range of 1 to 4)

    load r5
    addi 3
    store r0
    load r5
    store r0
    load r5
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
    load r7
    addi 1
    store r7
    branch CONTINUE
    xori 0xf
    branch CONTINUE

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
    load r6
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