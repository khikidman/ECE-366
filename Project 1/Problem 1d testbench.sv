// Code your testbench here
// or browse Examples

module testbench;

  reg [3:0] A;
  reg [3:0] B;
  reg Cin;

  wire [3:0] S;
  wire Cout;

  four_bit_RCA_RCS dut (
    .A(A),
    .B(B),
    .Cin(Cin),
    .S(S),
    .Cout(Cout)
  );

  initial begin

    // Test 1: 5 + 3 = 8
    A = 4'b0101;
    B = 4'b0011;
    Cin = 1'b0;
    
    #10;
    
    // Test 2: 3 - 2 = 1
    A = 4'b0011;
    B = 4'b0010;
    Cin = 1'b1;
    
    #10;
    
    // Test 3: 5 - 7 = -2
    A = 4'b0101;
    B = 4'b0111;
    Cin = 1'b1;
    
    #10
    
    // Test 4: (-5) - (-2) = -3
    A = 4'b1011;
    B = 4'b1110;
    Cin = 1'b1;

    #10;

    $finish;

  end
  
  initial begin
    $monitor("A=%b B=%b Cin=%b | S=%b Cout=%b",
             A, B, Cin, S, Cout);
  end

endmodule
  
  
  
