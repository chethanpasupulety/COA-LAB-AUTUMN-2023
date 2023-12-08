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

  // Monitor the output
  initial begin

     $monitor($time," MEMORY:mem[0]=%d,mem[1]=%d,mem[3]=%d,reg[0]= %d,reg[1]= %d,reg[2]=%d,reg[3]=%d,reg[4]=%d",dut.dpath.dmem.dmem[0],
              dut.dpath.dmem.dmem[1],dut.dpath.dmem.dmem[2],dut.dpath.rbank.regfile[0],
              dut.dpath.rbank.regfile[1],dut.dpath.rbank.regfile[2],dut.dpath.rbank.regfile[3],dut.dpath.rbank.regfile[4]);
       #5200
       //printing final values in the memory after program execution
       inaddress=0;
        #20
       $display("mem[0]=",outdata);
     
       inaddress=1;
        #20
        $display("mem[1]=",outdata);
         
       inaddress=2;
        #20
        // mem[2] contains the final value of the GCD
        $display("mem[2]=",outdata);
    
    #10000 $finish;

  end

endmodule