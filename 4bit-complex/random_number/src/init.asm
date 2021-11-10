; Random Number
;
; -> Generate 8-bit pseudo random number using XORshift algorithm
;
;      Inputs: a 8-bit numbers, which is the seed                               [0, 255]
;     Outputs: the pseduo random number based on seed                           [0, 255]
;
; Performance:  
;   Registers: R2:R3 - input
;              R4 - temp
;              R5 - 0
;              R6:R7 - output
;
; Pseudo Code:
;
; struct XorShift8 {
;     seed: u8
; }
;
; fn prng(xs: XorShift8) -> u8 {
;     let a = xs.seed;
;     let b = a ^ (a << 7);
;     let c = b ^ (b >> 5);
;     let d = c ^ (c << 3);
;     return d;
; }

; -> Inputs read from IPORT, outputs displayed to OPORT

    nandi 0
    addi 1
    store r5                ; clear R5   

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
    store r2                ; IPORT input 0
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
    addi 0
    store r0                
    load r1 
    store r3                ; IPORT input 1
    load r5
    addi 3
    store r0                ; reset FSM

;   let b = a ^ (a << 7);
    load r3
    store r7
    load r3
    store r4
    add r4
    store r4
    add r4
    store r4
    add r4
    xor r2
    store r6
    
    load r6
    store r2
    load r7
    store r3               ; curr <= next
;   let c = b ^ (b >> 5);
    load r5
    store r4
    load r2
    nandi 0x2
    xori 0xf
    store r4
    add r4
    store r4
    add r4
    branch n ADD_ONE

CONTINUE_ONE:
    load r2
    nandi 0x4
    xori 0xf
    store r4
    add r4
    branch n ADD_TWO

CONTINUE_TWO:
    load r2
    nandi 0x8
    xori 0xf
    branch n ADD_THREE

CONTINUE_THREE:
    load r7
    xor r5
    store r7

    nandi 0
    addi 1
    store r5                ; clear R5 

    load r6
    store r2
    load r7
    store r3                ; curr <= next
    branch n LOOP
    xori 0xf
    branch n LOOP

ADD_ONE:
; VIOLATED R5=0
    load r5
    addi 1
    store r5
    branch n CONTINUE_ONE
    xori 0xf
    branch n CONTINUE_ONE

ADD_TWO:
    load r5
    addi 2
    store r5
    branch n CONTINUE_TWO
    xori 0xf
    branch n CONTINUE_TWO

ADD_THREE:
    load r5
    addi 4
    store r5
    branch n CONTINUE_THREE
    xori 0xf
    branch n CONTINUE_THREE

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

