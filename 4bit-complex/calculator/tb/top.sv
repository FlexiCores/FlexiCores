`include "params.v"
`include "core.v"
module top;
    logic CLK, RSTN;
    logic [`DATA_LEN-1:0] IPORT, OPORT;
    logic [`PC_LEN-1:0] PC;
    logic [`INSTR_LEN-1:0] INSTR;

    logic [`INSTR_LEN-1:0] linkage_rom [128];
    logic [`INSTR_LEN-1:0] add_rom [128];
    logic [`INSTR_LEN-1:0] sub_rom [128];
    logic [`INSTR_LEN-1:0] mul_rom [128];
    logic [`INSTR_LEN-1:0] div_rom [128];


    initial begin : Clock_setup
        CLK = 1'b0;
        forever #5 CLK = CLK === 1'b0;
    end

    default clocking @(posedge CLK);
    endclocking

    initial begin : Dump_setup
        $dumpfile("calculator.vcd");
        $dumpvars(1, core);
    end

    initial begin : mem_setup
        $readmemh("hex/linkage.hex",        linkage_rom);
        $readmemh("hex/calc_add.hex",       add_rom);
        $readmemh("hex/calc_subtract.hex",  sub_rom);
        $readmemh("hex/calc_multiply.hex",  mul_rom);
        $readmemh("hex/calc_divide.hex",    div_rom);
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
        if (rv == 4'h0)
            return 4'h1;
        else return rv;
    endfunction

    enum {LPTR, APTR, SPTR, MPTR, DPTR} rom_ptr;
    always_comb begin : instr_assignment
        case (rom_ptr)
            LPTR: INSTR = linkage_rom[PC];
            APTR: INSTR = add_rom[PC];
            SPTR: INSTR = sub_rom[PC];
            MPTR: INSTR = mul_rom[PC];
            DPTR: INSTR = div_rom[PC];
        endcase
        if (page_change) begin
            INSTR = 8'b1_000_0000; // BRANCH 0
        end
    end

    initial begin : reactive_system
        enum {START, OP1, OP2, OP3, SUM, DIV, MUL, SUB, OTHER1, OTHER2, OTHER3,
            RETW1, RETR1, RETW2, RETR2, RET, INR2, INR3, INR4} state;
        logic [3:0] temp = 4'h0;
        logic is_dividing = 1'b0;
        int ncycles = 250_000;

        IPORT = 4'h0;
        state = START;
        $monitor("state: %s, instr: %2h, olow: %2b, out: %4b, pc: %2x",
                state.name(), INSTR, OPORT[1:0], OPORT, PC);
        restart();

        do begin
            ##1;
            case (state)
                START: begin
                    if (oport_lower == 1)
                        state = OP1;
                    else if (oport_lower == 2)
                        state = OTHER1;
                end
                OP1: begin
                    if (oport_lower == 0)
                        state = OP2;
                    else if (oport_lower == 2)
                        state = OP3;
                end
                OP2: begin
                    if (oport_lower == 1) begin
                        state = SUM;
                        rom_ptr = APTR;
                        page();
                    end else if (oport_lower == 2) begin
                        state = DIV;
                        rom_ptr = DPTR;
                        is_dividing = 1'b1;
                        page();
                    end
                end
                OP3: begin
                    if (oport_lower == 1) begin
                        state = MUL;
                        rom_ptr = MPTR;
                        page();
                    end else if (oport_lower == 0) begin
                        state = SUB;
                        rom_ptr = SPTR;
                        page();
                    end
                end
                SUM: if (oport_lower == 3) state = START;
                DIV: if (oport_lower == 3) state = START;
                MUL: if (oport_lower == 3) state = START;
                SUB: if (oport_lower == 3) state = START;
                OTHER1: begin
                    if (oport_lower == 0)
                        state = OTHER2;
                    else if (oport_lower == 1)
                        state = OTHER3;
                end
                OTHER2: begin
                    if (oport_lower == 2) begin
                        state = RETW1;
                    end else if (oport_lower == 1) begin
                        state = INR2;
                        IPORT = read_input();
                        $display("First operand (R2): %4b", IPORT);
                    end
                end
                OTHER3: begin
                    if (oport_lower == 0) begin
                        state = INR3;
                        IPORT = read_input();
                        $display("Second operand (R3): %4b", IPORT);
                    end else if (oport_lower == 2) begin
                        state = INR4;
                        IPORT = read_input_command();
                        $display("Command: %s",
                            IPORT == 4'b0001 ? "Add" :
                            IPORT == 4'b0010 ? "Sub" :
                            IPORT == 4'b0100 ? "Mul" :
                            IPORT == 4'b1000 ? "Div" : "Error");
                    end
                end
                RETW1: state = RETR1;
                RETR1: begin
                    state = RETW2;
                    temp = OPORT;
                end
                RETW2: state = RETR2;
                RETR2: begin
                    state = RET;
                    if (is_dividing) begin
                        $display(
                            "Result of div: %0d with Rem %d\n",
                            temp, OPORT);
                    end else begin
                        $display(
                            "Result of operation: %2x",
                            {OPORT, temp});
                    end
                    is_dividing = 0;
                    rom_ptr = LPTR;
                    page();
                end
                RET:  if (oport_lower == 3) state = START;
                INR2: if (oport_lower == 3) state = START;
                INR3: if (oport_lower == 3) state = START;
                INR4: if (oport_lower == 3) state = START;
            endcase
        end while (ncycles--);

        $finish;
    end

endmodule
