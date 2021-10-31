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
    branch NX
    load r3 
    branch PN

NN:
    load r2
    nandi 0xf
    addi 1
    add r3
    branch EXCEED
    xori 0xf
    branch NOTEXCEED

NX:
    load r3
    branch NN
    xori 0xf
    branch NP

PN:
    branch EXCEED
    xori 0xf
    branch EXCEED
NP:
    branch NOTEXCEED
    xori 0xf
    branch NOTEXCEED

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
    branch LOOP
    xori 0xf 
    branch LOOP

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
