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