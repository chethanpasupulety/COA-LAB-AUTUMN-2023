`timescale 1ps/1ps

module Add(input[31:0] a, input[31:0] b, input c_in, output[31:0] sum, output c_out);

	wire c_out1;        
	CLA_16bit CLA1 (.a(a[15:0]), .b(b[15:0]), .c_in(c_in), .sum(sum[15:0]), .c_out(c_out1));
	CLA_16bit CLA2 (.a(a[31:16]), .b(b[31:16]), .c_in(c_out1), .sum(sum[31:16]), .c_out(c_out));

endmodule



module CLA_16bit(input [15:0] a, input [15:0] b, input c_in, output [15:0] sum, output c_out);
   
    parameter k = 1'b1;
    wire [3:0] p, g, c;

    CLA_4bit cla1(.a(a[3:0]), .b(b[3:0]), .c_in(c_in), .sum(sum[3:0]), .c_out(), .P(p[0]), .G(g[0]));
    CLA_4bit cla2(.a(a[7:4]), .b(b[7:4]), .c_in(c[1]), .sum(sum[7:4]), .c_out(), .P(p[1]), .G(g[1]));
    CLA_4bit cla3(.a(a[11:8]), .b(b[11:8]), .c_in(c[2]), .sum(sum[11:8]), .c_out(), .P(p[2]), .G(g[2]));
    CLA_4bit cla4(.a(a[15:12]), .b(b[15:12]), .c_in(c[3]), .sum(sum[15:12]), .c_out(), .P(p[3]), .G(g[3]));

    lookahead_carry_unit lcu(.p(p), .g(g), .c_in(c_in), .c(c), .c_out(c_out));
endmodule


module CLA_4bit(input [3:0] a,input [3:0] b, input c_in, output [3:0] sum, output c_out, P, G);

    wire [3:0] p, g;       
    wire [3:0] c;          

    assign p = a ^ b;       // assign values to propagate bits
    assign g = a & b;       // assign values to generate bits

    // compute the carry bits
    assign c[0] = c_in;
    assign c[1] = g[0] | (p[0] & c_in);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c_in);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c_in);

    // compute the sum
    assign sum = p ^ c;

    // compute block propagate and generate for the next level
    assign P = p[3] & p[2] & p[1] & p[0];
    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    
    // assign c_out
    assign c_out = G + (P & c_in);
endmodule





module lookahead_carry_unit(input [3:0] p, input [3:0] g, input c_in, output [3:0] c, output c_out);

    assign c[0] = c_in;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c_out = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

endmodule




module Shifter(
	input signed [31:0] a, 
	input  shiftamt,
	input op1, 
	input op2,
	output reg [31:0] res
   );
	 
	// if op1 == 0 && op2 == 0, then it corresponds to shll
	// if op1 == 1 && op2 == 0, then it corresponds to shrl
	// if op1 == 0 && op2 == 1, then it corresponds to shra
  	// if op1 == 1 && op2 == 1, then it corresponds to shla
  	
	
	always @(*)
		begin
			if(!op1 && !op2) 
			begin
				res = a << shiftamt;
			end
			else if(op1 && !op2)
			begin
				res = a >> shiftamt;
			end
			else if(!op1 && op2)
			begin
				res = a >>> shiftamt;
			end
			else
			begin
				res = a<<< shiftamt;
			end
		end
endmodule




module adder(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] out
);
    assign out = a + b;
endmodule





module ALU(input signed[31:0] a, input signed[31:0] b, input[3:0] ALUSel,input wire en,output reg[31:0] result);

	wire[31:0] adderRes;
  	wire[31:0] subRes;
	wire[31:0] xorRes;
	wire[31:0] andRes;
	wire[31:0] shiftRes;
  	wire[31:0] orRes;
 	wire [31:0] notRes;
	wire carry_out1;
  	wire carry_out2;
	wire[31:0] onesComp;

	// for addition
  Add add1(.a(a), .b(b), .c_in(1'b0), .sum(adderRes), .c_out(carry_out1));

	// for substraction 
	assign onesComp = ~b;
  Add sub1(.a(a), .b(onesComp), .c_in(1'b1),.sum(subRes), .c_out(carry_out2));

	// for XOR, AND,OR,NOT
	assign xorRes = a^b;
	assign andRes = a&b;
  	assign orRes  = a|b;  
  	assign notRes= ~a;

  // for shifting 'a' by 'b[0]'
  Shifter shift1(.a(a), .shiftamt(b[0]), .op1(ALUSel[0]), .op2(ALUSel[1]), .res(shiftRes));

	


	always @(*) 
		begin
			case (ALUSel)
				4'b0000: begin
					result = adderRes;
					// carry = carry_out1;
				end
				4'b0001:begin
                  result = subRes;
                //   carry = carry_out2;
                end
				4'b0010: result = andRes;
				4'b0011: result = xorRes;
              	4'b0100: result = orRes;
              	4'b0101: result = notRes;
				4'b0110: result = a <<< b[0]; 
				4'b0111: result = a << b[0];
				4'b1000: result = a >>> b[0];
              	4'b1001: result = a >> b[0];
              4'b1010: result = a+{b[29:0],2'b00};
				default: result = a;
			endcase
		end

	

endmodule


 module mux
  
  (
    input wire signed [31:0] a, b,
input wire s,
    output wire signed [31:0] out      
);
   assign out = (s)? b : a;

  endmodule



module signext (
    input wire [15:0] a,
    output wire [31:0] y
);

assign y = {{16{a[15]}},a};
endmodule

module COMPARE(lt,gt,eq,data1,data2);

input signed [31:0] data1,data2;
output lt,gt,eq;

assign lt=data1<data2;
assign gt=data1>data2;
assign eq=data1==data2;

endmodule

module condition (
    output wire y,
    input wire [1:0] opcond,
    input wire [31:0] a
);

wire lt,gt,eq;
  
COMPARE cmp (lt,gt,eq,a,32'h00000000);

assign y =  (~opcond[1] & ~opcond[0] & gt) |
            (~opcond[1] & opcond[0] & lt)  |
            (opcond[1] & ~opcond[0] & eq)  |
            (opcond[1] & opcond[0] & 1'b0) ;

endmodule

module data_mem (
    input wire [9:0] inaddress,
    input wire clk,reset,
    input wire write,read,
    input wire [31:0] addr,
    input wire [31:0] din,
    output wire [31:0] dout,
    output wire [15:0] outdata
);
   
reg signed [31:0] dmem[0:1023];
  

  // initial unsorted values
 initial begin
   dmem[100] = 15;
 dmem[101] = 35;
 dmem[102] = 5;
 dmem[103] = 45;
 dmem[104] = 75;
 dmem[105] = 50;
 dmem[106] = 66;
 dmem[107] = 88;
 dmem[108] = 109;
 dmem[109] = 90;
 end
    
 
always @(posedge clk)
begin
     if(write == 1)
        dmem[addr[9:0]] <= din;
end

assign outdata= dmem[inaddress];
assign dout = (read)? dmem[addr[9:0]] : 32'bx;
endmodule


module instructionmem (
    input read,
    input wire [5:0] addr,
    output wire [31:0] I
);
   
reg [31:0] imem[0:63];
  
 
initial
begin

// bubble sort code
  
    imem[0]=32'h40010064;
    imem[1]=32'h68020000;
    imem[2]=32'h68030000;
    imem[3]=32'h4004000A;
    imem[4]=32'h4005000A;
    imem[5]=32'h68260000;
    imem[6]=32'h68270000;
    imem[7]=32'h44840001;
    imem[8]=32'h68030000;
    imem[9]=32'h44A50001;
    imem[10]=32'h00013801;
    imem[11]=32'h84E80000;
    imem[12]=32'h40E70001;
    imem[13]=32'h84E90000;
    imem[14]=32'h40630001;
    imem[15]=32'h01095002;
    imem[16]=32'hC54A0003;
    imem[17]=32'h88E80000;
    imem[18]=32'h88E9FFFF;
    imem[19]=32'h84E90000;
    imem[20]=32'h00655802;
    imem[21]=32'hCD6B0001;
    imem[22]=32'hC3FFFFF4;
    imem[23]=32'h40420001;
    imem[24]=32'h00446002;
    imem[25]=32'hCD8C0001;
    imem[26]=32'hC3FFFFED;
    imem[27]=32'hFFFFFFFF;

end


assign I = (read)? imem[addr] : 32'bx;
endmodule

module register (
input wire clk,reset,ld,
    input wire signed [31:0] din,
output reg signed [31:0] dout
);

    initial begin
            dout<=32'b0;
            end

always @(posedge clk)
    begin
       
         if(ld)
            dout<=din;
    end

endmodule


module reg_bank (
    input wire clk,write,reset,
    input wire  [4:0] sr1,sr2,dr,
    input wire signed [31:0] wrData,
    output wire signed[31:0] rData1,rData2
);
  reg signed[31:0] regfile[0:15];
integer k;

initial begin
regfile[0] <= 32'b0;
    regfile[1] <= 32'b0;
regfile[2] <= 32'b0;
regfile[3] <= 32'b0;
regfile[4] <= 32'b0;
regfile[5] <= 32'b0;
regfile[6] <= 32'b0;
regfile[7] <= 32'b0;
regfile[8] <= 32'b0;
regfile[9] <= 32'b0;
regfile[10] <= 32'b0;
regfile[11] <= 32'b0;
regfile[12] <= 32'b0;
regfile[13] <= 32'b0;
regfile[14] <= 32'b0;
regfile[15] <= 32'b0;


end
assign rData1 = regfile[sr1];
assign rData2 = regfile[sr2];

always @(posedge clk)

begin
if(write)
begin
if(dr == 3'b000)
regfile[dr] <= 32'b0;
else
regfile[dr] <= wrData;


end
end

   
endmodule


module PC (
input wire clk,reset,ld,
    input wire signed [31:0] din,
output reg signed [31:0] dout
);

    initial begin
            dout<=32'b0;
            end

always @(posedge clk)
    begin
       
         if(ld)
            dout<=din;
    end

endmodule

module NPC (
input wire clk,reset,ld,
    input wire signed [31:0] din,
output reg signed [31:0] dout
);

    initial begin
            dout<=32'b0;
            end

always @(posedge clk)
    begin
       
         if(ld)
            dout<=din;
    end

endmodule


module 	LMD (
input wire clk,reset,ld,
    input wire signed [31:0] din,
output reg signed [31:0] dout
);

    initial begin
            dout<=32'b0;
            end

always @(posedge clk)
    begin
       
         if(ld)
            dout<=din;
    end

endmodule






module datapath(
      input wire [9:0] inaddress,
    input wire clk,reset,
    
    input wire readim,ldir,ldnpc,
    input wire ldA,ldB,ldimm,
    input wire [1:0] opcond,
    input wire alusel1,alusel2,aluen,ldaluout,
    input wire [3:0] alufunc,
    input wire seldest,regwrite,writedmem,readdmem,ldlmd,
    input wire selwb,branch,ldpc,

    output wire [31:0] irout,aluout,
    output wire [31:0] writedata,
     output wire [15:0] outdata
    
);

// wires 
wire [31:0] pcout,npcout,Aout,Bout,immout,lmdout;
wire [31:0] instr,pcplus4,pcbranch,pcnext;
wire [31:0] Ain,Bin,imm;
wire [31:0] destadd;
wire [31:0] aluin1,aluin2,result;
wire [31:0] dmemout,memmuxout;


condition cond(selmem,opcond,Aout); // Condition for Branching
mux muxalu1(npcout,Aout,alusel1,aluin1); // Mux for ALU Input 1
mux muxalu2(Bout,immout,alusel2,aluin2); // Mux for ALU Input 2
  
  
PC pcreg(clk,reset,ldpc,pcnext,pcout); // Program Counter Register
instructionmem imem(readim,pcout[7:2],instr); // Instruction Memory
register irreg(clk,reset,ldir,instr,irout);
adder addpc(pcout,32'b00000100,pcplus4); // Adder for PC + 4
NPC npcreg(clk,reset,ldnpc,pcplus4,npcout); // Next Program Counter Register
adder bradd(npcout,{{4{irout[25]}}, irout[25:0], 2'b00},pcbranch); // Branch Address Calculation
mux muxbr(memmuxout,pcbranch,branch,pcnext); // Mux for Branching


mux destmux({27'b0,irout[15:11]},{27'b0,irout[20:16]},seldest,destadd); // Mux for Destination Address
reg_bank rbank(clk,regwrite,reset,irout[25:21],irout[20:16],destadd[4:0],writedata,Ain,Bin); // Register Bank
signext ext(instr[15:0],imm); // Sign Extend
register A(clk,reset,ldA,Ain,Aout); // Register A
register B(clk,reset,ldB,Bin,Bout); // Register B
register immreg(clk,reset,ldimm,imm,immout); // Immediate Register
ALU alu(aluin1,aluin2,alufunc,aluen,result); // Arithmetic Logic Unit
register aluoutreg(clk,reset,ldaluout,result,aluout); // ALU Output Register


data_mem dmem(inaddress,clk,reset,writedmem,readdmem,aluout,Bout,dmemout,outdata); // Data Memory
LMD lmdreg(clk,reset,ldlmd,dmemout,lmdout); // Load Memory Data Register
mux memmux(npcout,aluout,selmem,memmuxout); // Mux for Memory Access


mux wbmux(lmdout,aluout,selwb,writedata); // Mux for Writeback

endmodule


module Maincontrol (
    input wire clk,reset,
    input wire [31:0] irout,

    output wire readim,ldir,ldnpc,
    output wire ldA,ldB,ldimm,
    output wire [1:0] opcond,
    output wire alusel1,alusel2,aluen,ldaluout,
    output wire [3:0] alufunc,
    output wire seldest,regwrite,writedmem,readdmem,ldlmd,
    output wire selwb,branch,ldpc
);

parameter IF = 3'b000, ID = 3'b001, EX = 3'b010, MEM = 3'b011, WB = 3'b100, HLT = 3'b101;
reg [2:0] state;
reg [23:0] control_signals;
assign {readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,
        alufunc,seldest,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc} = control_signals;

always @(posedge clk, negedge reset) begin
   
    if(reset)
        control_signals <= 24'b0;
    else
        begin
            case (state)
                IF: begin
                    #1
                    if(irout == 32'hffffffff)
                    begin
                        control_signals <= 24'b0;
                        state <= HLT;
                    end
                    else
                        begin
                            control_signals[23:21] <= 3'b111;
                            control_signals[20:0]  <= 21'b0;
                            state <= ID;
                        end
                    end
                ID: begin
                    #1  
                        control_signals[20:18] <= 3'b111;
                        state <= EX;
                    end
                EX: begin
                    #1  
                        case (irout[31:30])
                            2'b00 :
                                begin
                                    control_signals[17:16] <= 2'b11;
                                    control_signals[15:13] <= 3'b101;
                                    case (irout[5:0])
                                        6'b000001 : control_signals[11:8] <= 4'b0000; // ADD
                                        6'b000010 : control_signals[11:8] <= 4'b0001; // SUB
                                        6'b000011 : control_signals[11:8] <= 4'b0010; // AND
                                        6'b000100 : control_signals[11:8] <= 4'b0011; // OR
                                        6'b000101 : control_signals[11:8] <= 4'b0100; // XOR
                                        6'b000110 : control_signals[11:8] <= 4'b0101; // NOT
                                        6'b000111 : control_signals[11:8] <= 4'b0110; // SLA
                                        6'b001000 : control_signals[11:8] <= 4'b0111; // SLL
                                        6'b001001 : control_signals[11:8] <= 4'b1000; // SRA
                                        6'b001010 : control_signals[11:8] <= 4'b1001; // SRL
                                    endcase
                                end
                            2'b01 :
                                begin
                                    control_signals[17:16] <= 2'b11;
                                    control_signals[15:13] <= 3'b111;
                                    case (irout[31:26])
                                        6'b010000 : control_signals[11:8] <= 4'b0000; // ADDI
                                        6'b010001 : control_signals[11:8] <= 4'b0001; // SUBI
                                        6'b010010 : control_signals[11:8] <= 4'b0010; // ANDI
                                        6'b010011 : control_signals[11:8] <= 4'b0011; // ORI
                                        6'b010100 : control_signals[11:8] <= 4'b0100; // XORI
                                        6'b010101 : control_signals[11:8] <= 4'b0101; // NOTI
                                        6'b010110 : control_signals[11:8] <= 4'b0110; // SLAI
                                        6'b010111 : control_signals[11:8] <= 4'b0111; // SLLI
                                        6'b011000 : control_signals[11:8] <= 4'b1000; // SRAI
                                        6'b011001 : control_signals[11:8] <= 4'b1001; // SRLI
                                        6'b011010 : control_signals[11:8] <= 4'b0000; // MOVE
                                    endcase    
                                end
                            2'b10 :
                                begin
                                    control_signals[17:16] <= 2'b11;
                                    control_signals[15:13] <= 3'b111;
                                    case (irout[31:26])
                                        6'b100001 : control_signals[11:8] <= 4'b0000; // LD
                                        6'b100010 : control_signals[11:8] <= 4'b0000; // ST
                                    endcase
                                end
                            2'b11 :
                                begin
                                    control_signals[15:13] <= 3'b011;
                                    case (irout[31:26])
                                        6'b110000 : {control_signals[17:16],control_signals[11:8]} <= {2'b11,4'b1010}; // BR
                                        6'b110001 : {control_signals[17:16],control_signals[11:8]} <= {2'b01,4'b1010}; // BMI
                                        6'b110010 : {control_signals[17:16],control_signals[11:8]} <= {2'b00,4'b1010}; // BPL
                                        6'b110011 : {control_signals[17:16],control_signals[11:8]} <= {2'b10,4'b1010};  // BZ
                                    endcase  
                                end
                        endcase
                        #2 control_signals[12] <= 1'b1;
                        state <= MEM;
                    end
                MEM:begin
                    #1
                        case (irout[31:26])
                            6'b100001 : control_signals[5:3] <= 3'b011; // LD
                            6'b100010 : control_signals[5:3] <= 3'b100; // ST
                        endcase
                        if(irout[31:26] == 6'b110000)
                            control_signals[1:0] <= 2'b11;
                        else
                            control_signals[1:0] <= 2'b01;
                        state <= WB;
                    end
                WB: begin
                    #1
                        case (irout[31:30])
                            2'b00 : {control_signals[7:6],control_signals[2]} <= 3'b011;
                            2'b01 : {control_signals[7:6],control_signals[2]} <= 3'b111;
                            2'b10 :
                                begin
                                    case (irout[31:26])
                                        6'b100001 : {control_signals[7:6],control_signals[2]} <= 3'b110; // LD
                                        6'b100010 : {control_signals[7:6],control_signals[2]} <= 3'b001; // ST
                                    endcase
                                end
                            2'b11 : {control_signals[7:6],control_signals[2]} <= 3'b000;
                            default: {control_signals[7:6],control_signals[2]} <= 3'b000;
                        endcase
                        state <= IF;
                    end
                HLT:begin
                        #1  control_signals <= 24'b0;
                            state <= HLT;
                    end
                default: state <= IF;
            endcase
        end
end
endmodule


module risc_processor (
    input wire clk,reset,
    input wire [9:0] inaddress,
//    output wire [31:0] writedata,
    output wire [15:0] outdata
    
);
wire readim,ldir,ldnpc;
wire ldA,ldB,ldimm;
wire [1:0] opcond;
wire alusel1,alusel2,aluen,ldaluout;
wire [3:0] alufunc;
wire seldest,regwrite,writedmem,readdmem,ldlmd;
wire selwb,branch,ldpc;
wire [31:0] irout,aluout;

wire [31:0] writedata;


datapath dpath(inaddress,clk,reset,readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,alufunc,seldest,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc,irout,aluout,writedata,outdata);
  
  
Maincontrol ctrl(clk,reset,irout,readim,ldir,ldnpc,ldA,ldB,ldimm,opcond,alusel1,alusel2,aluen,ldaluout,alufunc,seldest,regwrite,writedmem,readdmem,ldlmd,selwb,branch,ldpc);

endmodule

