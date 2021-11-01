; Outputs 0, 1, 2, 3, or 4 set lights
START:
    ; Clear out the accumulator and the output port
    store r0 ; sneaky --- for purpose of simulation, accumulator is zero initially
    load r0
    xor r0
    store r0
    store r7 ; use r7 as zero register
    ; Set loop1 Counter (r2)
    addi 0xb
    store r2
LOOP1:
    ; Set loop2 Counter (r3)
    load r7
    addi 0xf
    store r3
LOOP2:
    load r3
    addi 0xf
    store r3
    branch LOOP2
; LOOP2 End
    load r0
    add r0
    addi 1
    store r0
    load r2
    addi 0xf
    store r2
    branch LOOP1
 
 HALT:
    load r7
    addi 8
    branch HALT

