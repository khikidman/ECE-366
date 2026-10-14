`timescale 1ns/1ps

module testbench;
  reg [15:0] A, B;
  reg Cin;
  wire [15:0] S;
  wire Cout;

  integer failures;

  KS dut (.A(A), .B(B), .Cin(Cin), .S(S), .Cout(Cout));

  task check(input [15:0] a, b, input c);
    reg [16:0] expected;
    begin
      A = a;
      B = b;
      Cin = c;

      expected = {1'b0, a} + {1'b0, b} + {16'b0, c};
      #10;

      if ({Cout, S} === expected)
        $display("PASS: A=%h B=%h Cin=%b | Cout=%b S=%h",
                 A, B, Cin, Cout, S);
      else begin
        failures = failures + 1;
        $display("FAIL: A=%h B=%h Cin=%b | Cout=%b S=%h expected=%h",
                 A, B, Cin, Cout, S, expected);
      end
    end
  endtask

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
    failures = 0;

    check(16'd5, 16'd3, 0);           
    check(16'd3, ~16'd2, 1);         
    check(-16'sd3, 16'd6, 0);        
    check(-16'sd5, ~(-16'sd2), 1);   

    check(16'h000F, 16'h0001, 0);    
    check(16'h00FF, 16'h0001, 0);    
    check(16'h0FFF, 16'h0001, 0);     
    check(16'hFFFF, 16'h0001, 0);   
    check(16'hFFFF, 16'h0000, 1);   

    check(16'h0000, 16'h0000, 0);   
    check(16'hAAAA, 16'h5555, 0);   
    check(16'h1234, 16'h5678, 1);     
    check(16'h7FFF, 16'h0001, 0);    

    if (failures != 0)
      $fatal(1, "%0d tests failed", failures);

    $display("All 13 tests passed.");
    $finish;
  end
endmodule
