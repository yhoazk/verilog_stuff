//modulo de aplicacion para el uart_tx

module tx_uart(
input wire baud_clk,
input wire Load_btn,
input wire Parity,
input wire [7:0]parallel_in,
output wire serial_out
//output wire [10:0]piso_view
);



reg [7:0]work_reg=8'b0; //almacena los valores de los SW
reg [10:0]piso= 11'b0;
//reg Sending = 1'b0; //se pone a 1 cuando se estan enviando bit para evitar overruns
//assign piso_view = piso;
always@(*)begin
	work_reg = parallel_in;
//	Sending = Load_btn;
end

//================================================
			/*cadena de Xor's*/
//================================================
wire xr12, xr34, xr56, xr78; //primera fila de xors
wire xr42, xr86; //segunda fila de xors
wire xr8, xr4; //tercera fila de xors
reg parity_out; //salida del la cadena de xors

assign xr12 = work_reg[0]^work_reg[1];
assign xr34 = work_reg[2]^work_reg[3];
assign xr56 = work_reg[4]^work_reg[5];
assign xr78 = work_reg[6]^work_reg[7];

assign xr42 = xr12^xr34;
assign xr86 = xr56^xr78;

always @(*) parity_out = (xr42^xr86)^Parity;

//================================================
/*envio con shift reg*/
//================================================

reg [1:0] State = 2'b00; //variable de estado
reg [4:0] Cntr= 4'b0000; //contador para el bit actual

always@(posedge baud_clk)begin 

case(State)

	2'b00:
	if(Load_btn) begin 
		$display("Cargando el byte en el piso");
		piso[0] <= 1'b0;
		piso[8:1] <= work_reg;
		piso[9] <= parity_out;
		piso[10] <= 1'b1;
		State <= 2'b01;
	end else  begin
		$display("no hay botonazo");
		piso <= 11'b1;
		State <= 2'b00;
	end
	
	2'b01:
	if(Cntr <= 4'd11) begin
		$display("haciendo shift No=%d", Cntr);
		//piso = piso >> 1'b1;
		piso <= {1'b1, piso[10:1]};
		Cntr <= Cntr + 1'b1;
		State <= 2'b01;
	end else begin
		$display("clear shift EOT");
		
		Cntr <= 4'b0;
		State <= 2'b00;
	end
endcase

end

assign serial_out = piso[0];

endmodule
