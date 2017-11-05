module MIPS_Multi(
	input clk,
	input rst_n,
	output [7:0]OutW,
	input [7:0] inputW,
	output Wr_flgM,
	input Rd_flgM
	);


/*
	interconexion wires
*/
wire [31:0] PC_out; 	//Program counter output
wire [31:0] Adr; 		//salida del mux para la memoria de dato-programa
wire [31:0] ID_Data; //salida de la memoria de dato-instruccion
wire [31:0] Instr;	//salida del registro EN que guarda las instrucciones
wire [31:0] ALUOut;  //salida del registro  que guarda el ALuResult
wire [31:0] ALUResult; //salida inmediata de la ALU
wire [31:0] PCSrcOut;//salida del mux  de pcsrc
wire [31:0] SrcA;		//salida del Mux  ALUSrcA
wire [31:0] SrcB;		//salida del Mux  ALUSrcB
wire [31:0] A;			//salida del registro doble
wire [31:0] B;			//salida del registro doble
wire [31:0] RD1;		//salida del registro file
wire [31:0] RD2;		//salida del registro file
wire [31:0] Data;		//salida del registro de datos
wire [31:0] SignImn;	//salida de la extension de signo
wire [4:0] Mem2RegMux; //salida del mux de direcicion de esccrutura de la meme de reg
wire [31:0] RegDstMux;//salida del mux que controla la senial rgdst y apunta al registo a escribir


//wires de control
wire 	Zero,  			//flag de la ALU
		PCEn,
		IorD, //xxx
		MemWrite,
		IRWrite,
		RegDst,
		MemToReg,
		RegWrite,
		ALUSrcA,
		Branch, //xxx
		PCWrite; //
		
wire [1:0] ALUSrcB;
wire [1:0] PCSrc; //xxx
wire [2:0] ALUControl;

/*
	unidad de control
*/

assign PCEn = PCWrite | ( Branch & Zero);
///////////////////////////////////
Cntrl_FSM  Cntrl
(
	.clk(clk),
	.rst(rst_n),
	.OpCode(Instr[31:26]), //5 in
	.Function(Instr[5:0]), //5 in
	.PCWrite(PCWrite), //1's
	.Branch_Cntrl(Branch),
	.PCSrc(PCSrc), //2 out
	.ALUCntrl(ALUControl), //3 out
	.ALUSrcA(ALUSrcA), //1
	.ALUSrcB(ALUSrcB), //2 out
	.RegWrite(RegWrite),
	.MemToReg(MemToReg),
	.RegDst(RegDst),
	.IRWrite(IRWrite),
	.MemWrite(MemWrite),
	.IorD(IorD)
	
);

SignExtend
#(
 	.InBusWidth (16), 				//ancho del bus de entrada	
	.OutBusWidth (32)				//ancho del bus de salida
)
 Sign_Ext
(	
	.In_Data(Instr[15:0]),
	.Out_Data(SignImn)
);


/*
	sync registers instantiation
*/
//program counter
///////////////////////////////////
SyncLoadRegEn PC (
	.clk(clk),
	.rst_n(rst_n),
	.Load_en(PCEn),
	.data_in(PCSrcOut),
	.data_out(PC_out)	
);

//instruction register
//////////////////////////////////////
SyncLoadRegEn InstrReg (
	.clk(clk),
	.rst_n(rst_n),
	.Load_en(IRWrite),
	.data_in(ID_Data),
	.data_out(Instr)	
);


//Data  register
//////////////////////////////////////
SyncLoadReg DataReg (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(ID_Data),
	.data_out(Data)	
);

//ALU out reg
//////////////////////////////////////
SyncLoadReg ALUOutReg (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(ALUResult),
	.data_out(ALUOut)	
);

//Out reg  RD1A
//////////////////////////////////////
SyncLoadReg RD1A (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(RD1),
	.data_out(A)	
);


//Out reg RD2B
//////////////////////////////////////
SyncLoadReg RD2B (
	.clk(clk),
	.rst_n(rst_n),
	.data_in(RD2),
	.data_out(B)	
);
//memoria de programa y de datos
///////////////////////////////////////
Data_Mem IDMem (
	.clk(clk),
	.Address(Adr[3:0]),
	.WriteData(B), 
	.MemWrite_en(MemWrite),
	.ReadData(ID_Data)
); 
//Register File
//////////////////////////////////////
DualPortMem RegFile

(
	.Addr_a(Instr[25:21]), 
	.Addr_b(Instr[20:16]),	//read index
	.WrAddr(Mem2RegMux),	//write index
	.we_en(RegWrite), 
	.clk(clk),		//control signals	
	.WrDta(RegDstMux),	//write data
	.Q_a(RD1), 
	.Q_b(RD2),		//out data
	.Read(OutW),	//datos procesados por el mips
	.Write(inputW),		//datos a procesar por el mips
	.RD_Flg(Rd_flgM),		//bandera indicando nuevos datos
	.Wr_Flg(Wr_flgM)		//bandera para iniciar la transmision de los datos
	
);


/********************ALU*************************/
ALU 
//////////////////////////////////////
#(
	.Bus_Width(32)
)
MIPS_ALU
( 
	.DataA(SrcA), //32 in
	.DataB(SrcB), //32 in
	.Inst_Sel(ALUControl),				//3 in
	.Zero(Zero), 					//1 out
	.Data_Out(ALUResult)	//32 out
);

/***********************MUX's********************/
 muxN_N InIDMem  //mux 2-1
 //////////////////////////////////////
 (
		.DataA(PC_out),
		.DataB(ALUOut),
		.Sel(IorD),
		.DataOut(Adr)
	);
	
 muxN_N //mux 2-1
 //////////////////////////////////////
 #(
	.BUSWIDTH (5)
	)
	 InRegFileA3 
 (
		.DataA(Instr[20:16]),
		.DataB(Instr[15:11]),
		.Sel(RegDst),
		.DataOut(Mem2RegMux)
	);

muxN_N InRegFileWD3  //mux 2-1
//////////////////////////////////////
 (
		.DataA(ALUOut),
		.DataB(Data),
		.Sel(MemToReg),
		.DataOut(RegDstMux)
	);

muxN_N ALUSrcAMux  //mux 2-1
//////////////////////////////////////
 (
		.DataA(PC_out),
		.DataB(A),
		.Sel(ALUSrcA),
		.DataOut(SrcA)
	);
	
Mux4 MuxSrcB (
//////////////////////////////////////
._00(B),
._01(32'h00_00_00_01),
._10(SignImn),
._11(SignImn ),
.Sel(ALUSrcB),
.OutMux(SrcB)
);
wire [31:0]PC_jump = {PC_out[31:26], Instr[25:0]};
//////////////////////////////////////
Mux4 MuxPCSrc (
._00(ALUResult),
._01(ALUOut),
._10(PC_jump),
._11(32'b0),
.Sel(PCSrc),
.OutMux(PCSrcOut)
);




endmodule //MIPS_Multi