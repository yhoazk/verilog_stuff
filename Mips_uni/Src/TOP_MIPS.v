//modulo super TOP de MIPS

module TOP_MIPS(input clk, rst, output reg [2:0]stat);
wire [2:0]or_w;
 MIPS_UNI myMIPS(
	.clk(clk),
	.rst_n(rst),
	.aok_bit(or_w)
);
 
always@(*) begin
	stat = |or_w;
end
endmodule //TOP_MIPS
