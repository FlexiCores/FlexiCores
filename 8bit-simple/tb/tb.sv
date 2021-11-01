`include "params.v"
module tb;
    timeunit 10ms/1ms;
    // Constants
    localparam PC_LEN = `PC_LEN;
    localparam DATA_LEN = `DATA_LEN;
    localparam INSTR_LEN = `INSTR_LEN;
    localparam MAX_PAGES = 128; // Obviously can change if needed

    // Port Signals --- inputs as two-valued logic, outputs as quad-value
    bit CLK, RSTN;
    bit [DATA_LEN-2:0] IPORT;
    bit [INSTR_LEN-1:0] INSTR;
    logic [DATA_LEN-2:0] OPORT;
    logic [PC_LEN-1:0] PC;

    // Generate CLK
    always #5 CLK = ~CLK;
    default clocking @(posedge CLK);
    endclocking

    // Program Memory
    unsigned int page_ptr;
    logic [INSTR_LEN-1:0] pages [MAX_PAGES];

    initial begin : pmem_fetch
        page_ptr = 0;
        forever begin
            // For reasons dealing with PragmatIC's test set-up, we change
            // instruction at the negative edge of the clock
            @(negedge CLK) INSTR = pages [page_ptr] [PC];
        end
    end

    initial begin : pmem_load
        string source_files [$];
    end

endmodule : tb
