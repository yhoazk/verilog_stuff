//modulo para el mux parametrizable

module muxN_N
#(
	parameter BUSWIDTH = 32
	)
 (
		input wire [(BUSWIDTH-1):0] DataA,
		input wire [(BUSWIDTH-1):0]	DataB,
		input wire Sel,
		output reg [(BUSWIDTH-1):0]	DataOut
			);
			
always@(Sel, DataA, DataB) begin 
	case(Sel)
	1'b0: 
		DataOut = DataA;
	1'b1:
		DataOut = DataB;
	endcase
end

endmodule 