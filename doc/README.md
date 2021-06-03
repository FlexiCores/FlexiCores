# FlexiCore 4-bit Simple CPU

This very small CPU is manufacturable with high yield using PragmatIC's
flexible silicon process on their small-area dies. In order to have high
yield in small area on this process, the CPU is very limited in terms of
I/O pads and gate count (circuit area is less than 700x NAND2 equivalent).

To minimize size, the core uses a RISC architecture which supports a
single-cycle microarchitectural implementation (all instructions take a single
cycle to execute, including fetch, decode, execute, and writeback).

Originally, the plan was to integrate a read-only program memory onto the
die in order to make a stand alone system.
However, this was not feasible with current technology, so instructions
are fetched from an off-chip memory.  There is no explicit data-memory port,
so programmers are limited to the register file and creative use of the
IPORT and OPORT ports.

## Architectural State

### PC

The program counter is a 7-bit register

### Regfile

The registerfile is an 8x4-bit regfile.  Two registers are special purpose:

#### OPORT

R0 is the 'output port' --- this register is RO visible off cpu.

#### IPORT

R1 is the 'input port' --- this register is RO on the cpu.

#### GP

R2 - R7 are general purpose 4-bit registers

### Accumulator (A)

The CPU has a 4-bit accumulator, which is the implicit target of all
logical and arithmetic instructions.  Also, LOAD instructions use it
as the implicit destination register, and STORE instructions use it as the
implicit source register.

## Instructions

### ADD(I?)

![ADD](./diag/add.svg)

```
A  <- A + src
PC <- PC + 1
```

![ADDI](./diag/addi.svg)

```
A <- A + imm4
PC <- PC + 1
```

### NAND(I?)

![NAND](./diag/nand.svg)

```
A  <- ~(A & src)
PC <- PC + 1
```

![NANDI](./diag/nandi.svg)

```
A <- ~(A & imm4)
PC <- PC + 1
```

### XOR(I?)

![NAND](./diag/xor.svg)

```
A  <- A ^ src
PC <- PC + 1
```

![NANDI](./diag/xori.svg)

```
A <- A ^ imm4
PC <- PC + 1
```

### LOAD

![LOAD](./diag/load.svg)

```
A <- src 
PC <- PC + 1
```

### STORE

![LOAD](./diag/store.svg)

```
if dst != IPORT
    dst <- A
PC <- PC + 1
```

### BRANCH

![BRANCH](./diag/branch.svg)

```
if A & 0x8
    PC <- target
else
    PC <- PC + 1
```
