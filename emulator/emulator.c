#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>

// Architectural State
struct {
    uint8_t PC;
    uint8_t A;
    uint8_t RF [8];
} as, as_next;

typedef enum {
    ADD,
    ADDI,
    NAND,
    NANDI,
    XOR,
    XORI,
    LOAD,
    STORE,
    BR
} op_t;

op_t get_op(uint8_t instr);
#define BR_MASK 0x080
#define IMM_MASK 0x040
#define IMM_EXTRACT 0x0F
#define REG_EXTRACT 0x07
#define BR_EXTRACT 0x07F
uint8_t get_operand(uint8_t instr);
uint8_t compute_result(uint8_t instr, uint8_t operand);
void update_acc(uint8_t instr, uint8_t result, uint8_t operand);
void update_rf(uint8_t instr, uint8_t result);
void update_PC(uint8_t instr);
uint8_t fetch_instr(const char* mem);
void cycle_state(void);
void restart(void);
void run(const char* mem, int ncycles);
char* load_mem(const char* path);
void free_mem(char* mem);


// ADD:   [0|000|0|reg]
// ADDI:  [0|100|x|xxx]
// NAND:  [0|001|0|reg]
// NANDI: [0|101|x|xxx]
// XOR:   [0|010|0|reg]
// XORI:  [0|110|x|xxx]
// LOAD:  [0|111|0|reg]
// STORE: [0|111|1|reg]
op_t get_op(uint8_t instr)
{
    switch (instr >> 4) {
        case 0x00: return ADD;
        case 0x04: return ADDI;
        case 0x01: return NAND;
        case 0x05: return NANDI;
        case 0x02: return XOR;
        case 0x06: return XORI;
        case 0x07: if (instr & 0x08) {return STORE;}
                   else {return LOAD;}
        default: ;
    }
    assert(instr & 0x080);
    return BR;
}

uint8_t get_operand(uint8_t instr)
{
    if (instr & BR_MASK) {
        return instr & ~BR_MASK;
    }
    if (instr & IMM_MASK) {
        return instr & IMM_EXTRACT;
    }
    else {
        return as.RF[instr & REG_EXTRACT];
    }
}

uint8_t compute_result(uint8_t instr, uint8_t operand)
{
    op_t op = get_op(instr);
    switch (op) {
        case ADD:
        case ADDI: return (operand + as.A) & 0x0F;
        case NAND:
        case NANDI: return (~(operand & as.A)) & 0x0F;
        case XOR:
        case XORI: return (operand ^ as.A) & 0x0F;
        default: return 0;
    }
}

void update_acc(uint8_t instr, uint8_t result, uint8_t operand)
{
    op_t op = get_op(instr);
    switch (op) {
        case STORE:
        case BR: return;
        case LOAD:
            as_next.A = as.RF[instr & REG_EXTRACT];
            break;
        default:
            as_next.A = result;
    }
}

void update_rf(uint8_t instr, uint8_t result)
{
    op_t op = get_op(instr);
    if (op == STORE) {
        as_next.RF[instr & REG_EXTRACT] = as.A;
    }
}

void update_PC(uint8_t instr)
{
    printf("instr & BR_MASK: %d\n", instr & BR_MASK);
    printf("as.A & 0x08 : %d\n", as.A & 0x08);
    if ((instr & BR_MASK) && (as.A & 0x08)) {
        as_next.PC = instr & BR_EXTRACT;
    }
    else {
        as_next.PC = as.PC + 1;
    }
}

uint8_t fetch_instr(const char* mem)
{
    return mem[as.PC];
}

void cycle_state(void)
{
    as = as_next;
}

void restart(void)
{
    as.PC = 0;
}

void run(const char* mem, int ncycles)
{
    restart();
    unsigned count = 0;
    while (ncycles--) {
        printf("Cycle %0d:\n\t"
               "PC: %0d\n\t"
               "A:  %0d\n\t"
               "RF[0]: %0d\n",
               count++, as.PC, as.A, as.RF[0]);
        uint8_t instr, operand, result;
        instr = fetch_instr(mem);
        operand = get_operand(instr);
        result = compute_result(instr, operand);
        update_acc(instr, result, operand);
        update_rf(instr, result);
        update_PC(instr);
        cycle_state();
    }
}

char* load_mem(const char* path)
{
    char* rv = malloc(256);
    if (rv == NULL) {
        perror("malloc");
        exit(1);
    }
    FILE* f = fopen(path, "rb");
    if (f == NULL) {
        perror("fopen");
        exit(1);
    }

    unsigned long retval = fread(rv, 1, 256, f);
    if (ferror(f)) {
        perror("ferror");
        exit(1);
    }
    if (!feof(f)) {
        fprintf(stderr, "Input file > 256 bytes\n");
        exit(1);
    }

    fclose(f);
    return rv;
}

void free_mem(char* mem)
{
    free(mem);
}

int main(int argc, char** argv)
{
    if (argc != 2) {
        fprintf(stderr, "usage: %s <bin>\n", argv[0]);
        exit(1);
    }
    char* mem = load_mem(argv[1]);
    // char mymem[256] = {
    //      0x5F // NANDI 0xF
    //     ,0x47 // ADDI 0x7
    //     ,0x78 // STORE into 0
    //     // LOOP
    //     ,0x70 // LOAD from 0
    //     ,0x4F // ADDI 0x0F
    //     ,0x78 // STORE into 0
    //     ,0x6F // INV (XORI 0xF)
    //     ,0x83 // BR LOOP
    //     ,0x6F // INV
    //     // HALT LOOP
    //     ,0x89 // BR HALT LOOP
    // };
    // run(mymem, 100);
    free_mem(mem);
}
