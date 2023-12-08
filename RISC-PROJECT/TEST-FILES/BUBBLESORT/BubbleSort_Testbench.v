`timescale 1ps/1ps

module mips_tb;
  reg clk, reset;
  reg [9:0] inaddress;
  wire [31:0] writedata;
  wire [15:0] outdata;
  

  // Instantiate the module under test
  risc_processor dut (
    .inaddress(inaddress),
    .clk(clk),
    .reset(reset),
//    .writedata(writedata),
    .outdata(outdata)
  );


  // Provide a clock signal
  always #5 clk = ~clk;

  // Initialize signals
  initial begin
    clk = 0;
    reset = 0;
  end

  initial begin



   $monitor($time," Array:mem[0]=%d,mem[1]=%d,mem[2]=%d,mem[3]=%d,mem[4]=%d,mem[5]=%d,mem[6]=%d,mem[7]=%d,mem[8]=%d,mem[9]=%d",dut.dpath.dmem.dmem[100],
   dut.dpath.dmem.dmem[101],dut.dpath.dmem.dmem[102],dut.dpath.dmem.dmem[103],
   dut.dpath.dmem.dmem[104],dut.dpath.dmem.dmem[105],dut.dpath.dmem.dmem[106],
   dut.dpath.dmem.dmem[107],dut.dpath.dmem.dmem[108],dut.dpath.dmem.dmem[109]);

   #1000000 $finish; // Finish the simulation after 10000 time units

  end

endmodule