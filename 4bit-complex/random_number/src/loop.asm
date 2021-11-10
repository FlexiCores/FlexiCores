    load r5
    addi 3
    store r0                ; reset FSM

;   let d = c ^ (c << 3);
    load r2
    add r2
    store r2
    add r2
    store r2
    add r2
    store r2

    load r3
    nandi 0x2
    xori 0xf
    store r4
    add r4
    store r4
    add r4
    branch n ADD_ONE

CONTINUE_ONE:
    load r3
    nandi 0x4
    xori 0xf
    store r4
    add r4
    branch n ADD_TWO

CONTINUE_TWO:
    load r3
    nandi 0x8
    xori 0xf
    branch n ADD_THREE

CONTINUE_THREE:
    load r2
    xor r6
    store r6
 
    load r3
    add r3
    store r3
    add r3
    store r3
    add r3
    store r3
    xor r7
    store r7
    branch n DISPLAY
    xori 0xf
    branch n DISPLAY

ADD_ONE:
    load r2
    addi 1
    store r2
    branch n CONTINUE_ONE
    xori 0xf
    branch n CONTINUE_ONE

ADD_TWO:
    load r2
    addi 2
    store r2
    branch n CONTINUE_TWO
    xori 0xf
    branch n CONTINUE_TWO

ADD_THREE:
    load r2
    addi 4
    store r2
    branch n CONTINUE_THREE
    xori 0xf
    branch n CONTINUE_THREE
 



DISPLAY:
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