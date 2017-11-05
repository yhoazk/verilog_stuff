//modulo TOP del transmisor de RS-232 @ 9600 con paridad seleccionable
//8 datos y 1 bit de stop
/*
Se compone de los modulos
	-baud generator
		un contador de modulo que cuando llega el valor de la 
		comparacion se resetea y envia un evento o tick
	-Loader-sender
		son un par de registros uno que contiene los registros
		a enviar en forma paralela cuando se activa el boton de 
		send estos datos pasan a un registro de corriemiento 
		paralelo-serie en donde se concatenan los bit de 
		paridad, start y stop.
		
		para el bit de paridad se usa una cascada de xor y un 
		mux que deja pasar la senial negada o as is para sele
		ccionar paridad par o impar, todo esto hasta que se presi
		ona el boton de send.
		
		el boton de send debe estar desactivado mientras se esten
		enviando los datos por el serial
		
*/

module uart_tx(
input wire clk, //reloj para generar el baud rate @24 MHz
input wire [7:0] SW_data, //los datos a enviar por serial
input wire Parity_sel, //selecciona el tipo de paridad,un SW
input wire  Send, //push button para activar el load y la FSM para enviar
output wire tx

);
wire mysendo;
wire BaudWire;
wire [7:0]Sw;
wire PushBtn;

//supply1 my_rst;
PushButton_Debouncer boton0(.async_sig(Send), .clk(BaudWire), .rise(PushBtn), .fall());
//PushButton_Debouncer mySend ( .clk(clk), .PB(Send), .PB_Out(mysendo));


//========================================================
baud_generator Baud_Tick(.clk(clk),.baud_tick(BaudWire) );
//tx_uart myUART(.baud_clk(BaudWire),  .Parity(Parity_sel), .Load_btn(~mysendo), .parallel_in(SW_data), .serial_out(tx));
tx_uart myUART(.baud_clk(BaudWire),  .Parity(Parity_sel), .Load_btn(Send), .parallel_in(SW_data), .serial_out(tx));
//========================================================


endmodule
