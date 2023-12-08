

module instructionmem (
    input read,
    input wire [5:0] addr,
    output wire [31:0] I
);
   
reg [31:0] imem[0:63];
  
 // checking addi,subi,bz,load,store,move instructions.
 // everything works correctly.
initial
begin
  imem[0]=32'b01000100000001000000000000001000;  // subi r4,r0,8. r4=-8
  

  imem[1]=32'b11001100010000100000000000000001;  // Branch to imem[3] if r2==0
  imem[2]=32'b01000000000001000000000000000000;  //addi r4,r0,0 r4=0 but this instr is skipped to to imem[3] =>r4 retains -8.


  imem[3]=32'b01101000100000100000000000000000;  // Move r4 to r2 r2=-8
  imem[4]=32'b01000000010000010000000000000100;  // addi r1,r2,4  r1=-4


  imem[5]=32'b10001000000000010000000000000001;  // Store the value of r1 in memory[1]. mem[1]=-4

  imem[6]=32'b10000100000000110000000000000001;  // Load the value in memory[1] to r3. r3=-4
  imem[7]=32'b10001000000001000000000000000010;  // Store the value of r4 in memory[2] . mem[2]=-8
 
  imem[8]=32'b11111111111111111111111111111111; //halt

 
end


assign I = (read)? imem[addr] : 32'bx;
endmodule