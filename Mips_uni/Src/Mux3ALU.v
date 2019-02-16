//mux especial para la entrada de la ALU, con tres entradas

module Mux3ALU(
input [31:0] RegData2,
input [31:0] SignExt,
input [4:0] Shamt,
input [1:0] Sel,
output [31:0] OutMux
);
reg [31:0] OutMux_reg;
always@(*) begin
	case(Sel)
		2'b00: begin
			OutMux_reg = RegData2;
		end
		2'b01: begin
			OutMux_reg = SignExt;
		end
		2'b10: begin
			OutMux_reg = Shamt;
		end
		default: begin
			OutMux_reg = RegData2;
		end
	endcase	
end
assign OutMux = OutMux_reg;
endmodule //Mux3ALU
