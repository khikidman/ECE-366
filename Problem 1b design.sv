module one_bit_full_adder(A, B, Cin, S, Cout);
  
  input A, B, Cin;
  output S, Cout;

  wire x1;
  wire x2;
  wire x3;
  wire x4;

  xor (x1, A, B);
  xor (S, x1, Cin);

  and (x2, A, B);
  and (x3, x1, Cin);

  or  (Cout, x2, x3);

  
endmodule
