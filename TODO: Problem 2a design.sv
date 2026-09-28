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

module four_bit_RCA_RCS(A, B, Cin, S, Cout);

  input [3:0] A, B;
  input Cin;
  output [3:0] S;
  output Cout;

  wire [3:0] Bx;
  wire C1, C2, C3;
  
  xor (Bx[0], B[0], Cin);
  xor (Bx[1], B[1], Cin);
  xor (Bx[2], B[2], Cin);
  xor (Bx[3], B[3], Cin);
  
  one_bit_full_adder FA0(A[0], Bx[0], Cin, S[0], C1);
  one_bit_full_adder FA1(A[1], Bx[1], C1, S[1], C2);
  one_bit_full_adder FA2(A[2], Bx[2], C2, S[2], C3);
  one_bit_full_adder FA3(A[3], Bx[3], C3, S[3], Cout);

endmodule

module CLA(A, B, Cin, S, Cout);

  input [31:0] A, B;
  input Cin;
  output [31:0] S;
  output Cout;
  
  wire [6:0] Cx;

  four_bit_RCA_RCS four_bit_block_one(A[3:0], B[3:0], Cin, S[3:0], Cx[0]);
  four_bit_RCA_RCS four_bit_block_two(A[7:4], B[7:4], Cx[0], S[7:4], Cx[1]);
  four_bit_RCA_RCS four_bit_block_three(A[11:8], B[11:8], Cx[1], S[11:8], Cx[2]);
  four_bit_RCA_RCS four_bit_block_four(A[15:12], B[15:12], Cx[2], S[15:12], Cx[3]);
  four_bit_RCA_RCS four_bit_block_five(A[19:16], B[19:16], Cx[3], S[19:16], Cx[4]);
  four_bit_RCA_RCS four_bit_block_six(A[23:20], B[23:20], Cx[4], S[23:20], Cx[5]);
  four_bit_RCA_RCS four_bit_block_seven(A[27:24], B[27:24], Cx[5], S[27:24], Cx[6]);
  four_bit_RCA_RCS four_bit_block_eight(A[31:28], B[31:28], Cx[6], S[31:28], Cout);

endmodule
  
  
