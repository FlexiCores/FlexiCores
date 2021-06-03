module decoder3_8
(
    ENC,
    DEC
);
    input [2:0] ENC;
    output [7:0] DEC;

    assign DEC[0] = &{~ENC[2], ~ENC[1], ~ENC[0]};
    assign DEC[1] = &{~ENC[2], ~ENC[1],  ENC[0]};
    assign DEC[2] = &{~ENC[2],  ENC[1], ~ENC[0]};
    assign DEC[3] = &{~ENC[2],  ENC[1],  ENC[0]};
    assign DEC[4] = &{ ENC[2], ~ENC[1], ~ENC[0]};
    assign DEC[5] = &{ ENC[2], ~ENC[1],  ENC[0]};
    assign DEC[6] = &{ ENC[2],  ENC[1], ~ENC[0]};
    assign DEC[7] = &{ ENC[2],  ENC[1],  ENC[0]};

endmodule
