; Binary Search Algorithm
;
; -> Perform binary search on a sorted array of length at most 8.
; -> "x"   - the target number to search for.   [-8, 7]
; -> "l"   - the left array index.              [ 0, 7]
; -> "r"   - the right array index.             [ 0, 7]
; -> "mid" - the middle array index.            [ 0, 7]
; -> "arr" - the sorted array.                  [-8, 7]
;
;      Inputs: x, l, r, arr
;     Outputs: if found, the index in the array.
;              otherwise, return 0xf .
; Performance: variable.
;   Registers: R2 - x
;              R3 - l
;              R4 - r
;              R5 - permanent 0 register
;              R6 - arr[mid] / dividend
;              R7 - mid / return value
;   Reference: https://www.geeksforgeeks.org/binary-search/

    nandi 0
    addi 1
    store r5                ; clear R5   

    load r5
    addi 3
    store r0                ; reset FSM
        
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
    store r2                ; IPORT x
    load r5
    addi 3
    store r0                ; reset FSM

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
    store r3                ; IPORT l
    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0
    load r5
    addi 1
    store r0                
    load r1 
    store r4                ; IPORT r
    load r5
    addi 3
    store r0                ; reset FSM

    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 0
    store r0                ; LOOP