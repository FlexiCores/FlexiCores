; Decision Tree of height 2.
;       0[0]
;     /   \
;    1[4]   2[-4]
;  /  \    /  \
; 0    1  2    3
; In internal nodes, the number is the feature index.  
; In leaf nodes, the number is the class label.
; The number in [] is the weight.
; If feature >= weight, branch left.
; If feature < weight, branch right.
; Features and Weights can be integers on the interval [-8, 7].
;    Inputs: at every internal node, a feature is fetched from IPORT.
;   Outputs: class label displayed to OPORT.
; Registers: R2 - feature index register
;            R3 - feature value register
;            R4 - weight register
;            R5 - permanent 0 register



    nandi 0
    addi 1
    store r5          

    load r5
    addi 3
    store r0           

    load r5
    addi 0
    store r2         
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r2
    store r0
    load r1
    store r3
    load r5
    addi 3
    store r0           
    load r5
    store r0

    load r5
    addi 0          ; WEIGHT AT NODE WITH FEATURE INDEX 0
    store r4

    load r3
    branch NX
    load r4 
    branch PN

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
NP:
    branch RIGHT
NN:
    load r4
    nandi 0xf
    addi 1
    add r3
    branch RIGHT
    xori 0xf
    branch LEFT

RIGHT:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0

LEFT:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0