//project Wrapper
module sync(input clk,in, output out); 
	reg [1:0]syncrs=2'b00;
	always@(posedge clk) begin
		syncrs[0] <= in;
		syncrs[1] <= syncrs[0];
	end
	assign out = syncrs[1];
endmodule
//////////////////////////////////////////////////////////////////
module Calc (
	input wire	clk_T,		//from 24 MHz clk
				clr_T,		//Asynchronous reset
				RX,			//DB9 pin
				Prty_Sel, 	//switch 
	output wire	TX,			//DB9 pin
				Frame
				
	);

	wire SendSign; 		//signal to activate the transmition
	wire [7:0] Data2Send;
	wire [7:0] DataReceived;
	wire DataReceivedFlag;
	wire SyncRx;
// hacer un sincronizador para que la entrada no se optimize


sync asynch(	
		.clk(clk_T),
		.in(RX),
		.out(SyncRx)
	); 
	
	

UART
	Top_UART
(
.clk_24mhz(clk_T), 		//pin a CLk_25MHz
.tx_data(Data2Send),   	//Datos a enviar [7:0]
.parity(Prty_Sel),		//selector de paridad 
.send(),		//activa el envio
.tx(TX),				//Pin para enviar datos

.clr(clr_T),			//Limpia el reg de los datos recividos
.rdrf_clr(SendSign),			//bandera para comenzar otra recepcion
.rdrf(DataReceivedFlag),//received data ready flag
.rx_data(DataReceived),	//datos recividos 8 b
.PRTY(Frame),			//flag de frame error
.rx(SyncRx)				//pin de recepcion
);


MIPS_Multi Top_MIPS(
	.clk(clk_T), 
	.rst_n(clr_T),
	.OutW(Data2Send),
	.inputW(DataReceived),
	.Wr_flgM(SendSign), 
	.Rd_flgM(DataReceivedFlag)
);


endmodule //Calc