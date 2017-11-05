//TOP UART
/*
transmisor y receptor
*/

module UART(
input wire clk_24mhz, 			//pin a CLk_25MHz
input wire [7:0]tx_data,   		//Datos a enviar
input wire parity,				//selector de paridad 
input wire send,				//activa el envio
output wire tx,					//Pin para enviar datos

input  wire clr,				//Limpia el reg de los datos recividos
input  wire rdrf_clr,			//bandera para comenzar otra recepcion
output wire rdrf,				//
output wire [7:0]rx_data,		//datos recividos 8 b
output wire PRTY,				//flag de frame error
input  wire rx					//pin de recepcion
);



 uart_tx Transmisor( .clk(clk_24mhz), .SW_data(tx_data), .Parity_sel(parity), .Send(send), .tx(tx));

 Rx_uart_v2 Receptor(.RxD(rx), .clk(clk_24mhz), .clr(clr), .prty_sel(parity), .rdrf_clr(~rdrf_clr), .rdrf(rdrf), .rx_data(rx_data), .PRTY_O(PRTY));


endmodule
