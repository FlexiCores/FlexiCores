; See init.asm for program description

    load r5
    addi 3
    store r0                ; reset FSM

    ; Add b to a*X1
;    load r4
;    add r7
;    store r7

    ; Wk2
    load r4
    branch n MSB_ONE

CONTINUE:
    load r7
    branch n MIGHT_OVERFLOW
    load r4
    addi 0xf
    store r4
    branch n DONE_ADDING
    load r7
    addi 1
    store r7
    branch n CONTINUE
    xori 0xf
    branch n CONTINUE
    ; Wk2

MIGHT_OVERFLOW:
    load r4
    addi 0xf
    store r4
    branch n DONE_ADDING
    load r7
    addi 1
    store r7
    branch n CONTINUE         ; NO OVERFLOW
    load r6                 ; OVERFLOWED
    addi 1
    store r6
    branch n CONTINUE
    xori 0xf
    branch n CONTINUE

MSB_ONE:
    load r4
    addi 8
    store r4
    load r7
    branch n OVERFLOW
    load r7
    addi 8
    store r7
    branch n CONTINUE
    xori 0xf
    branch n CONTINUE

OVERFLOW:
    load r7
    addi 8
    store r7
    load r6
    addi 1
    store r6
    branch n CONTINUE
    xori 0xf
    branch n CONTINUE
DONE_ADDING:

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
    branch n CLASS_ZERO
    add r6
    store r6
    branch n CLASS_ZERO
    add r6
    store r6
    branch n CLASS_ZERO
    add r6
    store r6
    branch n CLASS_ZERO       ; we know R6 = 0

    load r3
    branch n ONE_X
    load r7
    branch n CLASS_ZERO                 ; ZERO_ONE

COMPARE:
    xori 0
DECREMENT:
    load r7
    branch n CLASS_ONE
    load r3
    branch n CLASS_ZERO
    load r3
    addi 0xf
    store r3
    load r7
    addi 0xf
    store r7
    branch n DECREMENT
    xori 0xf
    branch n DECREMENT



ONE_X:
    load r7
    branch n ONE_ONE
    xori 0xf
    branch n CLASS_ONE                 ; ONE_ZERO

ONE_ONE:
    load r3
    addi 8
    store r3
    load r7
    addi 8
    store r7                         ; subtract 8 from both
    branch n COMPARE
    xori 0xf
    branch n COMPARE


CLASS_ONE:
    load r5
    addi 1
    store r2
    branch n END
    xori 0xf
    branch n END

CLASS_ZERO:
    load r5
    store r2
;    branch n END
;    xori 0xf
;    branch n END

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

