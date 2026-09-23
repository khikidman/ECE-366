timescale 1ns/1ps
module tb_fourbit_RCA;

  reg [3:0] A;
  reg [3:0] B;
  reg Cin;

   
  wire [3:0] S;
  wire Cout;


  four_bit_RCA uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S(S),
        .Cout(Cout)
  );

  initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_four_bit_RCA);
    
        $monitor("Time=%0t | A=%b (%0d) | B=%b (%0d) | Cin=%b | S=%b (%0d) | Cout=%b", 
                 $time, A, A, B, B, Cin, S, S, Cout);

        //Test 1: 3 + 5 = 8
        A = 4'b0011; B = 4'b0101; Cin = 1'b0;
        #10;

        // Test 2: 4 + 2 + 1 = 7
        A = 4'b0100; B = 4'b0010; Cin = 1'b1;
        #10;

        // Test 3: 12 + 5 = 17 -> S=1, Cout=1
        A = 4'b1100; B = 4'b0101; Cin = 1'b0;
        #10;

        // Test 4: 15 + 15 + 1 = 31 -> S=15, Cout=1
        A = 4'b1111; B = 4'b1111; Cin = 1'b1;
        #10;

        $finish;
    end

endmodule
