; Left Subtree
; See dt_root.asm for details.

    load r5
    addi 3
    store r0           

    load r5
    addi 1
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
    addi 4          ; WEIGHT AT NODE WITH FEATURE INDEX 1
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

; CASE 1
RIGHT:
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0

; CASE 0
LEFT:
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 1
    store r0