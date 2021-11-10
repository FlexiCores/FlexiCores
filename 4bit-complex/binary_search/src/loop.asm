    load r5
    addi 3
    store r0                ; reset FSM

    load r4                 ; if (r >= l)
    branch n NX
    load r3 
    branch n PN

NN:
    load r3
    nandi 0xf
    addi 1
    add r4
    branch n EDGE_CASE
    xori 0xf
    branch n SEARCH

NX:
    load r3
    branch n NN
    xori 0xf
    branch n NP

PN:
    branch n SEARCH
    xori 0xf
    branch n SEARCH

NP:
    branch n EDGE_CASE
    xori 0xf
    branch n EDGE_CASE

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
    branch n DIVISION_END
    store r6
    load r7
    addi 1
    store r7
    branch n SUBTRACT
    xori 0xf
    branch n SUBTRACT

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
    branch n NXNX
    load r2
    branch n LARGER

NNNN:
    load r2             ; arr[mid] >=< x
    nandi 0xf
    addi 1
    add r6
    store r6
    branch n LESS
    load r6
    add r6
    store r6
    branch n LARGER
    load r6
    add r6
    store r6
    branch n LARGER
    load r6
    add r6
    store r6
    branch n LARGER
    xori 0xf
    branch n EQUAL

NXNX:
    load r2
    branch n NNNN
    xori 0xf
    branch n LESS

; binarySearch(arr, mid + 1, r, x);
LESS:
    load r7
    addi 1
    store r3
    branch n LOOP
    xori 0xf
    branch n LOOP

; return binarySearch(arr, l, mid - 1, x);
LARGER:
    load r7
    addi 0xf
    store r4
    branch n LOOP
    xori 0xf
    branch n LOOP

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