module testbench;
    logic CLK, RSTN;
    logic [3:0] IPORT, OPORT;
    logic [6:0] PC;
    logic [7:0] INSTR;

    always #5 CLK =  CLK === 1'b0;
    default clocking cb @(posedge CLK); endclocking
    default disable iff (!RSTN);

    logic [7:0] mem [128];

    initial begin : load_memory
        //$readmemh("lightup.lst", mem);
        //$readmemh("loadin.lst", mem);
        $readmemh("count.lst", mem);
        $monitor(IPORT, OPORT);
    end

    assign INSTR = mem[PC];

    initial forever begin
        @(cb iff $changed(OPORT)) IPORT = OPORT + 1;
    end

    initial begin : run_program
        $dumpfile("count.vcd");
        $dumpvars(1, testbench);
        IPORT = 8'h00;
        RSTN = 1'b0;
        ##10;
        RSTN = 1'b1;
        ##10000;
        $finish;
    end

    core dut(
        .CLK,
        .RSTN,
        .IPORT,
        .OPORT,
        .PC,
        .INSTR
    );

endmodule
