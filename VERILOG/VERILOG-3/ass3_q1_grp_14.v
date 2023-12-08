// Code your design here
module one_bit_adder(in1,in2,cin,sum,cout);
input in1;
input in2;
input cin;
output sum;
output cout;
assign cout=(in1&in2)|(in2&cin)|(cin&in1);
assign sum=in1^in2^cin;
endmodule 

module eight_bit_adder (in1,in2,cin,out,cyout);
input [0:7] in1;
input [0:7]in2;
input cin;
output [0:7] out;
output cyout ;
wire c0,c1,c2,c3,c4,c5,c6,c7;
wire [0:7] p;
wire [0:7] g;
assign p=in1^in2;
assign g=in1&in2;
assign c7=cin;
assign c6=g[7]|(p[7]&cin);
assign c5=g[6]|(g[7]&p[6])|(p[7]&p[6]&cin);
assign c4=g[5]|(g[6]&p[5])|(g[7]&p[5]&p[6])|(p[5]&p[6]&p[7]&cin);
assign c3=g[4]|(g[5]&p[4])|(g[6]&p[4]&p[5])|(g[7]&p[4]&p[5]&p[6])|(p[4]&p[5]&p[6]&p[7]);
assign c2=g[3]|(g[4]&p[3])|(g[5]&p[3]&p[4])|(g[6]&p[3]&p[4]&p[5])|(g[7]&p[3]&p[4]&p[5]&p[6])|(p[3]&p[4]&p[5]&p[6]&p[7]);
assign c1=g[2]|(g[3]&p[2])|(g[4]&p[2]&p[3])|(g[5]&p[2]&p[3]&p[4])|(g[6]&p[2]&p[3]&p[4]&p[5])|(g[7]&p[2]&p[3]&p[4]&p[4]&p[6])|(p[2]&p[3]&p[4]&p[4]&p[6]&p[7]);
assign c0=g[1]|(g[2]&p[1])|(g[3]&p[1]&p[2])|(g[4]&p[1]&p[2]&p[3])|(g[5]&p[1]&p[2]&p[3]&p[4])|(g[6]&p[1]&p[2]&p[3]&p[4]&p[5])|(g[7]&p[1]&p[2]&p[3]&p[4]&p[4]&p[6])|(p[1]&p[2]&p[3]&p[4]&p[4]&p[6]&p[7]);
assign out[7]=p[7]^c7;
assign out[6]=p[6]^c6;
assign out[5]=p[5]^c5;
assign out[4]=p[4]^c4;
assign out[3]=p[3]^c3;
assign out[2]=p[2]^c2;
assign out[1]=p[1]^c1;
assign out[0]=p[0]^c0;
assign cyout = g[0]|(g[1]&p[0])|(g[2]&p[0]&p[1])|(g[3]&p[0]&p[1]&p[2])|(g[4]&p[0]&p[1]&p[2]&p[4])|(g[5]&p[0]&p[1]&p[2]&p[3]&p[4])|(g[6]&p[0]&p[1]&p[2]&p[3]&p[4]&p[5])|(g[7]&p[0]&p[1]&p[2]&p[3]&p[4]&p[4]&p[6])|(p[0]&p[1]&p[2]&p[3]&p[4]&p[4]&p[6]&p[7]);

endmodule


module sub(r1,r2,out);
  input [7:0] r1,r2;
  output [7:0] out;
  reg [7:0] t1,t2;
  reg [7:0] one=8'b00000001;
  wire t3;
  wire t4;
//   operationnegation nt(r2,r1,t1);
//   eight_bit_adder q11(t1,one,0,t2,t3);
  always @(*) t2 = ~r2 + 1'b1;
  eight_bit_adder q22(r1,t2,0,out,t4);
  
endmodule
  
  
  




module first_element(x,y,out);
    input [7:0] x,y;
    output [7:0] out;
    assign out=x;
endmodule

module leftshift(x,y,out);
    input [7:0] x,y;
    output [7:0] out;
    assign out=x<<1;
endmodule

module operationrightshift(input1,input2,out);
    input [7:0] input1,input2;
    output [7:0] out;
    reg [7:0] out;

    assign out=input1>>1;

endmodule

module operationand(input1,input2,out);
        input [7:0] input1,input2;
        output [7:0] out;
        reg [7:0] out;

        assign out=input1 & input2;

endmodule

module operationnegation(input1,input2,out);
        input [7:0] input1,input2;
        output [7:0] out;
        reg [7:0] out;

        assign out=~input1;
endmodule


module operationbitwise0R(input1,input2,out);
        input [7:0] input1,input2;
        output [7:0] out;
        reg [7:0] out;

        assign out=input1 |input2;

endmodule



module top_level_alu(reg1,reg2,func,clk,alu_out,carry_out);
  	input [7:0] reg1,reg2;
    input [2:0] func;
    input clk;

    output [7:0] alu_out;
    reg [7:0] alu_out;
    output reg carry_out;

    reg [7:0] out1,out2,out3,out4,out5,out6,out7,out8;
    reg carry_out1,carry_out2;



   //instantiating all the ALU modules

  	eight_bit_adder ADD(reg1,reg2,1'b0,out1,carry_out1);
  sub SUB(reg1,reg2,out2);

    first_element choose(reg1,reg2,out3);
  	leftshift leftshiftgate(reg1,reg2,out4);



    operationrightshift rightshiftgate(reg1,reg2,out5);
    operationand AND(reg1,reg2,out6);
    operationnegation NOT(reg1,reg2,out7);
    operationbitwise0R OR(reg1,reg2,out8);


    always @(posedge clk)
    begin
        case(func)
         3'b000: // Addition
         begin
           alu_out = out1 ; 
           carry_out=carry_out1;
         end
        3'b001: // Subtraction
        begin
           alu_out = out2 ;
           carry_out=carry_out2;

        end
        3'b010: // Multiplication
           alu_out <= out3;
        3'b011: // Division
           alu_out= out4;
        3'b100: // Logical shift left
           alu_out = out5;
         3'b101: // Logical shift right
           alu_out = out6;
         3'b110: // Rotate left
           alu_out = out7;
         3'b111: // Rotate right
           alu_out = out8;
        endcase
    end

endmodule

    
