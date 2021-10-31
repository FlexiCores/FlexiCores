; Loads a value on the input port, increments it and moves it to the output
; port
START:
    load r1
    addi 1
    store r0
    branch START
    ; in case this branch did not take
    store r7
    nand r7
    branch START

