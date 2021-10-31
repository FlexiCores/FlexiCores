; Four Tap FIR Filter
;
; -> Implement four tap FIR filter.
;
;      Inputs: a sequence of 19 inputs value (possibly from an external sensor) [-2, 2]
;     Weights: weights of the filter: 1, 0, -1, 1                               [-1, 1]
;     Outputs: a sequence of 16 outputs value                                   [-8, 7]
;
; Performance: Always 1045 cycles.
;   Registers: R2 - input A
;              R3 - input B
;              R4 - input C
;              R5 - 0
;              R6 - output / temp
;              R7 - counter
;   IMPORTANT: Overflow can happen in the output if the weights are 1, 1, 1, 1 and
;              there are four consecutive 2s in the input stream.
;
; -> Inputs read from IPORT, outputs displayed to OPORT, weights hardcoded in assembly

    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    store r7                ; clear counter
        
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
    store r6                ; IPORT input 0
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
    store r2                ; IPORT input 1
    load r5
    addi 3
    store r0                ; reset FSM

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
    store r3                ; IPORT input 2
    load r5
    addi 3
    store r0                ; reset FSM

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
    store r4                ; IPORT input 3
    load r5
    addi 3
    store r0                ; reset FSM

    load r3
    xori 0xf
    addi 1
    add r6
    store r6

    load r4
    add r6
    store r6                ; output computed

    load r7
    addi 1
    store r7                ; increment counter

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

    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0                ; LOOP