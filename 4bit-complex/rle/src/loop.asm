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
    store r3                ; IPORT input
    load r5
    addi 3
    store r0                ; reset FSM

    load r3
    branch n END  

    load r3
    add r3
    store r4
    add r4
    store r4
    add r4
    store r4

    load r2
    add r2
    store r2
    add r2
    store r2
    add r2
    store r2

    load r2
    xor r4
    branch n INPUT_CHANGED
    
    load r3
    store r2

    load r7
    branch n MIGHT_OVERFLOW
    load r7
    addi 1
    store r7
    branch n LOOP
    xori 0xf
    branch n LOOP

MIGHT_OVERFLOW:
    load r7
    addi 1
    store r7
    branch n LOOP
    load r6                 ; OVERFLOWED
    addi 1
    store r6
    branch n LOOP
    xori 0xf
    branch n LOOP

INPUT_CHANGED:

    load r3
    store r2

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
    load r6
    store r0                ; output displayed
    load r5
    addi 3
    store r0                ; reset FSM


    load r5
    addi 1
    store r7
    load r5
    store r6

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

END:
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
    load r6
    store r0                ; output displayed
    load r5
    addi 3
    store r0                ; reset FSM
    
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0 