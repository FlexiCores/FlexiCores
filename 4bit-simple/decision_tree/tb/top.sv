`include "params.v"
`include "core.v"
module top;
    logic CLK, RSTN;
    logic [`DATA_LEN-1:0] IPORT, OPORT;
    logic [`PC_LEN-1:0] PC;
    logic [`INSTR_LEN-1:0] INSTR;

    logic [`INSTR_LEN-1:0] root_rom [128];
    logic [`INSTR_LEN-1:0] left_rom [128];
    logic [`INSTR_LEN-1:0] right_rom [128];

    initial begin : Clock_setup
        CLK = 1'b0;
        forever #5 CLK = CLK === 1'b0;
    end

    default clocking @(posedge CLK);
    endclocking

    initial begin : Dump_setup
        $dumpfile("dtree.vcd");
        $dumpvars(1, core);
    end

    initial begin : mem_setup
        $readmemh("hex/dt_root.hex",  root_rom);
        $readmemh("hex/dt_left.hex",  left_rom);
        $readmemh("hex/dt_right.hex", right_rom);
    end

    core dut(.*);
    logic [1:0] oport_lower;
    logic page_change;
    assign oport_lower = OPORT[1:0];

    task restart;
        RSTN = 1'b0;
        ##1 RSTN = 1'b1;
    endtask

    task page;
        // page_change = 1'b1;
        // ##1 page_change = 1'b0;
        $display("Page Change");
        $monitoroff();
        while (PC != 0) begin
            page_change = 1'b1;
            ##1;
        end
        $monitoron();
        page_change = 1'b0;
    endtask

    function logic [3:0] read_input_command();
        logic [1:0] val;
        val = $random();
        return 1 << val;
    endfunction

    function logic [3:0] read_input();
        logic [3:0] rv;
        rv = $random();
        return rv;
    endfunction

    enum {MROOT, MLEFT, MRIGHT} rom_ptr;
    always_comb begin : instr_assignment
        case (rom_ptr)
            MROOT: INSTR  = root_rom[PC];
            MLEFT: INSTR  = left_rom[PC];
            MRIGHT: INSTR = right_rom[PC];
        endcase
        if (page_change) begin
            INSTR = 8'b1_000_0000; // BRANCH 0
        end
    end

    initial begin : reactive_system
        enum {
            START,
            OTHER_0,
            OTHER_1,
            OTHER_2,
            OPERATION_0,
            OPERATION_1,
            OPERATION_2,
            FEATURE_WAIT,
            FEATURE_REQUEST,
            FEATURE_FETCH,
            LEFT,
            RIGHT,
            CASE_0,
            CASE_1,
            CASE_2,
            CASE_3
        } st;
        logic [3:0] temp = 4'h0;
        logic is_dividing = 1'b0;
        int ncycles = 250_000;

        IPORT = 4'h0;
        st = START;
        // $monitor("state: %s, instr: %2h, olow: %2b, out: %4b, pc: %2x",
        //         state.name(), INSTR, OPORT[1:0], OPORT, PC);
        restart();

        forever begin
            ##1;
            case (st)
             START:
                if(oport_lower == 1)
                begin
                    st = OPERATION_0;
                end
                else if(oport_lower == 2)
                begin
                    st = OTHER_0;
                end
                
             OTHER_0:
                if(oport_lower == 0)
                begin
                    st = OTHER_2;
                end
                else if(oport_lower == 1)
                begin
                    st = OTHER_1;
                end  
                  
             OTHER_1: if(oport_lower == 2) st = FEATURE_WAIT;
                
            OTHER_2: begin
                if(oport_lower == 1)
                begin
                    st = CASE_0;
                    $display("=======================================\n");
                    $display("Classified as Label 0\n");
                    $display("=======================================\n");
                    $finish;
                end
                else if(oport_lower == 2)
                begin
                    st = CASE_1;
                    $display("=======================================\n");
                    $display("Classified as Label 1\n");
                    $display("=======================================\n");
                    $finish;
                end  
            end
                
             OPERATION_0:
                if(oport_lower == 0)
                begin
                    st = OPERATION_2;
                end  
                else if(oport_lower == 2)
                begin
                    st = OPERATION_1;
                end  
                
            OPERATION_1: begin
                if(oport_lower == 0)
                begin
                    st = LEFT;
                    restart();
                    rom_ptr = MLEFT;
                    page();
                end
                else if(oport_lower == 1)
                begin
                    st = RIGHT;
                    restart();
                    rom_ptr = MRIGHT;
                    page();
                end
            end
                
            OPERATION_2: begin
                if(oport_lower == 1)
                begin
                    st = CASE_3;
                    $display("=======================================\n");
                    $display("Classified as Label 3\n");
                    $display("=======================================\n");
                    $finish();
                end
                else if(oport_lower == 2)
                begin
                    st = CASE_2;
                    $display("=======================================\n");
                    $display("Classified as Label 2\n");
                    $display("=======================================\n");
                    $finish();
                end
            end
                
             FEATURE_WAIT: st = FEATURE_REQUEST;
                
            FEATURE_REQUEST: begin
                st = FEATURE_FETCH;
                IPORT = read_input();
                $display("%dth feature: %d", OPORT, IPORT);
            end
            FEATURE_FETCH: begin
                if(oport_lower == 3)
                begin
                    st = START;
                end  
            end
                
            LEFT: begin
                if(oport_lower == 3)
                begin
                    st = START;
                end  
            end
                
            RIGHT: begin
                if(oport_lower == 3)
                begin
                    st = START;
                end  
            end
            endcase
        end
        $finish;
    end

endmodule
