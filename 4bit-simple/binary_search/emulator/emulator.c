#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <assert.h>
#include <string.h>

/* Architectural State */
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

/* Program Pages */
char* init;
char* loop;

/* State Machine Information */
typedef enum {
    START,
    OTHER_0,
    OTHER_1,
    OTHER_2,
    OPERATION_0,
    OPERATION_1,
    OPERATION_2,
    X,
    L,
    R,
    ARR_0,
    ARR_1,
    ARR_2,
    LOOP,
    RETURN_0,
    RETURN_1,
    RETURN_2
} state;

/* Sorted Array Information */
uint8_t arr[8] = { 0 };         // The sorted array
uint8_t size = 0;               // The number of elements in the array
uint8_t x;                      // The element to search for


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
uint8_t read_input(char* prompt);

void fill_input_file(const char* path);


/* Read Keyboard Input */
uint8_t read_input(char* prompt)
{
    char buff[10];
    printf("%s", prompt);
    if(fgets(buff, sizeof(buff), stdin) == NULL)
    {
        perror("fgets");
        exit(1);
    }
    return atoi(buff);
}

/* Parse the sorted array and the number to search for */
void fill_input_file(const char* path)
{
    FILE * fp = fopen(path, "r");
    const char delim[3] = " ,";
    char * token;

    if(fp != NULL)
    {
        char buff[2000];
        if(fgets(buff, sizeof(buff), fp) == NULL)
        {
            perror("fgets");
            exit(1);
        }
        token = strtok(buff, delim);
        while(token != NULL)
        {
            arr[size] = atoi(token);
            size++;
            token = strtok(NULL, delim);
            if(size == 8 && token != NULL)
            {
                perror("input array is too large");
                exit(1);
            }
        }    
        if(fgets(buff, sizeof(buff), fp) == NULL)
        {
            perror("fgets");
            exit(1);
        }
        x = atoi(buff);
    }
    else
    {
        perror(path);
        exit(1);
    }

    printf("Sorted Array: ");
    for(int i = 0; i < size; i++)
    {
        if(i == size - 1)
        {
            printf("%d\n", arr[i]);
        }
        else
        {
            printf("%d, ", arr[i]);    
        }
        
    }
    printf("size: %d\n", size);
    printf("x: %d\n", x);
}

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
    // printf("instr & BR_MASK: %d\n", instr & BR_MASK);
    // printf("as.A & 0x08 : %d\n", as.A & 0x08);
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

    /* Initialize State Machine */
    state st = START;

    unsigned count = 0;
    while (ncycles--) {
        // printf("Cycle %0d:\n\t"
        //        "PC: %0d\n\t"
        //        "A:  %0d\n\t"
        //        "RF[0]: %0d\n\t"
        //        "RF[1]: %0d\n\t"
        //        "RF[2]: %0d\n\t"
        //        "RF[3]: %0d\n\t"
        //        "RF[4]: %0d\n\t"
        //        "RF[5]: %0d\n\t"
        //        "RF[6]: %0d\n\t"
        //        "RF[7]: %0d\n\t"
        //        "State: %0d\n",
        //        count++, as.PC, as.A, as.RF[0], as.RF[1], as.RF[2], as.RF[3], as.RF[4], as.RF[5], as.RF[6], as.RF[7], st);
        uint8_t instr, operand, result;
        instr = fetch_instr(mem);
        operand = get_operand(instr);
        result = compute_result(instr, operand);
        update_acc(instr, result, operand);
        update_rf(instr, result);
        update_PC(instr);
        cycle_state();

        // Grab the lower half of OPORT.
        uint8_t oport_lower = as.RF[0] & 0x3;

        switch (st) 
        {
            case START:
                if(oport_lower == 1)
                {
                    st = OPERATION_0;
                }
                else if(oport_lower == 2)
                {
                    st = OTHER_0;
                }
                break;
            case OTHER_0:
                if(oport_lower == 0)
                {
                    st = OTHER_2;
                }
                else if(oport_lower == 1)
                {
                    st = OTHER_1;
                }
                break;
            case OTHER_1:
                if(oport_lower == 0)
                {
                    st = L;
                    as.RF[1] = 0;
                }
                else if(oport_lower == 2)
                {
                    st = X;
                    as.RF[1] = x;
                }
                break;
            case X:
                if(oport_lower == 3)
                {
                    st = START;
                }
                break;
            case L:
                if(oport_lower == 3)
                {
                    st = START;
                }
                break;
            case OTHER_2:
                if(oport_lower == 1)
                {
                    st = R;
                    as.RF[1] = size - 1;
                }
                else if(oport_lower == 2)
                {
                    st = ARR_0;
                }
                break;
            case R:
                if(oport_lower == 3)
                {
                    st = START;
                }
                break;
            case ARR_0:
                st = ARR_1;
                break;
            case ARR_1:
                st = ARR_2;
                as.RF[1] = arr[(as.RF[0] & 0xfUL)];
                break;
            case ARR_2:
                if(oport_lower == 3)
                {
                    st = START;
                }
                break;
            case OPERATION_0:
                if(oport_lower == 2)
                {
                    st = OPERATION_1;
                }  
                break;
            case OPERATION_1:
                if(oport_lower == 0)
                {
                    st = LOOP;
                    restart();
                    mem = loop;
                }
                else if(oport_lower == 1)
                {
                    st = RETURN_0;
                }
                break;
            case LOOP:
                if(oport_lower == 3)
                {
                    st = START;
                }
                break;
            case RETURN_0:
                st = RETURN_1;
                break;
            case RETURN_1:
                st = RETURN_2;
                if((as.RF[0] & 0xfUL) == 15)
                {
                    printf("=======================================\n");
                    printf("Element Not Found\n");
                    printf("=======================================\n");
                }
                else
                {
                    printf("=======================================\n");
                    printf("Found! Index: %d\n", as.RF[0]);
                    printf("=======================================\n");
                }
                return;
                break;
            case RETURN_2:
                if(oport_lower == 3)
                {
                    st = START;
                }
                break;
        }   
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
    /* Load program pages. */
    init = load_mem("init.lst");
    loop = load_mem("loop.lst");

    /* Fill input */
    fill_input_file("input.txt");

    /* Execute linkage. */
    run(init, 3000);

    /* Free program pages. */
    free_mem(init);
    free_mem(loop);
}
