; Calculator Operation: divide one number from another.
; Return to linkage after opertion completed.
;    Inputs: R2 - first operand (in 2's complement)
;            R3 - second operand (in 2's complement)
;   Outputs: R0 - quotient and remainder (in 2's complement) (displayed over 2 cycles, first R7 then R6)
; Registers: R7 - temporary buffer for quotient
;            R6 - temporary buffer for remainder
; Important: Even though the assembly file is 141 lines. The assembled file contains only 108 (< 128) instructions.

    load r5
    addi 3
    store r0
    load r5
    store r0
    
    load r2
    branch NX
    load r3
    branch PN

    load r3                 ; Negate R3
    nandi 0xf
    addi 1
    store r3                ; Negate R3

PP_SUBTRACT:
    load r2
    add r3
    branch PP_REMAINDER
    store r2
    load r7
    addi 1
    store r7
    branch PP_SUBTRACT
    xori 0xf
    branch PP_SUBTRACT

PP_REMAINDER:
    load r2
    store r6
    branch END
    xori 0xf
    branch END

END:
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 2
    store r0
    load r7
    store r0
    load r6
    store r0
    xori 0
    xori 0

NX:
    load r3
    branch NN
    xori 0xf
    branch NP

PN:
    load r2
    add r3
    branch PN_REMAINDER
    store r2
    load r7
    addi 1
    store r7
    branch PN
    xori 0xf
    branch PN

PN_REMAINDER:
    load r2
    store r6
    load r7
    nandi 0xf
    addi 1
    store r7
    branch END
    xori 0xf
    branch END

NN:
    load r2
    nandi 0xf
    addi 1
    store r2
NN_SUBTRACT:
    load r2
    add r3
    branch NN_REMAINDER
    store r2
    load r7
    addi 1
    store r7
    branch NN_SUBTRACT
    xori 0xf
    branch NN_SUBTRACT

NN_REMAINDER:
    load r2
    nandi 0xf
    addi 1
    store r6
    branch END
    xori 0xf
    branch END

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
    branch NP_REMAINDER
    store r2
    load r7
    addi 1
    store r7
    branch NP_SUBTRACT
    xori 0xf
    branch NP_SUBTRACT

NP_REMAINDER:
    load r2
    nandi 0xf
    addi 1
    store r6
    load r7
    nandi 0xf
    addi 1
    store r7
    branch END
    xori 0xf
    branch END