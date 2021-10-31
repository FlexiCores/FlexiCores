; Simple Program
nandi 0 ; Zero out the accumulator
addi 0xc
branch END
store r5 ; store 13 into output port
LOOP:
add r3
END:
branch 0x77 
branch LOOP
