module one_bit_full_adder(A, B, Cin, S, Cout);

  input A, B, Cin;
  output S, Cout;

  wire x1;
  wire x2;
  wire x3;

  xor (x1, A, B);
  xor (S, x1, Cin);

  and (x2, A, B);
  and (x3, x1, Cin);
  or  (Cout, x2, x3);

endmodule

module four_bit_RCA(A, B, Cin, S, Cout);

  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;

  wire C1, C2, C3;

  one_bit_full_adder FA0(A[0], B[0], Cin, S[0], C1);
  one_bit_full_adder FA1(A[1], B[1], C1, S[1], C2);
  one_bit_full_adder FA2(A[2], B[2], C2, S[2], C3);
  one_bit_full_adder FA3(A[3], B[3], C3, S[3], Cout);

endmodule

module four_bit_PG(A, B, P, G);

  input [3:0] A, B;
  output P, G;

  wire [3:0] p;
  wire [3:0] g;

  wire p01;
  wire p012;

  wire p32;
  wire p321;

  wire t1;
  wire t2;
  wire t3;

  wire o1;
  wire o2;

  // Carry propagation
  xor (p[0], A[0], B[0]);
  xor (p[1], A[1], B[1]);
  xor (p[2], A[2], B[2]);
  xor (p[3], A[3], B[3]);

  // Carry generation
  and (g[0], A[0], B[0]);
  and (g[1], A[1], B[1]);
  and (g[2], A[2], B[2]);
  and (g[3], A[3], B[3]);


  // Block Propagation

  and (p01,  p[0], p[1]);
  and (p012, p01,  p[2]);
  and (P,    p012, p[3]);


  // Block generation

  // p3*g2
  and (t1, p[3], g[2]);

  // p3*p2*g1
  and (p32, p[3], p[2]);
  and (t2, p32, g[1]);

  // p3*p2*p1*g0
  and (p321, p32, p[1]);
  and (t3, p321, g[0]);

  // G = g3 + t1 + t2 + t3
  or (o1, g[3], t1);
  or (o2, o1, t2);
  or (G,  o2, t3);

endmodule


// Combine two propagate/generate groups
module PG_combine(Plow, Glow, Phigh, Ghigh, Pout, Gout);

  input Plow, Glow;
  input Phigh, Ghigh;

  output Pout, Gout;

  wire temp;

  and (Pout, Phigh, Plow);
  and (temp, Phigh, Glow);
  or  (Gout, Ghigh, temp);

endmodule

module CLA(A, B, Cin, S, Cout);

  input [31:0] A, B;
  input Cin;

  output [31:0] S;
  output Cout;


  // ----------------------------------------------------------
  // Propagate and Generate for each 4-bit block
  // ----------------------------------------------------------

  wire [7:0] P;
  wire [7:0] G;

  four_bit_PG PG0(A[3:0],   B[3:0],   P[0], G[0]);
  four_bit_PG PG1(A[7:4],   B[7:4],   P[1], G[1]);
  four_bit_PG PG2(A[11:8],  B[11:8],  P[2], G[2]);
  four_bit_PG PG3(A[15:12], B[15:12], P[3], G[3]);
  four_bit_PG PG4(A[19:16], B[19:16], P[4], G[4]);
  four_bit_PG PG5(A[23:20], B[23:20], P[5], G[5]);
  four_bit_PG PG6(A[27:24], B[27:24], P[6], G[6]);
  four_bit_PG PG7(A[31:28], B[31:28], P[7], G[7]);


  // ----------------------------------------------------------
  // Create combined P/G values for progressively larger
  // groups of 4-bit blocks.
  //
  // PG01     represents bits 7:0
  // PG012    represents bits 11:0
  // PG0123   represents bits 15:0
  // etc.
  // ----------------------------------------------------------

  wire P01, G01;
  wire P012, G012;
  wire P0123, G0123;
  wire P01234, G01234;
  wire P012345, G012345;
  wire P0123456, G0123456;
  wire P01234567, G01234567;


  PG_combine COMB01(
    P[0], G[0],
    P[1], G[1],
    P01, G01
  );

  PG_combine COMB012(
    P01, G01,
    P[2], G[2],
    P012, G012
  );

  PG_combine COMB0123(
    P012, G012,
    P[3], G[3],
    P0123, G0123
  );

  PG_combine COMB01234(
    P0123, G0123,
    P[4], G[4],
    P01234, G01234
  );

  PG_combine COMB012345(
    P01234, G01234,
    P[5], G[5],
    P012345, G012345
  );

  PG_combine COMB0123456(
    P012345, G012345,
    P[6], G[6],
    P0123456, G0123456
  );

  PG_combine COMB01234567(
    P0123456, G0123456,
    P[7], G[7],
    P01234567, G01234567
  );

  // ^ this gives us the final combined P and G
  
  // ----------------------------------------------------------
  // Carry Lookahead Logic
  //
  // From lecture:
  //
  // C4  = G0       + P0*Cin
  // C8  = G01      + P01*Cin
  // C12 = G012     + P012*Cin
  // ...
  // ----------------------------------------------------------

  wire C4;
  wire C8;
  wire C12;
  wire C16;
  wire C20;
  wire C24;
  wire C28;

  wire ct4;
  wire ct8;
  wire ct12;
  wire ct16;
  wire ct20;
  wire ct24;
  wire ct28;
  wire ct32;


  // Carry into bits 7:4
  and (ct4, P[0], Cin);
  or  (C4, G[0], ct4);


  // Carry into bits 11:8
  and (ct8, P01, Cin);
  or  (C8, G01, ct8);


  // Carry into bits 15:12
  and (ct12, P012, Cin);
  or  (C12, G012, ct12);


  // Carry into bits 19:16
  and (ct16, P0123, Cin);
  or  (C16, G0123, ct16);


  // Carry into bits 23:20
  and (ct20, P01234, Cin);
  or  (C20, G01234, ct20);


  // Carry into bits 27:24
  and (ct24, P012345, Cin);
  or  (C24, G012345, ct24);


  // Carry into bits 31:28
  and (ct28, P0123456, Cin);
  or  (C28, G0123456, ct28);


  // Final 32-bit carry out
  and (ct32, P01234567, Cin);
  or  (Cout, G01234567, ct32);


  // ----------------------------------------------------------
  // Eight 4-bit RCA blocks
  //
  // The carry OUT of each RCA is intentionally not connected
  // to the next RCA. The CLA circuitry above calculates the
  // carry inputs independently.
  // ----------------------------------------------------------

  // nc ~ not connected
  wire nc0;
  wire nc1;
  wire nc2;
  wire nc3;
  wire nc4;
  wire nc5;
  wire nc6;
  wire nc7;


  four_bit_RCA four_bit_block_one(
    A[3:0],
    B[3:0],
    Cin,
    S[3:0],
    nc0
  );


  four_bit_RCA four_bit_block_two(
    A[7:4],
    B[7:4],
    C4,
    S[7:4],
    nc1
  );


  four_bit_RCA four_bit_block_three(
    A[11:8],
    B[11:8],
    C8,
    S[11:8],
    nc2
  );


  four_bit_RCA four_bit_block_four(
    A[15:12],
    B[15:12],
    C12,
    S[15:12],
    nc3
  );


  four_bit_RCA four_bit_block_five(
    A[19:16],
    B[19:16],
    C16,
    S[19:16],
    nc4
  );


  four_bit_RCA four_bit_block_six(
    A[23:20],
    B[23:20],
    C20,
    S[23:20],
    nc5
  );


  four_bit_RCA four_bit_block_seven(
    A[27:24],
    B[27:24],
    C24,
    S[27:24],
    nc6
  );


  four_bit_RCA four_bit_block_eight(
    A[31:28],
    B[31:28],
    C28,
    S[31:28],
    nc7
  );

endmodule
