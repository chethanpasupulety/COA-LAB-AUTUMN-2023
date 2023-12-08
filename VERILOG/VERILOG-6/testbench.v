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
// Create Date: 11.09.2023 17:50:06
// Design Name:
// Module Name: testbench
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

module TestBench;

    reg clk;
    reg [3:0] reg_sel;
    reg [3:0] mem_addr;
    reg [3:0] data_in;
    reg [1:0]opcode;
    wire [3:0] out;



   register_memory_interface top_module (  //creating a instance of the topmodule
        .clk(clk),
        .reg_adrs(reg_sel),
        .mem_adrs(mem_addr),
        .data_in(data_in),
        .opcode(opcode),
        .data_out(out)
    );


always #10 clk=~clk;   //initialising the clock and making it trigger every 10s
   
   initial begin
     $monitor ("opcode=%d,data_out=%d", opcode, out);

    clk = 0;
   //1. testing opcode 0,data------>mem[adrs]

   //  0---->mem[0]
    reg_sel = 0;
    mem_addr = 0;
    data_in = 0;
    opcode=0;
   
    #20
    //  1----->mem[1]
    reg_sel = 0;
    mem_addr = 1;
    data_in = 1;
    opcode=0;
   
    #20
    //  2------>mem[2]
    reg_sel = 0;
    mem_addr = 2;
    data_in = 2;
    opcode=0;
   
    //2.testing opcode=2   mem--->reg
    #20

    // mem[1]=1-------->reg[0]
     reg_sel =0;
    mem_addr = 1;
    data_in = 4;
    opcode=2;
   

    //3. testing opcode=3.  reg----->mem
    #40
    //reg[0]---->mem[3]
    reg_sel=0;
    mem_addr=3;
    data_in=4;
    opcode=1;
   
    //reg[0]------->mem[4]
    #40
    reg_sel=0;
    mem_addr=4;
    data_in=4;
    opcode=1;
   
   
    //4. testing opcode=4, mem----->data_out
  
    #40
      //mem[2]---------->data_out
     reg_sel = 0;
    mem_addr = 2;
    data_in = 4;
    opcode=3;
   

   
   end

endmodule
