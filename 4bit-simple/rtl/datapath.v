`ifndef DATAPATH_V
`define DATAPATH_V
`include "params.v"
`include "pc.v"
`include "regfile.v"
`include "alu.v"

module datapath
(
    CLK,
    RSTN,
    PC,
    IPORT,
    OPORT,
    // FROM CTL
    ALU_OP,
    INSTR_IMM,
    IMM_SEL,
    BR_TARGET,
    IS_BR,
    IS_LD,
    IS_ST,
    REG_ID
);
    input                           CLK;
    input                           RSTN;
    output     [`PC_LEN-1:0]        PC;
    input      [`DATA_LEN-1:0]      IPORT;
    output     [`DATA_LEN-1:0]      OPORT;
    // FROM CTL
    input      [`ALU_OP_LEN-1:0]    ALU_OP;
    input      [`DATA_LEN-1:0]      INSTR_IMM;
    input                           IMM_SEL;
    input      [`PC_LEN-1:0]        BR_TARGET;
    input                           IS_BR;
    input                           IS_LD;
    input                           IS_ST;
    input      [2:0]                REG_ID;

    reg [`DATA_LEN-1:0] A;  // Accumulator
    wire [`DATA_LEN-1:0] alu_op_a, alu_op_b, rf_rdata, alu_result;
    wire br_en;
    wire load_A;
    wire [`DATA_LEN-1:0] data_A;
    assign load_A = ~|{IS_BR, IS_ST};
    assign data_A = IS_LD ? rf_rdata : alu_result;

    assign br_en = IS_BR & A[`DATA_LEN-1];
    pc #(`PC_LEN) _PC
    (
        .CLK    ( CLK       ),
        .RSTN   ( RSTN      ),
        .PC     ( PC        ),
        .EN     ( 1'b1      ),
        .INC    ( ~br_en    ),
        .TARGET ( BR_TARGET )
    );

    assign alu_op_a = A;
    assign alu_op_b = IMM_SEL ? INSTR_IMM : rf_rdata;
    alu #(`DATA_LEN) _alu
    (
        .A  ( alu_op_a   ),
        .B  ( alu_op_b   ),
        .OP ( ALU_OP     ),
        .Y  ( alu_result )
    );

    regfile rf
    (
        .CLK     ( CLK       ),
        .RSTN    ( RSTN      ),
        .ADDR    ( REG_ID    ),
        .RDATA   ( rf_rdata  ),
        .RF0DATA ( OPORT     ),
        .RF1DATA ( IPORT     ),
        .WDATA   ( A         ),
        .WEN     ( IS_ST     )
    );

    always @(posedge CLK) begin
        if (!RSTN) begin
            A <= 4'h0;
        end
        else if (load_A) begin
            A <= data_A;
        end
    end

endmodule
`endif
