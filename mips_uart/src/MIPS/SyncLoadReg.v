//Nuevo modulo simplificado para el PC y demas registros simples de carga 
//sincrona

module SyncLoadReg #
(
	parameter BUS_WIDTH = 32
)
(
	input clk,
	input rst_n,
	input [(BUS_WIDTH-1):0] data_in,
	output [(BUS_WIDTH-1):0] data_out	
);
reg [(BUS_WIDTH-1):0]Data;
always @(negedge clk or negedge rst_n) begin
	if(!rst_n) begin
		Data <= {BUS_WIDTH{1'b0}}; //reset
	end else begin
		Data <= data_in;
	end
end
assign data_out = Data;
endmodule //SyncLoadReg