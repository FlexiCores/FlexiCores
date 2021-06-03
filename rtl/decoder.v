`ifndef DECODER_V
`define DECODER_V
`include "params.v"
`include "decoder3_8.v"
module decoder
(
    INSTR,
    ALU_OP,
    INSTR_IMM,
    IMM_SEL,
    BR_TARGET,
    IS_BR,
    IS_LD,
    IS_ST,
    REG_ID
);
    input  [`INSTR_LEN-1:0]     INSTR;
    output [`ALU_OP_LEN-1:0]    ALU_OP;
    output [`DATA_LEN-1:0]      INSTR_IMM;
    output                      IMM_SEL;
    output [`PC_LEN-1:0]        BR_TARGET;
    output                      IS_BR;
    output                      IS_LD;
    output                      IS_ST;
    output [2:0]                REG_ID;

    wire is_ld_st;
    assign ALU_OP = INSTR[5:4];
    assign INSTR_IMM = INSTR[3:0];
    assign IMM_SEL = INSTR[6];
    assign IS_BR = INSTR[7];
    assign BR_TARGET = INSTR[6:0];
    assign is_ld_st = INSTR[6:4] == 3'b111;
    assign IS_LD = is_ld_st & ~INSTR[3];
    assign IS_ST = is_ld_st & INSTR[3];
    assign REG_ID = INSTR[2:0];

endmodule
`endif
