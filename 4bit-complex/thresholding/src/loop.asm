; See init.asm for program description

    load r5
    addi 3
    store r0                ; reset FSM

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
    store r2                ; IPORT input
    load r5
    addi 3
    store r0                ; reset FSM

    load r2                 ; start comparing
    branch n NX
    load r3 
    branch n PN

NN:
    load r2
    nandi 0xf
    addi 1
    add r3
    branch n EXCEED
    xori 0xf
    branch n NOTEXCEED

NX:
    load r3
    branch n NN
    xori 0xf
    branch n NP

PN:
    branch n EXCEED
    xori 0xf
    branch n EXCEED
NP:
    branch n NOTEXCEED
    xori 0xf
    branch n NOTEXCEED

EXCEED:
    load r5
    addi 1
    store r7

    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0 
    load r7
    store r0
    load r5
    addi 3
    store r0                ; reset FSM
    branch n LOOP
    xori 0xf 
    branch n LOOP

NOTEXCEED:
    load r5
    addi 0
    store r7

    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0 
    load r7
    store r0
    load r5
    addi 3
    store r0                ; reset FSM

LOOP: 
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0                ; LOOP
