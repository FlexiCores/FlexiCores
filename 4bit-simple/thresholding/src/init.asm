; Thresholding
;
;      Inputs: a sequence of input values (possibly from an external sensor)    [-8, 7]
;  Threashold: the threshold to compare the inputs against                      [-8, 7]
;     Outputs: 1 if input > threshold, 0 otherwise                              
;
; Performance: .
;   Registers: R2 - input
;              R3 - threshold
;              R4 - 
;              R5 - 0
;              R6 - 
;              R7 - temp output
;
; -> Inputs and threshold read from IPORT, outputs displayed to OPORT, threshold hardcoded in assembly

    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 2                  ; IMPORTANT: the immediate value here is the threshold
    store r3
        
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0                ; LOOP

    