`include "params.v"
module tb;
    // Constants
    localparam PC_LEN = `PC_LEN;
    localparam DATA_LEN = `DATA_LEN;
    localparam INSTR_LEN = `INSTR_LEN;
    localparam MAX_PAGES = 128; // Obviously can change if needed
    localparam STDERR = 32'h8000_0002;
    localparam DEFAULT_CYCLES = 10_000;

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

    // Instantiate design-under-test
    core DUT (.*);

    // Program Memory
    int unsigned page_ptr;
    logic [INSTR_LEN-1:0] pages [1 << PC_LEN] [MAX_PAGES];

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
        string sources;
        string temp;
        int i;
        if ($value$plusargs("sources=%s", sources)) begin : parse_source_list
            i = 0;
            temp = "";
            foreach (sources[i]) begin
                if (sources[i] == ",") begin
                    if (temp != "") begin
                        source_files.push_back(temp);
                        temp = "";
                    end
                end else begin
                    temp = {temp, sources[i]};
                end
            end
            if (temp != "") begin
                source_files.push_back(temp);
            end
            foreach (source_files[i]) begin
                $display("source file %d = %s", i, source_files[i]);
                $readmemh(source_files[i], pages, (1 << PC_LEN) * i,
                                                  (1 << PC_LEN) * (i+1));
                foreach (pages[i][j]) begin
                    $display("pages[%0d][%0d] = %2h", i, j, pages[i][j]);
                end
            end
        end else begin
            $fdisplay(STDERR,
                "requires source list: \"+sources=<source-list>\"");
            $finish;
        end
    end

    task restart();
        RSTN = 1'b0;
        ##4;
        RSTN = 1'b1;
    endtask

    initial begin : run_program
        int unsigned cycles, max_cycles;
        logic [PC_LEN-1:0] last_pc;
        last_pc = 50; // Just something not zero

        if (!$value$plusargs("cycles=%u", cycles)) begin
            cycles = DEFAULT_CYCLES;
        end
        max_cycles = cycles;

        restart();

        // Will print to the screen anytime one of the 'monitored' signals
        // changes.
        $monitor("PC: %2h", PC);

        while (cycles--) begin
            if (PC == last_pc) begin
                $display("Halt Loop Detected");
                $finish;
            end
            last_pc = PC;
            ##1;
        end
        $display("Time-out ocurred after %d cycles", max_cycles);
        $finish;
    end

    initial begin : dump_file
        $dumpfile("simulation.vcd");
        // Only dump values defined in the testbench
        $dumpvars(1, tb);
    end

endmodule : tb
