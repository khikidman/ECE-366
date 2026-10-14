module PPA(A, B, Cin, S, Cout);
  
  input [15:0] A, B;
  input Cin;
  
  output [15:0] S;
  output Cout;
  
  // P and G variables for each bit (for each 'layer' of the  PPA tree)
  wire [15:0] P [0:7];
  wire [15:0] G [0:7];
  
  wire [16:0] C;  // Carry variables for each bit
  wire [15:0] x;  // XOR wire variables for each bit
  wire [15:0] ct; // Intermediary carry wire for carrying into the next bit
  
  assign C[0] = Cin;
  
  genvar i, stage;
  
  // Propagate and Generate for each bit.
  generate
    for (i = 0; i < 16; i = i + 1) begin
      or (P[0][i], A[i], B[i]);
      and (G[0][i], A[i], B[i]);
      xor (x[i], A[i], B[i]);
    end
  endgenerate
  
  // Seven levels of the Brent-Kung prefix tree
  generate 
    for (stage = 0; stage < 7; stage = stage + 1) begin: LEVEL
      for (i = 0; i < 16; i = i + 1) begin: BIT
        
        // Distance to the lower prefix group
        localparam integer DIST =
        (stage == 0) ? 1 :
        (stage == 1) ? 2 :
        (stage == 2) ? 4 :
        (stage == 3) ? 8 :
        (stage == 4) ? 4 :
        (stage == 5) ? 2 : 1;
        
        // Locations containing the black prefix blocks in the diagram
        if (
          (stage == 0 && i % 2 == 1) ||
          (stage == 1 && i % 4 == 3) ||
          (stage == 2 && i % 8 == 7) ||
          (stage == 3 && i == 15) ||
          (stage == 4 && i == 11) ||
          (stage == 5 && (i == 5 || i == 9 || i == 13)) ||
          (stage == 6 && i >= 2 && i % 2 == 0)
        ) begin: COMBINE
          
          PG_combine pg(
            P[stage][i-DIST],
            G[stage][i-DIST],
            P[stage][i],
            G[stage][i],
            P[stage+1][i],
            G[stage+1][i]
          );
          
        end else begin: PASS
          
          assign P[stage+1][i] = P[stage][i];
          assign G[stage+1][i] = G[stage][i];
          
        end
      end
    end
  endgenerate
  
  // Compute carry and sum using P and G tree computations
  generate
    for (i = 0; i < 16; i = i + 1) begin
      xor (S[i], x[i], C[i]);
      and (ct[i], P[7][i], Cin);
      or (C[i+1], G[7][i], ct[i]);
    end
  endgenerate
  
  assign Cout = C[16];
  
endmodule


// Combine two propagate/generate groups
module PG_combine(Plow, Glow, Phigh, Ghigh, Pout, Gout);

  input Plow, Glow;
  input Phigh, Ghigh;

  output Pout, Gout;

  wire temp;

  and (Pout, Phigh, Plow);
  and (temp, Phigh, Glow);
  or  (Gout, Ghigh, temp);

endmodule
