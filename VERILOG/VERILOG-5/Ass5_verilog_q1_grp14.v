// #GROUP NO:14
// #ASSIGNMENT 5
// #Question No 1
// #NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
// #      :Vikhyath Gummadi (21CS10028)
// #Autumn 2023


`timescale 1ns / 1ps




module substractor(y0,x0,bin,bout,diff);
  input [7:0] x0;             // input 8 bit x0 
  input [7:0] y0;              // input 8 bit y0
  output [7:0] diff;            // output 8 bit diff
  input bin;                // input bin
  output bout;              // output bout
 
    wire [7:0] temp;        // temp variable
 
  assign temp=x0+bin;       // temp=x0+bin
  assign {bout,diff}=y0-temp;       // {bout,diff}=y0-temp
   
endmodule


module top_level(x,clk,y);      // top level module
  input [31:0] x;            // input 32 bit x
  input clk;                // input clk
  output [31:0] y;              // output 32 bit y

 
  reg [7:0] x4,x3,x2,x1;        // 8 bit x4,x3,x2,x1
  wire [7:0] y4,y3,y2,y1;       // 8 bit y4,y3,y2,y1
  wire b4,b3,b2,b1;             // b4,b3,b2,b1
 
  //INSTANTIATING SUBSTRACTOR MODULES
  substractor sub1(.y0(8'b00000000),.x0(x1),.bin(1'b0),.bout(b1),.diff(y1));
  substractor sub2(.y0(y1),.x0(x2),.bin(b1),.bout(b2),.diff(y2));
  substractor sub3(.y0(y2),.x0(x3),.bin(b2),.bout(b3),.diff(y3));
  substractor sub4(.y0(y3),.x0(x4),.bin(b3),.bout(b4),.diff(y4));
 
  always @(posedge clk)
    begin
    x1<=x[7:0];
  x2<=x[15:8];
  x3<=x[23:16];
  x4<=x[31:24];
    end
 

 //concactinating all the results from the substracted modules
  assign y={y4,y3,y2,y1};
 
 endmodule