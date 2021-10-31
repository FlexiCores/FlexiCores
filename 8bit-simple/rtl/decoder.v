`include "params.v"
module decoder
(
    CLK,
    RSTN,
    INSTR,
    ALU_OP,
    INSTR_IMM,
    IMM_SEL,
    BR_TARGET,
    IS_BR,
    IS_LD,
    LD_SEL,
    LB_IMM,
    IS_ST,
    REG_ID
);
    input                       CLK;
    input                       RSTN;
    input  [`INSTR_LEN-1:0]     INSTR;
    output [`ALU_OP_LEN-1:0]    ALU_OP;
    output [`DATA_LEN-1:0]      INSTR_IMM;
    output                      IMM_SEL;
    output [`PC_LEN-1:0]        BR_TARGET;
    output                      IS_BR;
    output                      IS_LD;
    output [`DATA_LEN-1:0]      LB_IMM;
    output                      LD_SEL;
    output                      IS_ST;
    output [1:0]                REG_ID;

    wire is_ld_st;
    reg is_lb;

    assign ALU_OP = INSTR[5:4];
    assign INSTR_IMM = {{4{INSTR[3]}}, INSTR[3:0]};
    assign IMM_SEL = INSTR[6];
    assign IS_BR = INSTR[7] & (~is_lb);
    assign BR_TARGET = INSTR[6:0];
    assign is_ld_st = INSTR[6:4] == 3'b111;
    assign IS_LD = is_ld_st & ~INSTR[3] | is_lb;
    assign IS_ST = is_ld_st & INSTR[3] & (~is_lb);
    assign REG_ID = INSTR[1:0];
    assign LD_SEL = is_lb;
    assign LB_IMM = INSTR[7:0];

    always @(posedge CLK or negedge RSTN) begin
        if (!RSTN) begin
            is_lb <= 1'b0;
        end
        else begin
            if (is_lb) begin
                is_lb <= 1'b0;
            end
            else begin
                is_lb <= INSTR[7:3] == `LB5;
            end
        end
    end

endmodule
