module Shifter(
input signed [31:0] a,
input  shiftamt,
input op1,
input op2,
output reg [31:0] res
   );

// if op1 == 0 && op2 == 0, then it corresponds to shll
// if op1 == 1 && op2 == 0, then it corresponds to shrl
// if op1 == 0 && op2 == 1, then it corresponds to shra
  // if op1 == 1 && op2 == 1, then it corresponds to shla
 

always @(*)
begin
if(!op1 && !op2)
begin
res = a << shiftamt;
end
else if(op1 && !op2)
begin
res = a >> shiftamt;
end
else if(!op1 && op2)
begin
res = a >>> shiftamt;
end
else
begin
res = a<<< shiftamt;
end
end
endmodule