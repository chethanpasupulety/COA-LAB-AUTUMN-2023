// #GROUP NO:14
// #ASSIGNMENT 5
// #Question No 1
// #NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
// #      :Vikhyath Gummadi (21CS10028)
// #Autumn 2023



// Set the timescale for simulation
`timescale 1ns / 1ns

// Define the testbench module
module tb_div255;

  // Create a testbench to check the add function in the top_level module
  reg [31:0] x;       // 32-bit input x
  wire [31:0] y;      // 32-bit output y
  reg clk;            // Clock signal
  
  // Instantiate the top-level module
  top_level DUT(.x(x), .clk(clk), .y(y));

  // Initialize the clock signal
  initial clk = 0;

  // Toggle the clock every 5 time units
  always #5 clk = ~clk;

  // Initialize simulation dump
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end

  // Test cases for the top_level module
  initial begin
    #100;
    x = 32'd2550;
    #100;
    $display("x = %b %d  y = %b %d ", x, x, y, y);

    x = 32'd8160;
    #100;
    $display("x = %b %d  y = %b %d ", x, x, y, y);

    x = 32'd32640;
    #100;
    $display("x = %b %d  y = %b %d ", x, x, y, y);

    x = 32'd4335;
    #100;
    $display("x = %b %d  y = %b %d ", x, x, y, y);

    $finish;
  end

endmodule
