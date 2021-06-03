; Counting program
    nandi 0 ; Zero out the accumulator
    store r0
LOOP:
    load r0
    addi 1
    store r0 
    branch LOOP  // 5
    xori 15
    branch LOOP  // 7
