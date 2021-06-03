`include "params.v"
`include "datapath.v"
`include "decoder.v"
module core
(
    CLK,
    RSTN,
    IPORT,
    OPORT,
    // TO/FROM PROM
    PC,
    INSTR
);

    input                       CLK;
    input                       RSTN;
    input  [`DATA_LEN-1:0]      IPORT;
    output [`DATA_LEN-1:0]      OPORT;
    output [`PC_LEN-1:0]        PC;
    input  [`INSTR_LEN-1:0]     INSTR;

    wire [`ALU_OP_LEN-1:0]      alu_op;
    wire [`DATA_LEN-1:0]        instr_imm;
    wire                        imm_sel;
    wire [`PC_LEN-1:0]          br_target;
    wire                        is_br;
    wire                        is_ld;
    wire                        is_st;
    wire [2:0]                  reg_id;

    datapath dpath(
        .CLK       ( CLK       ),
        .RSTN      ( RSTN      ),
        .PC        ( PC        ),
        .IPORT     ( IPORT     ),
        .OPORT     ( OPORT     ),
        // FROM CTL
        .ALU_OP    ( alu_op    ),
        .INSTR_IMM ( instr_imm ),
        .IMM_SEL   ( imm_sel   ),
        .BR_TARGET ( br_target ),
        .IS_BR     ( is_br     ),
        .IS_LD     ( is_ld     ),
        .IS_ST     ( is_st     ),
        .REG_ID    ( reg_id    )
    );

    decoder decode(
        .INSTR     ( INSTR     ),
        .ALU_OP    ( alu_op    ),
        .INSTR_IMM ( instr_imm ),
        .IMM_SEL   ( imm_sel   ),
        .BR_TARGET ( br_target ),
        .IS_BR     ( is_br     ),
        .IS_LD     ( is_ld     ),
        .IS_ST     ( is_st     ),
        .REG_ID    ( reg_id    )
    );
endmodule
