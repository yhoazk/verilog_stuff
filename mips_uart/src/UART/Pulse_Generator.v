//pulse generator
//genera un pulso de corta duracion para probar el sistema, 
//esta seria como la senial de send


module Pulse_Generator(input wire clk, output reg Pulse);

parameter bit_wide = 25;
reg rst = 1'b0;
reg [bit_wide-1:0] count_reg = 'b0;

wire rst_signal;


assign rst_signal = (count_reg == 25'b1111_1111_1111_1111_1111_1111_1); //supuestamente esta senial debe ser 1 solo cuando
										//todos los bit del registro son 1
always@(posedge clk or posedge rst_signal)
begin 
if(rst_signal) begin
	$display("pasando a alto");
	count_reg <= 'b0;
	Pulse <= 1'b1;
end else
begin
	count_reg <= count_reg +1'b1;
	Pulse <= 1'b0;
end

end

endmodule
