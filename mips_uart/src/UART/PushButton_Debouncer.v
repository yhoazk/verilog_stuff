//button debouncer

/*
maquina de estados el estado idle esta en espera de pb=activo y empieza a contar,
si se llega a el valor maximo del registro sin que exista un solo cero se toma
como boton activo.

para indicar que hubo un botonazo se levanta un reg Debounced_PB
durante cierto numero de clk's definidos por el ancho de un registro
bandera, al desbordarse este pasa a el estado idle de nuevo para esperar
otro boton.

es necesario un reset asincrono para los dos contadores

*/


//module PushButton_Debouncer(input wire clk, //senial de 24MHz
//									input wire PB, //entrada con asyncrona y con rebotes
//								output reg PB_Out	//salida de un pulso despues de estabilzar el boton
// );
// 
// parameter Debounce_cntr_width = 25; //ancho del contador de rebotes al desbordarse pasa a otro contador
// parameter Flag_cntr_width = 8;
// reg [Debounce_cntr_width-1:0] Debounce_cntr= 'b0;
// reg [Flag_cntr_width-1:0] Flag_cntr = 'b0;
// 
// reg var_st; //variable de estado
// 
// 
// always@(posedge clk)
// begin
//	case(var_st)
//		1'b0:
//			if(Debounce_cntr < 25'b1111_1111_1111_1111_1111_1110_1 && ~PB)begin //boton activo en bajo
//				Debounce_cntr <= Debounce_cntr +1'b1;
//				PB_Out <= 1'b0;			
//			end else begin
//			var_st = 1'b1; //cambio al sigiente estado
//			Debounce_cntr  <= 'b0; //clear cntr_reg
//			end
//		
//		1'b1:
//			if(Flag_cntr < 8'b1111_1111)begin
//				Flag_cntr <= Flag_cntr + 1'b1;
//				PB_Out <= 1'b1;
//			end else begin
//				Flag_cntr <= 'b0;
//				PB_Out <= 1'b0;
//				var_st = 1'b1;
//			end
//		default: var_st = 1'b0;
//	endcase 
// end 
//endmodule
//



//detector de flancos
module PushButton_Debouncer (input async_sig,
                    input clk,
                    output reg rise,
                    output reg fall);

  reg [1:3] resync;

  always @(posedge clk)
  begin
    // detect rising and falling edges.
    rise <= resync[2] & !resync[3];
    fall <= resync[3] & !resync[2];
    // update history shifter.
    resync <= {async_sig , resync[1:2]};
  end

endmodule



//module PushButton_Debouncer (reset, clk, noisy, clean);
//   input reset, clk, noisy;
//   output clean;
//
//   parameter NDELAY = 650000;
//   parameter NBITS = 20;
//
//   reg [NBITS-1:0] count;
//   reg xnew, clean;
//
//   always @(posedge clk)
//     if (reset) begin xnew <= noisy; clean <= noisy; count <= 0; end
//     else if (noisy != xnew) begin xnew <= noisy; count <= 0; end
//     else if (count == NDELAY) clean <= xnew;
//     else count <= count+1'b1;
//
//endmodule


/*
module PushButton_Debouncer (noisy,clk_1KHz,debounced);

input wire clk_1KHz, noisy;
output reg debounced;

reg [37:0] regi;

//reg: wait for stable
always @ (posedge clk_1KHz) 
begin
regi[37:0] <= {regi[36:0],noisy}; //shift register
if(regi[37:0] == 38'b0)
  debounced <= 1'b0;
else if(regi[37:0] == 38'b1)
  debounced <= 1'b1;
else debounced <= debounced;
end

endmodule
*/
/*
module PushButton_Debouncer(input clk, input PB, output Debounced_PB);

reg [15:0] Active_cntr = 16'b0; //contador que se incrementa mientras pb este presionado
reg [4:0] On_flag = 5'b0; //contador que corresponde a el tiempo en que la senial de presionado estara en alto
reg[1:0] State_var=2'b01;  //variable de estado
reg Button= 1'b0;
wire Active_rst, on_rst;
assign Debounced_PB = Button;
assign Active_rst = &Active_cntr;
assign on_rst = &On_flag;


always@(posedge clk or negedge Active_rst or negedge on_rst)begin
	case(State_var)
	2'b01:
	if(~PB && ~Active_rst) begin
		Active_cntr <= Active_cntr +1'b1;
	end
	else begin
		Active_cntr <= 16'b0;
	end
	
	
	2'b10:
	if(~on_rst)begin
		On_flag <= On_flag + 1'b1;
		Button <= 1'b1;
	end
	else begin
	On_flag <= 5'b0;
	Button <= 1'b0;
	end
	
	
	default: State_var <= 2'b01;
	
	
	endcase
end

endmodule


*/
/*
module PushButton_Debouncer(clk, PB, PB_state, PB_up, PB_down);
input clk;  // "clk" is the clock
input PB;  // "PB" is the glitched, asynchronous, active low push-button signal

output PB_state;  // 1 while the push-button is active (down)
output PB_down;  // 1 when the push-button goes down (just pushed)
output PB_up;  // 1 when the push-button goes up (just released)

// First use two flipflops to synchronize the PB signal the "clk" clock domain
reg PB_sync_0;  always @(posedge clk) PB_sync_0 <= ~PB;  // invert PB to make PB_sync_0 active high
reg PB_sync_1;  always @(posedge clk) PB_sync_1 <= PB_sync_0;

// Next declare a 16-bits counter
reg [24:0] PB_cnt;

// When the push-button is pushed or released, we increment the counter
// The counter has to be maxed out before we decide that the push-button state has changed

reg PB_state;  // state of the push-button (0 when up, 1 when down)
wire PB_idle = (PB_state==PB_sync_1);
wire PB_cnt_max = &PB_cnt;	// true when all bits of PB_cnt are 1's

always @(posedge clk)
if(PB_idle)begin
    PB_cnt <= 0;  // nothing's going on
	 PB_state <= 0;
	 end
else
begin
    PB_cnt <= PB_cnt + 1;  // something's going on, increment the counter
    if(PB_cnt_max) PB_state <= ~PB_state;  // if the counter is maxed out, PB changed!
end

wire PB_down = ~PB_state & ~PB_idle & PB_cnt_max;  // true for one clock cycle when we detect that PB went down
wire PB_up   =  PB_state & ~PB_idle & PB_cnt_max;  // true for one clock cycle when we detect that PB went up

endmodule

*/
