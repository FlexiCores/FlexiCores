; Iterative Decision Tree
; Height:         7
; Internal Nodes: 127
; Leaf Nodes:     128
;       1
;     /   \
;    2      3
;  /  \    /  \
; 4    5  6    7
;      ....
; 
; -> The numbers are node indices.
; -> In internal nodes, the node indices point to feature values and weights. 
; -> In leaf nodes, the node indices point to class labels. 
; -> If feature value >= weight, branch left (node_index = node_index * 2).
; -> If feature value < weight, branch right (node_index = node_index * 2 + 1).
; -> Node indices can be integers on the interval [1, 255].
; -> Feature values and weights can be integers on the interval [-8, 7].
; -> Class lables can be integers on the interval [0, 127].
;      Inputs: feature values and weights from IPORT.
;     Outputs: class label index displayed to OPORT.
; Performance: 400 - 500 cycles generally
;   Registers:    R3 - feature value register
;                 R4 - weight register
;                 R5 - permanent 0 register
;              R6:R7 - node index register




    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 0
    store r6
    load r5
    addi 1
    store r7                ; node index = 1
        
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