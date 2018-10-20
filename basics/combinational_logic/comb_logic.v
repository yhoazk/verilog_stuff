module comb_logic(
    // By default wires unless reg is specified
    input [W-1:0]a,
    input [W-1:0]b,
    output [W-1:0] out_and,
    output [W-1:0] out_or,
    output [W-1:0] out_not,
    output [W-1:0] out_xor
);
//wire a,b,x;
parameter W = 8; // Bus width

assign out_and = a & b; // bitwise and
assign out_or = a | b; // bitwise or
assign out_xor = a ^ b; // bitwise xor
assign out_not = ~a; // bitwise not


endmodule