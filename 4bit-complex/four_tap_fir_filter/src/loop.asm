; See init.asm for program description

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    store r6                ; clear output

    load r2
    store r6
    load r4
    xori 0xf
    addi 1
    add r6
    store r6

    load r3
    store r2
    load r4
    store r3

    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0                
    load r1
    store r4                ; shift input registers
    add r6 
    store r6                ; IPORT input 3
    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0    
    load r6
    store r0                ; output displayed
    load r5
    addi 3
    store r0                ; reset FSM

    load r7
    addi 1
    store r7                ; increment counter

    load r7
    store r6
    branch n LOOP
    add r6
    store r6
    branch n LOOP
    add r6
    store r6
    branch n LOOP
    add r6
    store r6
    branch n LOOP

    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0                ; END

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

