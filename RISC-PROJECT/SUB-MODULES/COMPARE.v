module COMPARE(lt,gt,eq,data1,data2);

input signed [31:0] data1,data2;
output lt,gt,eq;

assign lt=data1<data2;
assign gt=data1>data2;
assign eq=data1==data2;

endmodule 