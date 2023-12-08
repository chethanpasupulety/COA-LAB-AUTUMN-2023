module ALU(input signed[31:0] a, input signed[31:0] b, input[3:0] ALUSel,input wire en,output reg[31:0] result);

wire[31:0] adderRes;
  wire[31:0] subRes;
wire[31:0] xorRes;
wire[31:0] andRes;
wire[31:0] shiftRes;
  wire[31:0] orRes;
  wire [31:0] notRes;
wire carry_out1;
  wire carry_out2;
wire[31:0] onesComp;

// for addition
  Add add1(.a(a), .b(b), .c_in(1'b0), .sum(adderRes), .c_out(carry_out1));

// for substraction
assign onesComp = ~b;
  Add sub1(.a(a), .b(onesComp), .c_in(1'b1),.sum(subRes), .c_out(carry_out2));

// for XOR, AND,OR,NOT
assign xorRes = a^b;
assign andRes = a&b;
  assign orRes  = a|b;  
  assign notRes= ~a;

  // for shifting 'a' by 'b[0]'
  Shifter shift1(.a(a), .shiftamt(b[0]), .op1(ALUSel[0]), .op2(ALUSel[1]), .res(shiftRes));




always @(*)
begin
case (ALUSel)
4'b0000: begin
result = adderRes;
// carry = carry_out1;
end
4'b0001:begin
                  result = subRes;
                //   carry = carry_out2;
                end
4'b0010: result = andRes;
4'b0011: result = xorRes;
              4'b0100: result = orRes;
              4'b0101: result = notRes;
4'b0110: result = a <<< b[0];
4'b0111: result = a << b[0];
4'b1000: result = a >>> b[0];
              4'b1001: result = a >> b[0];
              4'b1010: result = a+{b[29:0],2'b00};
default: result = a;
endcase
end



endmodule