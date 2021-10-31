`include "params.v"
`include "core.v"
module top;
    logic CLK, RSTN;
    logic [`DATA_LEN-1:0] IPORT, OPORT;
    logic [`PC_LEN-1:0] PC;
    logic [`INSTR_LEN-1:0] INSTR;

    logic [`INSTR_LEN-1:0] init_rom [128];
    logic [`INSTR_LEN-1:0] loop_rom [128];
    logic [3:0] arr [8];
    logic [3:0] x;

    initial begin : Clock_setup
        CLK = 1'b0;
        forever #5 CLK = CLK === 1'b0;
    end

    default clocking @(posedge CLK);
    endclocking

    initial begin : Dump_setup
        $dumpfile("bsearch.vcd");
        $dumpvars(1, core);
    end

    initial begin : mem_setup
        $readmemh("hex/init.hex",  init_rom);
        $readmemh("hex/loop.hex",  loop_rom);
        arr[0] = 0;
        arr[1] = 1;
        arr[2] = 1;
        arr[3] = 3;
        arr[4] = 4;
        arr[5] = 4;
        arr[6] = 5;
        arr[7] = 6;
        x = 3;
    end

    core dut(.*);
    logic [1:0] oport_lower;
    logic page_change;
    assign oport_lower = OPORT[1:0];
    enum {MINIT, MLOOP} rom_ptr;

    task restart;
        rom_ptr = MINIT;
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

    always_comb begin : instr_assignment
        case (rom_ptr)
            MINIT: INSTR  = init_rom[PC];
            MLOOP: INSTR  = loop_rom[PC];
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
                
             OTHER_1:
                if(oport_lower == 0)
                begin
                    st = L;
                    IPORT = 0;
                end
                else if(oport_lower == 2)
                begin
                    st = X;
                    IPORT = x;
                end
                
             X:
                if(oport_lower == 3)
                begin
                    st = START;
                end
                
             L:
                if(oport_lower == 3)
                begin
                    st = START;
                end
                
             OTHER_2:
                if(oport_lower == 1)
                begin
                    st = R;
                    IPORT = 7; // size - 1;
                end
                else if(oport_lower == 2)
                begin
                    st = ARR_0;
                end
                
             R:
                if(oport_lower == 3)
                begin
                    st = START;
                end
                
             ARR_0: st = ARR_1;
                
             ARR_1: begin
                st = ARR_2;
                IPORT = arr[OPORT];
             end
                
             ARR_2:
                if(oport_lower == 3)
                begin
                    st = START;
                end
                
             OPERATION_0:
                if(oport_lower == 2)
                begin
                    st = OPERATION_1;
                end  
                
             OPERATION_1:
                if(oport_lower == 0)
                begin
                    st = LOOP;
                    page();
                    rom_ptr = MLOOP;
                end
                else if(oport_lower == 1)
                begin
                    st = RETURN_0;
                end
                
             LOOP: begin
                if(oport_lower == 3)
                begin
                    st = START;
                end
             end
                
             RETURN_0: st = RETURN_1;
                
             RETURN_1: begin
                st = RETURN_2;
                if (OPORT == 15)
                begin
                    $display("=======================================\n");
                    $display("Element Not Found\n");
                    $display("=======================================\n");
                end
                else
                begin
                    $display("=======================================\n");
                    $display("Found! Index: %d\n", OPORT);
                    $display("=======================================\n");
                end
                $finish;
            end
                
             RETURN_2:
                if(oport_lower == 3)
                begin
                    st = START;
                end
                
            endcase
        end
        $finish;
    end

endmodule
