module testbench;

  reg  [31:0] A, B;
  reg         Cin;
  wire [31:0] S;
  wire        Cout;

  CLA dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

  task check(input [31:0] a, b, input c);
    begin
      {A, B, Cin} = {a, b, c};
      #10;
      $display("%s: A=%h B=%h Cin=%b | Cout=%b S=%h",
               ({Cout, S} === A + B + Cin) ? "PASS" : "FAIL", A, B, Cin, Cout, S);
    end
  endtask

  initial begin
    check(32'd5,    32'd3,    0);  // 5 + 3 = 8
    check(32'd3,    32'd2,    1);  // 3 + 2 + 1 = 6
    check(-32'sd3,  32'd6,    0);  // (-3) + 6 = 3
    check(32'd5,    -32'sd2,  0);  // 5 + (-2) = 3
    check(-32'sd5,  -32'sd2,  0);  // (-5) + (-2) = -7

    check(32'h0000FFFF, 32'h1, 0);  // carry through blocks 0-3
    check(32'hFFFFFFFF, 32'h1, 0);  // carry through all 8 blocks, Cout=1
    check(32'hFFFFFFFF, 32'h0, 1);  // Cin propagates through all 8 blocks
    check(32'h0F0F0F0F, 32'h01010101, 0);  // mixed generate/propagate
    check(32'h12345678, 32'h9ABCDEF0, 1);  // general case with Cin
    $finish;
  end

endmodule
