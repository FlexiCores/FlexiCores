module pc#(
    parameter WIDTH=6
)
(
    CLK,
    RSTN,
    PC,
    EN,
    INC,
    TARGET
);

input CLK, RSTN, EN, INC;
input [WIDTH-1:0] TARGET;
output reg [WIDTH-1:0] PC;

wire [7:0] pc_plus_1, pc_next;
assign pc_plus_1 = PC+1;
assign pc_next = INC ? pc_plus_1 : TARGET;

always @(posedge CLK or negedge RSTN) begin
    if (!RSTN) begin
        PC <= 0;
    end
    else if (EN) begin
        PC <= pc_next;
    end
end

endmodule
