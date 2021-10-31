`include "params.v"
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
    input [`DATA_LEN-2:0]       IPORT;
    output [`DATA_LEN-2:0]      OPORT;
    output reg [`PC_LEN-1:0]    PC;
    input [`INSTR_LEN-1:0]      INSTR;

    wire [`ALU_OP_LEN-1:0]      alu_op;
    wire [`DATA_LEN-1:0]        instr_imm;
    wire                        imm_sel;
    wire [`PC_LEN-1:0]          br_target;
    wire                        is_br;
    wire                        is_ld;
    wire [`DATA_LEN-1:0]        lb_imm;
    wire                        ld_sel;
    wire                        is_st;
    wire [1:0]                  reg_id;
    wire [`DATA_LEN-1:0]        sextiport;
    assign sextiport = {IPORT[`DATA_LEN-2], IPORT};
    wire od;

    datapath dpath(
        .CLK       ( CLK         ),
        .RSTN      ( RSTN        ),
        .PC        ( PC          ),
        .IPORT     ( sextiport   ),
        .OPORT     ( {od, OPORT} ),
        // FROM CTL
        .ALU_OP    ( alu_op      ),
        .INSTR_IMM ( instr_imm   ),
        .IMM_SEL   ( imm_sel     ),
        .BR_TARGET ( br_target   ),
        .IS_BR     ( is_br       ),
        .IS_LD     ( is_ld       ),
        .LB_IMM    ( lb_imm      ),
        .LD_SEL    ( ld_sel      ),
        .IS_ST     ( is_st       ),
        .REG_ID    ( reg_id      )
    );

    decoder decode(
        .CLK       ( CLK       ),
        .RSTN      ( RSTN      ),
        .INSTR     ( INSTR     ),
        .ALU_OP    ( alu_op    ),
        .INSTR_IMM ( instr_imm ),
        .IMM_SEL   ( imm_sel   ),
        .BR_TARGET ( br_target ),
        .IS_BR     ( is_br     ),
        .IS_LD     ( is_ld     ),
        .LB_IMM    ( lb_imm    ),
        .LD_SEL    ( ld_sel    ),
        .IS_ST     ( is_st     ),
        .REG_ID    ( reg_id    )
    );

endmodule
