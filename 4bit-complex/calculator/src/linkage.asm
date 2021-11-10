; Linkage for the calculator.
; Jump to execute a specific operation based on cmd.
;    Inputs: R2 - first operand
;            R3 - second operand
;            R4 - cmd 0001: add
;                     0010: subtract
;                     0100: multiply
;                     1000: divide
;   Outputs: R0 - result of calculation (operation dependent)
; Important: See assembly files for individual operations for constraints.

    nandi 0
    addi 1
    store r0
    store r5
    store r7
    store r6
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
    branch n DIVIDE
    add r4
    store r4
    branch n MULTIPLY
    add r4
    store r4
    branch n SUBTRACT
    add r4
    store r4
    branch n ADD

ADD:
    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 1
    store r0

SUBTRACT:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0

MULTIPLY:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0

DIVIDE:
    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0