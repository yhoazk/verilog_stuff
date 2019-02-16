


module Data_Mem #(
	parameter 	DATA_WIDTH = 32,
					ADDR_WIDTH = 3,
					RAM_DEPTH = 1 << ADDR_WIDTH
)
(
input clk,
input [ADDR_WIDTH-1:0] Address,
input [DATA_WIDTH-1:0] WriteData, 
input MemRead_en,
input MemWrite_en,
output [DATA_WIDTH-1:0]ReadData
);          


reg [(DATA_WIDTH-1):0]   DataOut_reg;
reg [(DATA_WIDTH-1):0] memory [(RAM_DEPTH-1):0];
integer i;
initial begin

	for(i=3; i<=(2**ADDR_WIDTH)-1; i=i+1) begin
		memory[i] = {(DATA_WIDTH-1){1'b0}};
	end
	memory[0] = 32'hFEFA;
	memory[1] = 32'hFBFF;
	memory[2] = 32'hABFE;
end

//initial begin
// $readmemh("vectors.vec", mem);
//end

//initial begin 
//	mem[0] = 'h0;
//	mem[1] = 32'h00000FFA;
//	mem[2] = 32'h0000BFFA;
//end
//write
always @ (posedge clk)
begin
   if ( MemWrite_en ) begin
       memory[Address] <= WriteData;
   end
end

//read
always @ (Address, MemWrite_en, clk)
begin 
    
      DataOut_reg = memory[Address];
    
end

genvar j;
generate
 for(j=0; j < DATA_WIDTH; j=j+1) begin: block_generate_Ands
	and myAnd(ReadData[j],DataOut_reg[j], MemRead_en);
 end
endgenerate

endmodule // End of Module ram_sp_ar_aw

