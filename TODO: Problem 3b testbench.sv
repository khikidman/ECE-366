module testbench;

  reg  [15:0] A, B;
  reg         Cin;
  wire [15:0] S;
  wire        Cout;

  PPA dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

  task check(input [15:0] a, b, input c);
    begin
      {A, B, Cin} = {a, b, c};
      #10;
      $display("%s: A=%h B=%h Cin=%b | Cout=%b S=%h",
               ({Cout, S} === A + B + Cin) ? "PASS" : "FAIL", A, B, Cin, Cout, S);
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tesbench);
    
    check(16'd5,    16'd3,    0);  // 5 + 3 = 8
    check(16'd3,    16'd2,    1);  // 3 + 2 + 1 = 6
    check(-16'sd3,  16'd6,    0);  // (-3) + 6 = 3
    check(16'd5,    -16'sd2,  0);  // 5 + (-2) = 3
    check(-16'sd5,  -16'sd2,  0);  // (-5) + (-2) = -7
    
    //subtracttion through adder
    check(16'd5000, ~16'd1234,   1); //5000 - 1234 = 3766 
    check(16'd5,    ~(-16'sd2),  1); // 5 - (-2) = 7
    check(-16'sd5,  ~(-16'sd2),  1); // (-5) - (-2) = -3

    check(16'h00FF, 16'h1, 0);  // carry through blocks 0-7
    check(16'h0FFF, 16'h1, 0);  // carry through blocks 0-11
    check(16'hFFFF, 16'h1, 0);  // carry through all 8 blocks, Cout=1
    check(16'hFFFF, 16'h0, 1);  // Cin propagates through all 8 blocks
    check(16'h0F0F, 16'h0101, 0);  // mixed generate/propagate
    check(16'h1234, 16'h9ABC, 1);  // general case with Cin
    $finish;
  end

endmodule
    
    
