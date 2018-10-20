


module calc(
    input clk,
    input rst,
    input rx,
    output tx,
    output [7:0] leds    
    );

wire [7:0] inWord;
wire [7:0] outWord;
wire outFlag;
mips eMe (
    .clk(clk),
    .rst(rst),
    .outWord(outWord), //salida para enviar
    .outFlag(outFlag), //bandera para iniciar tx
    .inWord(inWord), // datos a procesar
    .inFlag(received_byte_flag) //bandera que indica dato recibido
    );

/*
poner un FF set-reset para el envio - recepcion de datos
*/

reg received_byte_flag;


always@(posedge clk) 
   if(rst)
      received_byte_flag <= 1'b0;
   else if(inFlag)
      received_byte_flag <= 1'b1;
   else if(outFlag)
      received_byte_flag <= 1'b0;
   else
      received_byte_flag <= received_byte_flag;
   
uart_echo instance_name (
    .clk(clk), 
    .rst(rst), 
    .tx(tx), 
    .rx(rx), 
    .received_data(inWord), 
    .received_flag(inFlag), 
    .clear_rec_flag(outFlag), 
    .data2send(outWord), 
    .send_data(outFlag)
    );



endmodule
