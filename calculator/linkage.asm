; Linkage for the calculator.
; Jump to execute a specific operation based on cmd.
;    Inputs: R2 - first operand
;            R3 - second operand
;            R4 - cmd 0001: exit
;                     0010: multiplication
;                     0100: comparator
;                     1000: count set bit (second operand ignored)
;   Outputs: R0 - result of calculation (operation dependent)
; Important: See assembly files for individual operations for constraints.

    nandi 0
    addi 1
    store r0
    store r5
    store r7
    load r5
    addi 3
    store r0

    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 1
    store r0
    load r1
    store r2
    load r5
    addi 3
    store r0

    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r1
    store r3
    load r5
    addi 3
    store r0

    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r1
    store r4
    load r5
    addi 3
    store r0
    
    load r5
    store r0
    
    load r4
    branch COUNT_SET_BIT
    add r4
    store r4
    branch COMPARATOR
    add r4
    store r4
    branch MULTIPLICATION
    add r4
    store r4
    branch EXIT

; Strobe the lower half of R0 over three cycles: xx01 xx00 xx01
EXIT:
    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 1
    store r0


; Strobe the lower half of R0 over three cycles: xx01 xx10 xx01
MULTIPLICATION:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0

; Strobe the lower half of R0 over three cycles: xx01 xx10 xx00
COMPARATOR:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0

; Strobe the lower half of R0 over three cycles: xx01 xx00 xx10
COUNT_SET_BIT:
    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0