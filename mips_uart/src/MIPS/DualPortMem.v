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
	output reg [(DATA_WIDTH-1):0] Q_a, Q_b,			//out data
	output wire  [7:0] Read,  //processed data
	input  [7:0] Write,	 //data to process
	input RD_Flg,		//received data flag
	output wire Wr_Flg		//Data to send
);


reg [(DATA_WIDTH-1):0] Mem [(2**ADDR_WIDTH)-1: 0];
	
/*only 4 tst*/
integer i;
initial begin

	for(i=0; i<=(2**ADDR_WIDTH)-1; i=i+1) begin
		//Mem[i] = {(DATA_WIDTH-1){1'b0}};
		Mem[i] = i;
	end
	//Mem[0] = 32'hA;
	Mem[1] = 32'h2;
	Mem[2] = 32'hAA;
	Mem[3] = 32'h2;
	Mem[4] = 32'hBB;
	Mem[5] = 32'h2;
	Mem[30] = 32'hBFFFFFFF;
	Mem[31] = 32'h0;
end

//write info form UART
//Mem[31] write only
//always @(negedge clk)begin
//	Mem[31] <= {{23{1'b0}}, RD_Flg, Write};
//end
//read info from UART
//Mem[30] read only

reg Wr_FlgReg;
reg [7:0] ReadReg;
assign Read = ReadReg;
assign Wr_Flg = Wr_FlgReg;
// wire wr_encond;
// assign wr_encond = (WrAddr == 5'b1_1110)? 1'b0:we_en;
wire [(ADDR_WIDTH-1):0] AddrWrReg;

assign AddrWrReg = (WrAddr == 5'b1_1110 )? 5'b0_0000 : WrAddr;


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


//always @(posedge clk) begin
//write always
always @(negedge clk) begin
	{Wr_FlgReg, ReadReg} <= Mem[30][8:0];//ve que a Mem[30] no se le escribira y lo elimina por que dice estar conectado a VCCo GND
	
	if(we_en  && WrAddr != 5'b0_0000 && WrAddr != 5'b1_1110 ) begin
	//if(we_en  && AddrWrReg != 5'b0_0000  ) begin
		Mem[AddrWrReg] <= WrDta;
	end
	else if(RD_Flg == 1'b1) begin		
		Mem[31] <= {{23{1'b0}}, RD_Flg, Write};
	end
	else if(WrAddr == 5'b1_1110)begin
		Mem[30] <='b0;
	end
	
end


//assign Read_reg = Mem[1]; //registro 1 de la memoria

endmodule
