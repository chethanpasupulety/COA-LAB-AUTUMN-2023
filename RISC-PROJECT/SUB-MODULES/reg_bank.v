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