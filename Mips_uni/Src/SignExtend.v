//unidad de extension de signo

module SignExtend
#(
	parameter 	InBusWidth = 16, 				//ancho del bus de entrada	
					OutBusWidth = 32				//ancho del bus de salida
)
(	
	input wire [InBusWidth-1:0] In_Data,
	output wire [OutBusWidth-1:0] Out_Data
);

assign Out_Data = { {InBusWidth{ In_Data[(InBusWidth - 1)] }}, In_Data};


endmodule //SignExtend	
