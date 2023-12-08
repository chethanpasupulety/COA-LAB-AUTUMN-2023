
module mips_tb;
  reg clk, reset;
  wire [31:0] writedata;
  integer k;

  // Instantiate the module under test
  risc_processor dut (
    .clk(clk),
    .reset(reset),
    .writedata(writedata)
  );

  // Provide a clock signal
  always #5 clk = ~clk;

  // Initialize signals
  initial begin
    clk = 0;
    reset = 0;


  
  end

  // Monitor the output
  initial begin
    $dumpfile("test.vcd");
    $dumpvars(0, mips_tb);

    // printing the memory contents and register contents to check the correctness of the program.
    $monitor($time,"MEMORY:mem[0]=%d,mem[1]=%d,mem[3]=%d,reg[0]= %d,reg[1]= %d,reg[2]=%d,reg[3]=%d,reg[4]=%d",dut.dpath.dmem.dmem[0],
             dut.dpath.dmem.dmem[1],dut.dpath.dmem.dmem[2],dut.dpath.rbank.regfile[0],
             dut.dpath.rbank.regfile[1],dut.dpath.rbank.regfile[2],dut.dpath.rbank.regfile[3],dut.dpath.rbank.regfile[4]);
    
    

    #10000 $finish; // Finish the simulation after 10000 time units
  end

endmodule