

module tb_top_level_alu;

    // write a test bench to check the add function in alu module

  reg [7:0] reg1,reg2;
  reg [2:0]func;
  reg clk;
    reg [7:0] alu_out;
    reg carry_out;

    top_level_alu DUT(reg1,reg2,func,clk,alu_out,carry_out);

    initial clk = 0;
    always #5 clk = ~clk;
  
  
   initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1);
  end

    initial begin
      
      $display("testing adder");
      	reg1 = 8'b00000001;
        reg2 = 8'b00000011;
        func = 3'b000;
      	#20
        $display("reg1=%b,reg2=%b,output_add=%b",reg1,reg2,alu_out);
        #10;
      
        reg1 = 8'b00000001;
        reg2 = 8'b00001100;
        func = 3'b000;
      	#20
        $display("reg1=%b,reg2=%b,output_add=%b",reg1,reg2,alu_out);
      
        #10;
        reg1 = 8'b00011111;
        reg2 = 8'b00000001;
        func = 3'b000;
     	#20
        $display("reg1=%b,reg2=%b,output_add=%b",reg1,reg2,alu_out);
      
      //     testing substractor
     
        #10;
      $display("testing substracter");
        reg1 = 8'b00000010;
        reg2 = 8'b00000001;
        func = 3'b001;
      	#20
      $display("reg1=%0d,reg2=%0d,output_sub=%0d",reg1,reg2,alu_out);
      
        #10;
        reg1 = 8'b00000100;
        reg2 = 8'b00000001;
        func = 3'b001;
      	#20
      $display("reg1=%0d,reg2=%0d,output_sub=%0d",reg1,reg2,alu_out);
      
      	//testing selector
      
        #10
      	$display("testing first selector ");
     	reg1 = 8'b00100000;
        reg2 = 8'b00000001;
        func = 3'b010;
      	#20
      $display("reg1=%0d,reg2=%b,output_first=%b",reg1,reg2,alu_out);
      
        #10;
        reg1 = 8'b00000001;
        reg2 = 8'b00001100;
        func = 3'b010;
      	#20
        $display("reg1=%b,reg2=%b,output_first=%b",reg1,reg2,alu_out);
      
      //testing left shift operator
      
        #10;
      	$display("testing left shift operator ");
      	reg1 = 8'b00000000;
        reg2 = 8'b00000001;
        func = 3'b011;
      	#20
        $display("reg1=%b,reg2=%b,output_leftshift=%b",reg1,reg2,alu_out);
      
        #10;
        reg1 = 8'b00000100;
        reg2 = 8'b00000001;
        func = 3'b011;
      	#20
        $display("reg1=%b,reg2=%b,output_leftshift=%b",reg1,reg2,alu_out);
      
        #10;
        reg1 = 8'b10000000;
        reg2 = 8'b00000001;
        func = 3'b011;
      	#20
        $display("reg1=%b,reg2=%b,output_leftshift=%b",reg1,reg2,alu_out);
      
      
      //testing right shift operator
      
        #10;
      	$display("testing right shift operator ");
        reg1 = 8'b00000001;
        reg2 = 8'b00000001;
        func = 3'b100;
      	#20
      $display("reg1=%b,reg2=%b,output_righttshift=%b",reg1,reg2,alu_out);
        
        #10;
      	$display("testing right shift operator ");
        reg1 = 8'b01000001;
        reg2 = 8'b00000001;
        func = 3'b100;
      	#20
      $display("reg1=%b,reg2=%b,output_righttshift=%b",reg1,reg2,alu_out);
      
      //testing bit wise and operator
      
        #10;
      $display("testing bit wise and operator ");
        reg1 = 8'b01010001;
        reg2 = 8'b00010001;
        func = 3'b101;
      	#20
      $display("reg1=%b,reg2=%b,output_bitwiseand=%b",reg1,reg2,alu_out);
      
         
        #10;
        reg1 = 8'b00010100;
        reg2 = 8'b00010001;
        func = 3'b101;
      	#20
      $display("reg1=%b,reg2=%b,output_bitwiseand=%b",reg1,reg2,alu_out);
      
      
      //testing bit wise negation operator
      
           #10;
      $display("testing bit wise negation operator ");
        reg1 = 8'b01010101;
        reg2 = 8'b00010001;
        func = 3'b110;
      	#20
      $display("reg1=%b,reg2=%b,output_bitwisenot=%b",reg1,reg2,alu_out);
      
      	#10
        reg1 = 8'b10010101;
        reg2 = 8'b00010001;
        func = 3'b110;
      	#20
      $display("reg1=%b,reg2=%b,output_bitwisenot=%b",reg1,reg2,alu_out);
      
      //testing bitwise OR operator
      
       #10;
      $display("testing bit wise or operator ");
        reg1 = 8'b01010101;
        reg2 = 8'b00010001;
        func = 3'b111;
      	#20
      $display("reg1=%b,reg2=%b,output_bitwiseor=%b",reg1,reg2,alu_out);
      
      	#10 
        reg1 = 8'b11111111;
        reg2 = 8'b00000000;
        func = 3'b111;
      	#20
      $display("reg1=%b,reg2=%b,output_bitwiseor=%b",reg1,reg2,alu_out);
      
       $finish();

    end
endmodule