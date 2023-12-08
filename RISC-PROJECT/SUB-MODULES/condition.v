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