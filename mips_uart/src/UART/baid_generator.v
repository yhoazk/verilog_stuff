//modulo de baud rate generator para uart-tx

module baud_generator(input wire clk,
output wire baud_tick

);

reg [11:0] Baud_reg =12'b0; //registro contador 



assign baud_tick = (Baud_reg == 12'd2500)? 1'b1:1'b0;
always @(posedge clk, posedge baud_tick)begin
	if(baud_tick) begin
	$display("un 9600");
	Baud_reg = 12'b0;
	end
		
	else Baud_reg = Baud_reg + 12'b1;
end



endmodule
