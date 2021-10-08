; See init.asm for program description

    load r5
    addi 3
    store r0                ; reset FSM

    ; Add b to a*X1
    load r4
    add r7
    store r7

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
    store r3                ; IPORT X2
    load r5
    addi 3
    store r0                ; reset FSM

;   COMPARE
    load r6
    branch CLASS_ZERO
    add r6
    store r6
    branch CLASS_ZERO
    add r6
    store r6
    branch CLASS_ZERO
    add r6
    store r6
    branch CLASS_ZERO       ; we know R6 = 0

    load r3
    branch ONE_X
    load r7
    branch CLASS_ZERO                 ; ZERO_ONE

COMPARE:
    xori 0
DECREMENT:
    load r7
    branch CLASS_ONE
    load r3
    branch CLASS_ZERO
    load r3
    addi 0xf
    store r3
    load r7
    addi 0xf
    store r7
    branch DECREMENT
    xori 0xf
    branch DECREMENT



ONE_X:
    load r7
    branch ONE_ONE
    xori 0xf
    branch CLASS_ONE                 ; ONE_ZERO

ONE_ONE:
    load r3
    addi 8
    store r3
    load r7
    addi 8
    store r7                         ; subtract 8 from both
    branch COMPARE
    xori 0xf
    branch COMPARE


CLASS_ONE:
    load r5
    addi 1
    store r2
    branch END
    xori 0xf
    branch END

CLASS_ZERO:
    load r5
    store r2
    branch END
    xori 0xf
    branch END

END:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0
    load r2
    store r0                ; END

