# FlexiCore 8-bit Simple CPU

This very small CPU is manufacturable with high yield using PragmatIC's
flexible silicon process on their small-area dies. In order to have high
yield in small area on this process, the CPU is very limited in terms of
I/O pads and gate count.

To minimize size, the core uses a RISC architecture which supports a
single-cycle microarchitectural implementation (all but one instruction take a
single cycle to execute, including fetch, decode, execute, and writeback).

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

The registerfile is an 4x8-bit regfile.  Two registers are special purpose:

#### OPORT

R0 is the 'output port' --- this register is the 7 least significant
bits of RO visible off cpu.

#### IPORT

R1 is the 'input port' --- this register is R1 on the cpu.

#### GP

R2 - R3 are general purpose 4-bit registers

### Accumulator (A)

The CPU has a 8-bit accumulator, which is the implicit target of all
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
A <- A + sext8(imm4)
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
A <- ~(A & sext8(imm4))
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
A <- A ^ sext8(imm4)
PC <- PC + 1
```

### LOAD

![LOAD](./diag/load.svg)

```
A <- regfile[reg]
PC <- PC + 1
```

### LOAD BYTE

![LOAD BYTE](./diag/load_byte.svg)
![BYTE](./diag/byte.svg)

```
A <- byte
PC <- PC + 2
```

### STORE

![LOAD](./diag/store.svg)

```
if dst != IPORT
    regfile[dst] <- A
PC <- PC + 1
```

### BRANCH

![BRANCH](./diag/branch.svg)

```
if A & 0x80
    PC <- target
else
    PC <- PC + 1
```

## Port Listings

### Input Ports

#### CLK

A 1-bit clock signal.

#### RSTN

A 1-bit, active-low reset signal.

#### IPORT

A 7-bit port usable by peripherals.
This port is accessible from software through mapping to register
R1.  Since the input bus is 7-bits, but the register is 8-bits, the 7-bit
bus signal is sign extended to 8-bits.

#### INSTR

An 8-bit port used to fetch an instruction.

### Output Ports

#### OPORT
 
This 7-bit port is used to expose the least significant bits of
register R0 to off-chip devices.

#### PC

A 7-bit port used to fetch an instruction. This port exposes the program
counter to off-chip devices.

## Instruction Fetch

With the exception of the `LOAD_BYTE` instruction,
FlexiCore operates as a single-cycle computer. In other words, it has a pipeline depth
of 1.
Instruction fetch, decode, and execute occur in a single clock cycle.
As such, in a single cycle FlexiCore must fetch the instruction located
at the PC port's location, decode the instruction, and perform the requested
operation.  To this end, either program memory can be stored in an asynchronous
SRAM, or other unclocked memory, or it can be stored in a synchronous memory
which is clocked at a clock rate sufficiently faster than FlexiCore's.
the `LOAD_BYTE` instruction operates in two cycles, with the second cycle
being used to fetch the immediate byte from program memory and store it
into the Accumulator.

