`timescale 1ns/1ps

module KS_bit(A, B, P, G);
  input A, B;
  output P, G;

  xor (P, A, B);
  and (G, A, B);
endmodule

module KS_combine(Plow, Glow, Phigh, Ghigh, Pout, Gout);
  input Plow, Glow, Phigh, Ghigh;
  output Pout, Gout;
  wire temp;

  and (Pout, Phigh, Plow);
  and (temp, Phigh, Glow);
  or  (Gout, Ghigh, temp);
endmodule

module KS_output(Pbit, Cprev, Pgroup, Ggroup, Cin, S, Cnext);
  input Pbit, Cprev, Pgroup, Ggroup, Cin;
  output S, Cnext;
  wire temp;

  and (temp, Pgroup, Cin);
  or  (Cnext, Ggroup, temp);
  xor (S, Pbit, Cprev);
endmodule

module KS(A, B, Cin, S, Cout);
  input [15:0] A, B;
  input Cin;
  output [15:0] S;
  output Cout;

  wire [15:0] P0, G0;
  wire [15:0] P1, G1;
  wire [15:0] P2, G2;
  wire [15:0] P3, G3;
  wire [15:0] P4, G4;
  wire [16:0] C;

  KS_bit bit0 (A[0],  B[0],  P0[0],  G0[0]);
  KS_bit bit1 (A[1],  B[1],  P0[1],  G0[1]);
  KS_bit bit2 (A[2],  B[2],  P0[2],  G0[2]);
  KS_bit bit3 (A[3],  B[3],  P0[3],  G0[3]);
  KS_bit bit4 (A[4],  B[4],  P0[4],  G0[4]);
  KS_bit bit5 (A[5],  B[5],  P0[5],  G0[5]);
  KS_bit bit6 (A[6],  B[6],  P0[6],  G0[6]);
  KS_bit bit7 (A[7],  B[7],  P0[7],  G0[7]);
  KS_bit bit8 (A[8],  B[8],  P0[8],  G0[8]);
  KS_bit bit9 (A[9],  B[9],  P0[9],  G0[9]);
  KS_bit bit10(A[10], B[10], P0[10], G0[10]);
  KS_bit bit11(A[11], B[11], P0[11], G0[11]);
  KS_bit bit12(A[12], B[12], P0[12], G0[12]);
  KS_bit bit13(A[13], B[13], P0[13], G0[13]);
  KS_bit bit14(A[14], B[14], P0[14], G0[14]);
  KS_bit bit15(A[15], B[15], P0[15], G0[15]);

  // 1
  assign P1[0] = P0[0];
  assign G1[0] = G0[0];

  KS_combine s1_1 (P0[0], G0[0], P0[1], G0[1], P1[1], G1[1]);
  KS_combine s1_2 (P0[1], G0[1], P0[2], G0[2], P1[2], G1[2]);
  KS_combine s1_3 (P0[2], G0[2], P0[3], G0[3], P1[3], G1[3]);
  KS_combine s1_4 (P0[3], G0[3], P0[4], G0[4], P1[4], G1[4]);
  KS_combine s1_5 (P0[4], G0[4], P0[5], G0[5], P1[5], G1[5]);
  KS_combine s1_6 (P0[5], G0[5], P0[6], G0[6], P1[6], G1[6]);
  KS_combine s1_7 (P0[6], G0[6], P0[7], G0[7], P1[7], G1[7]);
  KS_combine s1_8 (P0[7], G0[7], P0[8], G0[8], P1[8], G1[8]);
  KS_combine s1_9 (P0[8], G0[8], P0[9], G0[9], P1[9], G1[9]);
  KS_combine s1_10(P0[9], G0[9], P0[10], G0[10], P1[10], G1[10]);
  KS_combine s1_11(P0[10], G0[10], P0[11], G0[11], P1[11], G1[11]);
  KS_combine s1_12(P0[11], G0[11], P0[12], G0[12], P1[12], G1[12]);
  KS_combine s1_13(P0[12], G0[12], P0[13], G0[13], P1[13], G1[13]);
  KS_combine s1_14(P0[13], G0[13], P0[14], G0[14], P1[14], G1[14]);
  KS_combine s1_15(P0[14], G0[14], P0[15], G0[15], P1[15], G1[15]);

  // 2
  assign P2[1:0] = P1[1:0];
  assign G2[1:0] = G1[1:0];

  KS_combine s2_2 (P1[0], G1[0], P1[2], G1[2], P2[2], G2[2]);
  KS_combine s2_3 (P1[1], G1[1], P1[3], G1[3], P2[3], G2[3]);
  KS_combine s2_4 (P1[2], G1[2], P1[4], G1[4], P2[4], G2[4]);
  KS_combine s2_5 (P1[3], G1[3], P1[5], G1[5], P2[5], G2[5]);
  KS_combine s2_6 (P1[4], G1[4], P1[6], G1[6], P2[6], G2[6]);
  KS_combine s2_7 (P1[5], G1[5], P1[7], G1[7], P2[7], G2[7]);
  KS_combine s2_8 (P1[6], G1[6], P1[8], G1[8], P2[8], G2[8]);
  KS_combine s2_9 (P1[7], G1[7], P1[9], G1[9], P2[9], G2[9]);
  KS_combine s2_10(P1[8], G1[8], P1[10], G1[10], P2[10], G2[10]);
  KS_combine s2_11(P1[9], G1[9], P1[11], G1[11], P2[11], G2[11]);
  KS_combine s2_12(P1[10], G1[10], P1[12], G1[12], P2[12], G2[12]);
  KS_combine s2_13(P1[11], G1[11], P1[13], G1[13], P2[13], G2[13]);
  KS_combine s2_14(P1[12], G1[12], P1[14], G1[14], P2[14], G2[14]);
  KS_combine s2_15(P1[13], G1[13], P1[15], G1[15], P2[15], G2[15]);

  // 3
  assign P3[3:0] = P2[3:0];
  assign G3[3:0] = G2[3:0];

  KS_combine s3_4 (P2[0], G2[0], P2[4], G2[4], P3[4], G3[4]);
  KS_combine s3_5 (P2[1], G2[1], P2[5], G2[5], P3[5], G3[5]);
  KS_combine s3_6 (P2[2], G2[2], P2[6], G2[6], P3[6], G3[6]);
  KS_combine s3_7 (P2[3], G2[3], P2[7], G2[7], P3[7], G3[7]);
  KS_combine s3_8 (P2[4], G2[4], P2[8], G2[8], P3[8], G3[8]);
  KS_combine s3_9 (P2[5], G2[5], P2[9], G2[9], P3[9], G3[9]);
  KS_combine s3_10(P2[6], G2[6], P2[10], G2[10], P3[10], G3[10]);
  KS_combine s3_11(P2[7], G2[7], P2[11], G2[11], P3[11], G3[11]);
  KS_combine s3_12(P2[8], G2[8], P2[12], G2[12], P3[12], G3[12]);
  KS_combine s3_13(P2[9], G2[9], P2[13], G2[13], P3[13], G3[13]);
  KS_combine s3_14(P2[10], G2[10], P2[14], G2[14], P3[14], G3[14]);
  KS_combine s3_15(P2[11], G2[11], P2[15], G2[15], P3[15], G3[15]);

  // 4
  assign P4[7:0] = P3[7:0];
  assign G4[7:0] = G3[7:0];

  KS_combine s4_8 (P3[0], G3[0], P3[8], G3[8], P4[8], G4[8]);
  KS_combine s4_9 (P3[1], G3[1], P3[9], G3[9], P4[9], G4[9]);
  KS_combine s4_10(P3[2], G3[2], P3[10], G3[10], P4[10], G4[10]);
  KS_combine s4_11(P3[3], G3[3], P3[11], G3[11], P4[11], G4[11]);
  KS_combine s4_12(P3[4], G3[4], P3[12], G3[12], P4[12], G4[12]);
  KS_combine s4_13(P3[5], G3[5], P3[13], G3[13], P4[13], G4[13]);
  KS_combine s4_14(P3[6], G3[6], P3[14], G3[14], P4[14], G4[14]);
  KS_combine s4_15(P3[7], G3[7], P3[15], G3[15], P4[15], G4[15]);

  assign C[0] = Cin;

  KS_output out0 (P0[0], C[0], P4[0], G4[0], Cin, S[0], C[1]);
  KS_output out1 (P0[1], C[1], P4[1], G4[1], Cin, S[1], C[2]);
  KS_output out2 (P0[2], C[2], P4[2], G4[2], Cin, S[2], C[3]);
  KS_output out3 (P0[3], C[3], P4[3], G4[3], Cin, S[3], C[4]);
  KS_output out4 (P0[4], C[4], P4[4], G4[4], Cin, S[4], C[5]);
  KS_output out5 (P0[5], C[5], P4[5], G4[5], Cin, S[5], C[6]);
  KS_output out6 (P0[6], C[6], P4[6], G4[6], Cin, S[6], C[7]);
  KS_output out7 (P0[7], C[7], P4[7], G4[7], Cin, S[7], C[8]);
  KS_output out8 (P0[8], C[8], P4[8], G4[8], Cin, S[8], C[9]);
  KS_output out9 (P0[9], C[9], P4[9], G4[9], Cin, S[9], C[10]);
  KS_output out10(P0[10], C[10], P4[10], G4[10], Cin, S[10], C[11]);
  KS_output out11(P0[11], C[11], P4[11], G4[11], Cin, S[11], C[12]);
  KS_output out12(P0[12], C[12], P4[12], G4[12], Cin, S[12], C[13]);
  KS_output out13(P0[13], C[13], P4[13], G4[13], Cin, S[13], C[14]);
  KS_output out14(P0[14], C[14], P4[14], G4[14], Cin, S[14], C[15]);
  KS_output out15(P0[15], C[15], P4[15], G4[15], Cin, S[15], C[16]);

  assign Cout = C[16];
endmodule
