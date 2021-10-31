module regfile(
    CLK,
    RSTN,
    ADDR,
    RDATA,
    RF0DATA,
    RF1DATA,
    WDATA,
    WEN
);

    parameter WIDTH=4;

    input                   CLK, WEN, RSTN;
    input  [2:0]            ADDR;
    input  [WIDTH-1:0]      WDATA;
    output [WIDTH-1:0]      RF0DATA;
    input  [WIDTH-1:0]      RF1DATA;
    output reg [WIDTH-1:0]  RDATA;

    reg [WIDTH-1:0] rf0, rf2, rf3, rf4, rf5, rf6, rf7;
    wire [WIDTH-1:0] rf1;
    assign rf1 = RF1DATA;
    assign RF0DATA = rf0;

    wire [7:0] _1hot;

    decoder3_8 addr_decoder(
        .ENC(ADDR),
        .DEC(_1hot)
    );


    always @(*) begin
        case (_1hot)
            8'h01: RDATA = rf0;
            8'h02: RDATA = rf1;
            8'h04: RDATA = rf2;
            8'h08: RDATA = rf3;
            8'h10: RDATA = rf4;
            8'h20: RDATA = rf5;
            8'h40: RDATA = rf6;
            8'h80: RDATA = rf7;
            default: RDATA = 4'hx;
        endcase
    end

    always @(posedge CLK) begin
        if (!RSTN) begin
            rf0 <= 4'h0;
            rf2 <= 4'h0;
            rf3 <= 4'h0;
            rf4 <= 4'h0;
            rf5 <= 4'h0;
            rf6 <= 4'h0;
            rf7 <= 4'h0;
        end
        else if (WEN) begin
            if (_1hot[0]) rf0 <= WDATA;
            if (_1hot[2]) rf2 <= WDATA;
            if (_1hot[3]) rf3 <= WDATA;
            if (_1hot[4]) rf4 <= WDATA;
            if (_1hot[5]) rf5 <= WDATA;
            if (_1hot[6]) rf6 <= WDATA;
            if (_1hot[7]) rf7 <= WDATA;
        end
    end

endmodule
