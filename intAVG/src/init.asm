; intAVG
;
; -> Implement signed integer average.
;
;      Inputs: a time series of input values, denoted by x(t)                      [-8, 7]
;     Outputs: a time series of outputs value, denoted by y(t), where              [-8, 7]
;              y(0) = x(0)
;              y(t) = [ y(t-1) + x(t) ] / 2
;
; Performance: 
;   Registers: R2 - y(t-1)
;              R3 - 2
;              R4 - 
;              R5 - 0
;              R6 - 
;              R7 - quotient
;

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
    store r2                ; IPORT input
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
    load r2
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