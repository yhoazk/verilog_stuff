//memoria combinacional de doble puerto de salida
//un puerto para escritura y wr_en


module DualPortMem
#(parameter DATA_WIDTH=32, parameter ADDR_WIDTH=5)
(
	input [(ADDR_WIDTH-1):0] Addr_a, Addr_b, 			//read index
	input [(ADDR_WIDTH-1):0] WrAddr, 					//write index
	input we_en, clk,											//control signals	
	input [(DATA_WIDTH-1):0] WrDta,						//write data
	//output wire [(DATA_WIDTH-1):0] Read_reg,		//registro para mostrar datos en led
	output reg [(DATA_WIDTH-1):0] Q_a, Q_b			//out data
);

reg [(DATA_WIDTH-1):0] Mem [(2**ADDR_WIDTH)-1: 0];
/*only 4 tst*/
integer i;
initial begin

	for(i=4; i<=(2**ADDR_WIDTH)-1; i=i+1) begin
		Mem[i] = {(DATA_WIDTH-1){1'b0}};
	end
	Mem[0] = 32'hA;
	Mem[1] = 32'h6;
	Mem[2] = 32'h6;
	Mem[3] = 32'h2;
end



always @(posedge clk) begin
	if(we_en  && WrAddr != 5'b0_0000 && WrAddr != 5'b1_1110)
		Mem[WrAddr] <= WrDta;
end

always@(*) begin
	case(Addr_a)
	5'b0_0000:
		Q_a = {DATA_WIDTH{1'b0}};
	5'b1_1111:
		Q_a = {DATA_WIDTH{1'b0}};
	default:
	Q_a = Mem[Addr_a];
	endcase
end

always@(*) begin
	case(Addr_b)
	5'b0_0000:
		Q_b = {DATA_WIDTH{1'b0}};
	5'b1_1111:
		Q_b = {DATA_WIDTH{1'b0}};
	default:
	Q_b = Mem[Addr_b];
	endcase
end
//assign Read_reg = Mem[1]; //registro 1 de la memoria

endmodule

