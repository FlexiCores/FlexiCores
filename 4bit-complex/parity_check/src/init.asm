; Parity Check
;
; -> Perform parity check on a 8-bit number
;
;      Inputs: a sequence of 8-bit numbers                                      [0, 255]
;     Outputs: the result of XORing 8 bits together                             {0, 1}
;
; Performance:  
;   Registers: R2 - input
;              R3 - 
;              R4 - FLAG
;              R5 - 0
;              R6 - temp
;              R7 - accumulation of XORs

; -> Inputs read from IPORT, outputs displayed to OPORT

    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    store r7                ; clear output
        
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
    store r4                ; clear FLAG

CONTINUE:
; Input[0]
    load r2
    nandi 0x1
    xori 0xf
    store r6
    add r6
    store r6
    add r6
    store r6
    add r6
    xor r7
    store r7

; Input[1]
    load r2
    nandi 0x2
    xori 0xf
    store r6
    add r6
    store r6
    add r6
    xor r7
    store r7

; Input[2]
    load r2
    nandi 0x4
    xori 0xf
    store r6
    add r6
    xor r7
    store r7

; Input[3]
    load r2
    nandi 0x8
    xori 0xf
    xor r7
    store r7

    load r4
    branch n LOOP

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
    addi 0xf
    store r4                ; set FLAG
    branch n CONTINUE
    
LOOP:
    load r7
    xori 0xf
    branch n DISPLAY
    load r5
    addi 0x1
    store r7

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