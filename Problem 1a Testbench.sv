// Code your testbench here
// or browse Examples

module testbench;
  
  logic A, B, Cin;
  logic S, Cout;
  
  // Instantiate the full adder module
  one_bit_full_adder uut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));
  
  initial begin
    
    // Test inputs
    
    A = 0; B = 0; Cin = 0;
    #10;
    
    A = 0; B = 0; Cin = 1;
    #10;
    
    A = 0; B = 1; Cin = 0;
    #10;
    
    A = 0; B = 1; Cin = 1;
    #10;
    
    A = 1; B = 0; Cin = 0;
    #10;
    
    A = 1; B = 0; Cin = 1;
    #10;
    
    A = 1; B = 1; Cin = 0;
    #10;
    
    A = 1; B = 1; Cin = 1;
    #10;
    
    $finish;
  end
  
  initial begin
    $monitor("A=%b B=%b Cin=%b | S=%b Cout=%b",
             A, B, Cin, S, Cout);
  end
  
endmodule
  
  
  
