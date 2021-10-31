    load r5
    addi 3
    store r0                ; reset FSM

    load r4                 ; if (r >= l)
    branch NX
    load r3 
    branch PN

NN:
    load r3
    nandi 0xf
    addi 1
    add r4
    branch EDGE_CASE
    xori 0xf
    branch SEARCH

NX:
    load r3
    branch NN
    xori 0xf
    branch NP

PN:
    branch SEARCH
    xori 0xf
    branch SEARCH

NP:
    branch EDGE_CASE
    xori 0xf
    branch EDGE_CASE

SEARCH:
    load r5             ; int mid = l + (r - l) / 2;
    store r7
    load r3
    nandi 0xf
    addi 1
    add r4
    store r6

SUBTRACT:
    load r5
    addi 0xe
    add r6
    branch DIVISION_END
    store r6
    load r7
    addi 1
    store r7
    branch SUBTRACT
    xori 0xf
    branch SUBTRACT

DIVISION_END:
    load r7
    add r3
    store r7

    load r5            ; arr[mid]
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
    load r1
    store r6
    load r5
    addi 3
    store r0            ; reset FSM


    load r6
    branch NXNX
    load r2
    branch LARGER

NNNN:
    load r2             ; arr[mid] >=< x
    nandi 0xf
    addi 1
    add r6
    store r6
    branch LESS
    load r6
    add r6
    store r6
    branch LARGER
    load r6
    add r6
    store r6
    branch LARGER
    load r6
    add r6
    store r6
    branch LARGER
    xori 0xf
    branch EQUAL

NXNX:
    load r2
    branch NNNN
    xori 0xf
    branch LESS

; binarySearch(arr, mid + 1, r, x);
LESS:
    load r7
    addi 1
    store r3
    branch LOOP
    xori 0xf
    branch LOOP

; return binarySearch(arr, l, mid - 1, x);
LARGER:
    load r7
    addi 0xf
    store r4
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

EDGE_CASE:
    load r5
    addi 0xf
    store r7
EQUAL:
    load r5
    addi 1
    store r0
    load r5
    addi 2
    store r0
    load r5
    addi 1
    store r0    
    load r7
    store r0