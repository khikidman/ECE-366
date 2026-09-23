module one_bit_full_adder(A, B, Cin, S, Cout);

  input A, B, Cin;
  output reg S, Cout;

  always @(*) begin
    {Cout, S} = {1'b0, A} + {1'b0, B} + {1'b0, Cin};
  end

endmodule
