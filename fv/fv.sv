`include "params.v"
module fv(
    input                           CLK,
    input                           RSTN,
    input       [`DATA_LEN-1:0]     IPORT,
    input       [`INSTR_LEN-1:0]    INSTR,
    output reg  [`DATA_LEN-1:0]     OPORT,
    output reg  [`PC_LEN-1:0]       PC
);
default clocking @(posedge CLK);
endclocking
default disable iff (!RSTN);

property ADD (i);
    i[7:3] == 5'b00000;
endproperty

property ADDI (i);
    i[7:4] == 4'b0100;
endproperty

property NAND (i);
    i[7:3] == 5'b00010;
endproperty

property NANDI (i);
    i[7:4] == 4'b0101;
endproperty

property XOR (i);
    i[7:3] == 5'b00100;
endproperty

property XORI (i);
    i[7:4] == 4'b0110;
endproperty

property LOAD (i);
    i[7:3] == 5'b01110;
endproperty

property STORE (i);
    i[7:3] == 5'b01111;
endproperty

property BRANCH (i);
    i[7] == 1'b1;
endproperty

instr_driven: assume property (
    ADD(INSTR) or ADDI(INSTR) or NAND(INSTR) or NANDI(INSTR) or
    XOR(INSTR) or XORI(INSTR) or LOAD(INSTR) or STORE(INSTR) or BRANCH(INSTR)
);

core dut (.*);

logic [3:0] rf [8];
assign rf[0] = dut.dpath.rf.rf0;
assign rf[1] = dut.dpath.rf.rf1;
assign rf[2] = dut.dpath.rf.rf2;
assign rf[3] = dut.dpath.rf.rf3;
assign rf[4] = dut.dpath.rf.rf4;
assign rf[5] = dut.dpath.rf.rf5;
assign rf[6] = dut.dpath.rf.rf6;
assign rf[7] = dut.dpath.rf.rf7;

property ADD_CORRECT;
    nexttime (
        (INSTR[7:3] == 5'b00000) |=> dut.dpath.A ==
                                     $past(dut.dpath.A + rf[INSTR[2:0]])
    );
endproperty

property ADDI_CORRECT;
    nexttime (
        (INSTR[7:4] == 4'b0100) |=> dut.dpath.A  == $past(dut.dpath.A + INSTR[3:0])
    );
endproperty

add_correct: assert property ( ADD_CORRECT );
addi_correct: assert property ( ADDI_CORRECT );

property NAND_CORRECT;
    nexttime (
        (INSTR[7:3] == 5'b00010) |=> dut.dpath.A == $past(~(dut.dpath.A & rf[INSTR[2:0]]))
    );
endproperty

property NANDI_CORRECT;
    nexttime (
        (INSTR[7:4] == 4'b0101) |=> dut.dpath.A == $past(~(dut.dpath.A & INSTR[3:0]))
    );
endproperty

nand_correct: assert property ( NAND_CORRECT );
nandi_correct: assert property ( NANDI_CORRECT );

property XOR_CORRECT;
    nexttime (
        (INSTR[7:3] == 5'b00100) |=> dut.dpath.A == $past((dut.dpath.A ^ rf[INSTR[2:0]]))
    );
endproperty

property XORI_CORRECT;
    nexttime (
        (INSTR[7:4] == 4'b0110) |=> dut.dpath.A == $past((dut.dpath.A ^ INSTR[3:0]))
    );
endproperty

xor_correct: assert property  ( XOR_CORRECT );
xori_correct: assert property ( XORI_CORRECT );

property LOAD_CORRECT;
    nexttime (
        (INSTR[7:3] == 5'b01110) |=> dut.dpath.A == $past(rf[INSTR[2:0]])
    );
endproperty

property STORE_CORRECT;
    nexttime (
        ((INSTR[7:3] == 5'b01111) && (INSTR[2:0] >= 2)) |=>
            $past(dut.dpath.A) == rf[$past(INSTR[2:0])]
    );
endproperty

load_correct: assert property ( LOAD_CORRECT );
store_correct: assert property ( STORE_CORRECT );


property BRANCH_CORRECT;
    nexttime (
        (INSTR[7] == 1'b1) |=> 
            (PC == ($past(dut.dpath.A[3]) ? $past(INSTR[6:0]) :
                                            $past((PC + 1)%128 )))
    );
endproperty

property PC_NO_BRANCH;
    nexttime (
        (INSTR[7] == 1'b0) |=> PC == $past((PC + 1) % 128)
    );
endproperty

nobranch_correct: assert property ( PC_NO_BRANCH );
branch_correct: assert property ( BRANCH_CORRECT );


endmodule
