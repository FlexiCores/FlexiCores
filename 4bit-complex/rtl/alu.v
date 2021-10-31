`include "params.v"
module alu
#(
    parameter WIDTH=4
)
(
    A,
    B,
    OP,
    Y
);

    input [WIDTH-1:0] A, B;
    input [`ALU_OP_LEN-1:0] OP;
    output [WIDTH-1:0] Y;

    // parameter SUB=2'b11;
    wire [WIDTH-1:0] abnand, abxor, binv, badd, sum, asr1, asr2, asr;
    assign abnand = ~(A & badd);
    assign abxor  = A ^ badd;
    assign binv   = ~B;
    wire [WIDTH-1:0] cins;
    assign cins[0] = OP[0];
    assign badd = OP == 3'b001 ? binv : B;
    assign sum = abxor ^ cins;

    // SRA: 3'b101, SRL: 3'b011
    wire msb_mask;
    assign msb_mask = A[3] & OP[2];
    assign asr2 = B[1] ? {msb_mask, msb_mask, A[3:2]} : A;
    assign asr1 = B[0] ? {msb_mask, asr2[3:1]} : asr2;
    assign asr = asr1;
    
    genvar gi;
    generate
        for (gi = 1; gi < WIDTH; gi = gi + 1) begin : ripple_carry
            // COUT = AB + CIN(A ^ B)
            assign cins[gi] = (~abnand[gi-1]) | (cins[gi-1] & abxor[gi-1]);
            // S = A ^ B ^ CIN
        end
    endgenerate

    assign Y = (OP == `NAND) ? abnand :
               (OP == `XOR) ?  abxor  :
               (OP == `SRL) ?  asr    :
               (OP == `SRA) ?  asr    : sum;

endmodule
