/*


*/


module Rx_uart_v2(
input wire RxD,				//physical pin for receiving data
input wire clk,				//synchronization signal
input wire clr,				//Restart the small FSM 
input wire rdrf_clr,		//clear received data ready flag 
input wire prty_sel,		//parity selector
output reg rdrf,			//received data ready flag
output wire [7:0] rx_data, 	//datos recibidos
output reg PRTY_O			//parity out
);


parameter idle  = 3'b000;
parameter start = 3'b001;
parameter delay = 3'b010;
parameter shift = 3'b011;
parameter prty  = 3'b100;


reg [2:0] state = 3'b0;
reg [7:0] rxbuff = 7'b0;
reg [11:0] baud_count = 12'b0;
reg [3:0] bit_count =4'b0;
reg rdrf_set;
reg fe_set;
reg cclr;
reg cclr8;
reg rxload;
wire Wprty;
parameter bit_time = 12'h9C4;
parameter half_bit_time = 12'h4E2;
wire xr01, xr23,xr45,xr67;
wire xr_13, xr_47;
wire xr_top;

assign xr01 = rxbuff[0] ^ rxbuff[1];
assign xr23 = rxbuff[2] ^ rxbuff[3];
assign xr45 = rxbuff[4] ^ rxbuff[5];
assign xr67 = rxbuff[6] ^ rxbuff[7];

assign xr_13 = xr01 ^ xr23;
assign xr_47 = xr45 ^ xr67;

assign xr_top = xr_13 ^ xr_47;

assign Wprty = prty_sel ^ xr_top;
always @(posedge clk or posedge clr or posedge rdrf_clr)
begin
	if(clr == 'b1)
		begin
			state <= idle;
			rxbuff <= 'b0;
			baud_count <= 'b0;
			bit_count <= 'b0;
			rdrf <= 'b0;
			PRTY_O <= 'b0;
		end
	else
		begin
			if(rdrf_clr == 'b1)
				rdrf  <= 'b0;
			else
				case(state)
					idle:
						begin
							bit_count <= 'b0;
							baud_count <= 'b0;
							if(RxD == 'b1)
								state <= idle;
							else
								begin
									PRTY_O <= 'b0;
									state <= start;
								end
						end
					start:
						if(baud_count >=  half_bit_time)
							begin
								baud_count <= 'b0;
								state <= delay;
							end
						else
							begin 	
								baud_count <= baud_count + 1'b1;
								state <= start;
							end
					delay:
						if(baud_count >= bit_time)
							begin
								baud_count <= 'b0;
								if(bit_count < 'd8)
									state <= shift;
								else
									state <= prty;
							end
						else
							begin
								baud_count <= baud_count + 1'b1;
								state <= delay;
							end
					shift:
						begin
							rxbuff[7] <= RxD;
							rxbuff[6:0] <= rxbuff[7:1];
							//rxbuff <= {RxD, rxbuff[6:0]};
							
							bit_count <= bit_count + 1'b1;
							state <= delay;
						end
					prty:
						begin
							rdrf <= 1;
							if(RxD == Wprty) //la paridad calculada debe ser igual
								PRTY_O <= 0; //a-ok
							else
								PRTY_O <= 1;
								
							state <= idle;
						end
				endcase
		end
end

assign rx_data = rxbuff;
endmodule
									

								
								
								
								
								
								
