//registro de "proposito general"
//bandera de load
//bandera de incremento
//puerto de entrada
//puerto de salida

module GP_Reg
#(
	parameter Reg_Width = 16
)
(	
	input wire clk,
	input wire [Reg_Width-1:0]Data_In,
	input wire Load,
	input wire Inc_Data_Value,
	output wire [Reg_Width-1:0]Data_Out, 
	input wire reset
);

reg [Reg_Width-1:0]Data;	
initial Data = {Reg_Width{1'b0}}; //inicializar en zeros

//always@(posedge Load or posedge Inc_Data_Value) begin
always@(posedge clk, negedge reset) begin
	if(!reset) begin
		Data <= 'b0;
	end else
	if(Load) begin
		Data <= Data_In;
	end
	else if(Inc_Data_Value) begin
		Data <= Data + 1'b1; 
	end
	else
		Data <= Data;
end

assign Data_Out = Data;


	
endmodule

