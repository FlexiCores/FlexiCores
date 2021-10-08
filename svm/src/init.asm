; SVM with Linear Kernel
;
; -> Implement a Support Vector Machine with 2 classes and 2 feature variables.
;
;      Inputs: (X1, X2) are the feature variables                               [0, 15]
;     Weights: (a, b)                                                           [0, 15]
;     Outputs: 1 if X2 >= a*X1 + b                                               {0, 1}
;              0 otherwise                                                      
;
; -> the condition a*X1 + b will be an 8-bit value
;
; Performance: 
;   Registers: R2 - X1 / temp output
;              R3 - a / X2
;              R4 - b
;              R5 - 0
;              R6:R7 - a*X1 + b
;
; -> Inputs read from IPORT, outputs displayed to OPORT, weights hardcoded in assembly

    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 15                  ; IMPORTANT: the immediate value here is "a"
    store r3

    load r5
    addi 1                  ; IMPORTANT: the immediate value here is "b"
    store r4
        

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
    store r2                ; IPORT X1
    load r5
    addi 3
    store r0                ; reset FSM

    ; MULTIPLY SUBROUTINE

    load r3       
    branch OPERAND
    load r3
    addi 0xf
    store r3
    branch END      ; check if second operand is 0

MULTIPLY:
    load r2
    branch ONE_X
    load r7
    branch ONE_ZERO_ZERO_ONE
    load r2
    add r7
    store r7
CONTINUE:
    load r3
    addi 0xf
    store r3
    branch END
    xori 0xf
    branch MULTIPLY

OPERAND:
    load r2
    branch ONE_X
    load r7
    branch ONE_ZERO_ZERO_ONE
    load r2
    add r7
    store r7
CONTINUE_OPERAND:
    load r3
    addi 0xf
    store r3
    branch OPERAND
    load r3
    addi 0xf
    store r3
    xori 0xf
    branch MULTIPLY

ONE_X:
    load r7
    branch ONE_ONE
    xori 0xf
    branch ONE_ZERO_ZERO_ONE

ONE_ONE:
    load r6
    addi 1
    store r6
    load r2
    add r7
    store r7
    load r3
    branch CONTINUE_OPERAND
    xori 0xf
    branch CONTINUE

ONE_ZERO_ZERO_ONE:
    load r2
    add r7
    store r7
    branch SKIP
    load r6
    addi 1
    store r6
SKIP:
    load r3
    branch CONTINUE_OPERAND
    xori 0xf
    branch CONTINUE

END:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0                ; LOOP