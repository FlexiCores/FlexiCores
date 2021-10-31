module regfile
#(
    parameter WIDTH=8
)
(
    CLK,
    RSTN,
    ADDR,
    RDATA,
    RF0DATA,
    RF1DATA,
    WDATA,
    WEN
);


    input                   CLK, WEN, RSTN;
    input  [1:0]            ADDR;
    input  [WIDTH-1:0]      WDATA;
    output [WIDTH-1:0]      RF0DATA;
    input  [WIDTH-1:0]      RF1DATA;
    output reg [WIDTH-1:0]  RDATA;

    reg [WIDTH-1:0] rf0, rf2, rf3, rf4, rf5, rf6, rf7;
    wire [WIDTH-1:0] rf1;
    assign rf1 = RF1DATA;
    assign RF0DATA = rf0;

    wire [3:0] _1hot;

    decoder2_4 addr_decoder(
        .ENC(ADDR),
        .DEC(_1hot)
    );


    always @(*) begin
        case (_1hot)
            8'h01: RDATA = rf0;
            8'h02: RDATA = rf1;
            8'h04: RDATA = rf2;
            8'h08: RDATA = rf3;
            default: RDATA = 4'hx;
        endcase
    end

    always @(posedge CLK) begin
        if (!RSTN) begin
            rf0 <= 8'h00;
            rf2 <= 8'h00;
            rf3 <= 8'h00;
        end
        else if (WEN) begin
            if (_1hot[0]) rf0 <= WDATA;
            if (_1hot[2]) rf2 <= WDATA;
            if (_1hot[3]) rf3 <= WDATA;
        end
    end

endmodule
