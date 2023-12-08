 module mux
 
  (
    input wire signed [31:0] a, b,
input wire s,
    output wire signed [31:0] out      
);
   assign out = (s)? b : a;

  endmodule