// #GROUP NO:14
// #ASSIGNMENT 4
// #Question No 1
// #NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
// #      :Vikhyath Gummadi (21CS10028)
// #Autumn 2023


// ADDER AND SUBSTRACTOR MODULE
module adder(out, a, b, cin);
  output [7:0] out;
  input [7:0] a;
  input [7:0] b;
  input cin;
  assign out = a + b + cin;
endmodule


module substractor(out, a, b);
  output [7:0] out;
  input [7:0] a;
  input [7:0] b;
  
  assign out = a + (b) + 1;
endmodule



//TOP LEVEL BOOTH MODULE
module BoothMul(clk, rst, start, X, Y, valid, Z);

  input clk;             
  input rst;                
  input start;              
  input signed [7:0] X, Y;  // 8-bit signed inputs X and Y
  output signed [15:0] Z;   // 16-bit signed output Z
  output valid;             

  //VARIABLES FOR STORING STATE INFORMATION
  reg signed [15:0] Z, next_Z, Z_temp;  
  reg next_state, pres_state;           
  reg [1:0] temp, next_temp;             
  reg [2:0] count, next_count;           
  reg valid, next_valid;    
  
  //REGS TO STORE THE SUM AND DIFF FROM THE ADDER MODULES
  reg [7:0] sum;
  reg [7:0] diff;
  
  
	//INSTANTIATING ADDER AND SUBSTRACTOR MODULES 
  adder add (.out(sum), .a(Z[15:8]), .b(Y), .cin(1'b0));
  adder sub (.out(diff), .a(Z[15:8]), .b(~Y), .cin(1'b1));
  
  
  parameter IDLE = 1'b0;  
  parameter START = 1'b1; 

  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      Z <= 16'd0;          
      valid <= 1'b0;       
      pres_state <= 1'b0;  // Reset present state to 0
      temp <= 2'd0;        
      count <= 3'd0;      
    end else begin
      Z <= next_Z;          
      valid <= next_valid;  
      pres_state <= next_state;  
      temp <= next_temp;          
      count <= next_count;        
    end
  end

  always @ (*) begin 
    case (pres_state)
      IDLE:
        begin
          next_count = 3'b0;           
          next_valid = 1'b0;           
          if (start) begin             // If start signal is asserted
            next_state = START;        // Move to START state
            next_temp = {X[0], 1'b0};  
            next_Z = {8'd0, X};        
          end else begin               // If start signal is not asserted
            next_state = pres_state;   // Stay in the IDLE state
            next_temp = 2'd0;          
            next_Z = 16'd0;            
          end
        end

      START:
        begin
          case (temp)
            2'b10: Z_temp = {diff, Z[7:0]}; // Subtraction case
            2'b01: Z_temp = {sum, Z[7:0]}; // Addition case
            default: Z_temp = {Z[15:8], Z[7:0]};    // Default case
          endcase
          next_temp = {X[count+1], X[count]};  // Updating new_temp
          next_count = count + 1'b1;          
          next_Z = Z_temp >>> 1;               
          next_valid = (&count) ? 1'b1 : 1'b0; // If count is not zero, set valid
          next_state = (&count) ? IDLE : pres_state; // If count is not zero, go to IDLE
        end
    endcase
  end
endmodule

