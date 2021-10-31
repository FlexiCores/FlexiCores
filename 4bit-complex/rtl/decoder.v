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
    IS_BRANCH,                  // The current cycle is a branch instruction
                                // (First byte)
    IS_BRN,
    IS_BRZ,
    IS_BRP,
    IS_LD,
    IS_ST,
    REG_ID
);
    input                       CLK, RSTN;
    input  [`INSTR_LEN-1:0]     INSTR;
    output [`ALU_OP_LEN-1:0]    ALU_OP;
    output [`DATA_LEN-1:0]      INSTR_IMM;
    output                      IMM_SEL;
    output [`PC_LEN-1:0]        BR_TARGET;
    output                      IS_BRANCH;
    output reg                  IS_BRN;
    output reg                  IS_BRZ;
    output reg                  IS_BRP;
    output                      IS_LD;
    output                      IS_ST;
    output [2:0]                REG_ID;

    wire is_ld_st;
    wire was_branch;

    // If immediate, then LSB of ALU_OP is 0, otherwise, its INSTR[3]
    assign ALU_OP = {INSTR[5:4], IMM_SEL ? 1'b0 : INSTR[3]};
    assign INSTR_IMM = INSTR[3:0];
    assign IMM_SEL = INSTR[6];
    assign IS_BRANCH = INSTR[6:4] == 3'b011;
    assign BR_TARGET = INSTR[6:0];
    assign is_ld_st = INSTR[6:4] == 3'b111;
    assign was_branch = |{IS_BRN, IS_BRZ, IS_BRP};
    assign IS_LD = is_ld_st & ~INSTR[3];
    assign IS_ST = is_ld_st & INSTR[3];
    assign REG_ID = INSTR[2:0];

    always @(posedge CLK) begin
        if (!RSTN) begin
            IS_BRN <= 1'b0;
            IS_BRZ <= 1'b0;
            IS_BRP <= 1'b0;
        end
        else begin
            if (was_branch) begin
                IS_BRN <= 1'b0;
                IS_BRZ <= 1'b0;
                IS_BRP <= 1'b0;
            end
            else begin
                IS_BRN <= IS_BRANCH & INSTR[3];
                IS_BRZ <= IS_BRANCH & INSTR[2];
                IS_BRP <= IS_BRANCH & INSTR[1];
            end
        end
    end

endmodule
