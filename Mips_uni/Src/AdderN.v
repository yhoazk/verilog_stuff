//sumador de ancho parmetrizable
module AdderN
#(
	parameter 	DataABusWidth = 32,
					DataBBusWidth = 32
)
(
	input wire	[DataABusWidth-1:0]OpA,
	input wire	[DataBBusWidth-1:0]OpB,
	output	wire [DataABusWidth:0] Res
);

assign Res = OpA + OpB;
endmodule //<nombre>

