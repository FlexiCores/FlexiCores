
`celldefine
module BUF4 (A, X);
input  A ;
output X ;

buf U1(X, A);

endmodule
`endcelldefine


`celldefine
module BUF (A, X);
input  A ;
output X ;

buf U1(X, A);

endmodule
`endcelldefine


`celldefine
module DFFC (CLK, D, CL, Q, Qb);
input  CLK ;
input  D ;
input  CL ;
output Q ;
output Qb;

reg Q, Qb;

always @(posedge CLK or posedge CL) begin
	if (CL) begin
		Q  <= 1'b0;
		Qb <= 1'b1;
	end
	else begin
		Q  <= D;
		Qb <= ~D;
	end
end

endmodule
`endcelldefine


`celldefine
module DFFP (CLK, D, PR, Q, Qb);
input  CLK ;
input  D ;
input  PR ;
output Q ;
output Qb;

reg Q, Qb;

always @(posedge CLK or posedge PR) begin
	if (PR) begin
		Q  <= 1'b1;
		Qb <= 1'b0;
	end
	else begin
		Q  <= D;
		Qb <= ~D;
	end
end

endmodule
`endcelldefine


`celldefine
module DFFQ (CLK, D, Q, Qb);
input  CLK ;
input  D ;
output Q ;
output Qb;

reg Q, Qb;

initial begin
	Q  <= 0;
	Qb <= 0;
end

always @(posedge CLK) begin
	Q  <= D;
	Qb <= ~D;
end

endmodule
`endcelldefine


`celldefine
module INV1 (A, X);
input  A ;
output X ;

not U1(X, A);

endmodule
`endcelldefine



`celldefine
module INV4 (A, X);
input  A ;
output X ;

not U1(X, A);

endmodule
`endcelldefine



`celldefine
module MX2 (A, B, S, X);
input  A ;
input  B ;
input  S ;
output X ;

wire n1, q1, q2;

not i1 (n1, S);
and a1 (q1, A,  n1 );
and a2 (q2, B,  S  );

or o1 (X, q1, q2 );

endmodule
`endcelldefine









`celldefine
module NAND2 (A1, A2, X);
input  A1 ;
input  A2 ;
output X ;

and U1 (I0_out, A1, A2);
not U2 (X, I0_out);

endmodule
`endcelldefine




`celldefine
module NOR2 (A1, A2, X);
input  A1 ;
input  A2 ;
output X  ;

or U1 (I0_out, A1, A2);
not U2 (X, I0_out);

endmodule
`endcelldefine




`celldefine
module NOR3 (A1, A2, A3, X);
input  A1 ;
input  A2 ;
input  A3 ;
output X  ;

or U1 (I0_out, A1, A2, A3);
not U2 (X, I0_out);

endmodule
`endcelldefine



`celldefine
module NOR4 (A1, A2, A3, A4, X);
input  A1 ;
input  A2 ;
input  A3 ;
input  A4 ;
output X  ;

or U1 (I0_out, A1, A2, A3, A4);
not U2 (X, I0_out);

endmodule
`endcelldefine




`celldefine
module TIEHI (X);
output X ;

assign X = 1'b1;

endmodule
`endcelldefine


`celldefine
module TIELO (X);
output X ;

assign X = 1'b0;

endmodule
`endcelldefine


`celldefine
module XNOR (A1, A2, X);
input  A1 ;
input  A2 ;
output X ;

xnor U1(X, A1, A2);

endmodule
`endcelldefine





`celldefine
module XOR (A1, A2, X);
input  A1 ;
input  A2 ;
output X ;

xor U1(X, A1, A2);

endmodule
`endcelldefine



