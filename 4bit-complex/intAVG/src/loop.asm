; See init.asm for program description

    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 2
    store r3                ; R3 <- 0x2

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
    add r2 
    store r2                ; IPORT input
    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    store r7                ; clear quotient before division

; DIVISION KERNEL (stripped down significantly since we only ever /2)
    load r2
    branch n NP

    load r3                 
    nandi 0xf
    addi 1
    store r3                ; Negate R3

PP_SUBTRACT:
    load r2
    add r3
    branch n END
    store r2
    load r7
    addi 1
    store r7
    branch n PP_SUBTRACT
    xori 0xf
    branch n PP_SUBTRACT

NP:
    load r2
    nandi 0xf
    addi 1
    store r2
    load r3       
    nandi 0xf
    addi 1
    store r3                
NP_SUBTRACT:
    load r2
    add r3
    branch n NP_DONE
    store r2
    load r7
    addi 1
    store r7
    branch n NP_SUBTRACT
    xori 0xf
    branch n NP_SUBTRACT

NP_DONE:
    load r7
    nandi 0xf
    addi 1
    store r7
    branch n END
    xori 0xf
    branch n END
; DIVISION KERNEL

END:
    load r7
    store r2               ; output <- quotient

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

