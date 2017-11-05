//prueba de mips solo
module MipsTst (
	input 	clk,
			rst,
	input   [7:0] inputWord,
	input	read,
	output	[7:0] outputWord,
	output	write
);


MIPS_Multi MIPS0(
	.clk(clk),
	.rst_n(rst),
	.OutW(outputWord),
	.inputW(inputWord),
	.Wr_flgM(write),
	.Rd_flgM(read)
	);

endmodule //mipsTst

