    load r5
    addi 3
    store r0                ; reset FSM

    load r6
    branch LEAF
    xori 0xf
    branch CONTINUE

LEAF:
    load r6
    xori 8
    store r6                ; subtract 128
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0                ; leaf node reached
    load r6
    store r0
    load r7
    store r0                ; OPORT node index

CONTINUE:
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0                ; strobe sequence
    load r6
    store r0
    load r7
    store r0                ; OPORT node index
    load r1 
    store r3                ; IPORT feature valuie
    load r1
    store r4                ; IPORT weight
    load r5
    addi 3
    store r0           
    load r5
    store r0                ; reset FSM

    load r3                 ; start comparing
    branch NX
    load r4 
    branch PN

NN:
    load r4
    nandi 0xf
    addi 1
    add r3
    branch RIGHT
    xori 0xf
    branch LEFT

NX:
    load r4
    branch NN
    xori 0xf
    branch NP

PN:
    branch LEFT
    xori 0xf
    branch LEFT
NP:
    branch RIGHT
    xori 0xf
    branch RIGHT

LEFT:
    load r7                     ; node_index = node_index * 2
    branch OVERFLOW_LEFT
    add r7
    store r7
    load r6
    add r6
    store r6
    branch LOOP
    xori 0xf
    branch LOOP

OVERFLOW_LEFT: 
    add r7
    store r7
    load r6
    add r6
    store r6
    load r6
    addi 1
    store r6
    branch LOOP
    xori 0xf
    branch LOOP

RIGHT:
    load r7                     ; node_index = node_index * 2 + 1
    branch OVERFLOW_RIGHT
    add r7
    store r7
    load r6
    add r6
    store r6
    load r7
    addi 1
    store r7
    branch LOOP
    xori 0xf
    branch LOOP

OVERFLOW_RIGHT: 
    add r7
    store r7
    load r6
    add r6
    store r6
    load r6
    addi 1
    store r6
    load r7
    addi 1
    store r7
    branch LOOP
    xori 0xf
    branch LOOP

LOOP:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0