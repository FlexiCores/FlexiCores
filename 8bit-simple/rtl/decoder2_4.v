module decoder2_4
(
    ENC,
    DEC
);
    input [1:0] ENC;
    output [3:0] DEC;

    assign DEC[0] = &{~ENC[1], ~ENC[0]};
    assign DEC[1] = &{~ENC[1],  ENC[0]};
    assign DEC[2] = &{ ENC[1], ~ENC[0]};
    assign DEC[3] = &{ ENC[1],  ENC[0]};

endmodule
