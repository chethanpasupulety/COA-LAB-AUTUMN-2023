// #GROUP NO:14
// # Verilog ASSIGNMENT 6
// #Question No 1
// #NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
// #      :Vikhyath Gummadi (21CS10028)
// #Autumn 2023





`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 11.09.2023 15:37:50
// Design Name:
// Module Name: top_level
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module register_memory_interface (
    input wire clk,
    input wire [1:0] opcode,
    input wire [3:0] data_in,
    input wire [2:0] reg_adrs,
    input wire [3:0] mem_adrs,
    output reg [3:0] data_out
   
);
    //wires and registers for intermediatary connections between memory module and registers
        reg [3:0] mem_data_in;
        wire [3:0] reg_data_out;
        wire [3:0] mem_data_out;
        reg mem_write_enable;
        reg mem_read_enable;
 
    //register bank
    reg [3:0] registers [7:0];




 //instantiating the memory module
  blk_mem_gen_0 MEM (
  .clka(clk),    // input wire clka
  .ena(mem_read_enable),      // input wire ena
  .wea(mem_write_enable),      // input wire [0 : 0] wea
  .addra(mem_adrs),  // input wire [3 : 0] addra
  .dina(mem_data_in),    // input wire [3 : 0] dina
  .douta(mem_data_out)  // output wire [3 : 0] douta
);
 
 
 
  assign reg_data_out=registers[reg_adrs];
 
  always @(negedge clk)begin
    case(opcode)
        2'b00: begin
                //writing data_in to the  memory location
                mem_read_enable<=1;
                mem_write_enable<=1;
                mem_data_in<=data_in;
             end
           
        2'b01: begin
                // moving data from reg[select] to memory location
                mem_read_enable<=1;
                mem_write_enable<=1;
                mem_data_in <= registers[reg_adrs];
                 
                end
           
           
         2'b10: begin
                // moving data from memory location to reg[select]
                mem_read_enable<=1;
                mem_write_enable<=0;
                registers[reg_adrs]<=mem_data_out;
               
                 end
           
           
         2'b11: begin
                // getting data from memory location
                mem_read_enable<=1;
                mem_write_enable<=0;
                
            end
           
    endcase
    
    
    data_out=mem_data_out;
     
     
     
    end
           
           
 
 


endmodule