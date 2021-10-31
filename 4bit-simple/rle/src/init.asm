; Run-Length Encoder
;
;      Inputs: a time series of input values, denoted by x(t)                            {0, 1}   
;     Outputs: a sequence of numbers encoding the number of 0s and 1s in the input       [0, 255]
;           
;              -> the first output indicates whether the input stream starts with 0 or 1
;              -> each additional output indicates the number of consecutive 0s and 1s
;
;     Example: RLE[0000 11111 000] = 0, 4, 5, 3
;   IMPORTANT: the RLE will run indefinitely until the end of input stream is reached.
;              the input stream terminates in 0xF.
;     
;
; Performance: 
;   Registers: R2    - prev input
;              R3    - curr input
;              R4    - temp 
;              R5    - 0
;              R6    - 
;              R6:R7 - counter  
;
; -> Inputs read from IPORT, outputs displayed to OPORT

    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    store r6                
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
    store r2                ; IPORT input
    load r5
    addi 3
    store r0                ; reset FSM

;   Display the first output to indicate whether the bit stream start with 0 or 1
    load r5
    addi 1
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 1
    store r0    
    load r2
    store r0                ; output displayed
    load r5
    addi 3
    store r0                ; reset FSM

    load r7
    addi 1
    store r7                ; increment counter

    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0                ; LOOP