`include "params.v"
module alu
#(
    parameter WIDTH=8
)
(
    A,
    B,
    OP,
    Y
);

    input [WIDTH-1:0] A, B;
    input [1:0] OP;
    output [WIDTH-1:0] Y;

    // parameter SUB=2'b11;
    wire [WIDTH-1:0] abnand, abxor, binv, badd, sum;
    assign abnand = ~(A & B);
    assign abxor  = A ^ B;
    assign binv   = ~B;
    wire [WIDTH-1:0] cins;
    assign cins[0] = 1'b0;
    assign badd = OP[0] ? binv : B;
    assign sum = abxor ^ cins;
    
    genvar gi;
    generate
        for (gi = 1; gi < WIDTH; gi = gi + 1) begin : ripple_carry
            // COUT = AB + CIN(A ^ B)
            assign cins[gi] = (~abnand[gi-1]) | (cins[gi-1] & abxor[gi-1]);
            // S = A ^ B ^ CIN
        end
    endgenerate

    assign Y = (OP == `NAND) ? abnand : (OP == `XOR) ? abxor : sum;

endmodule
