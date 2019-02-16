////MIPS_UNICICLO
////Toda la logica de controll debe ser combinacional
////las direcciones deben estar alineadas a word => divisibles entre 4
//
///*
//unidades del diseño:
//	PC.- Program counter.
//	SUM.- Sumador simple.
//	ALU.- -_-
//	MUX.- usar mux generico.
//	Unidad de extension de signo.- reproducir el MSb en los demas bites vacios
//	shift left.- usar el decodificador del proc. pasado
//	Reg's.- memorias asincronas con wr_en
//*/



//PC NO INCREMENTA
//MAPEAR LA MEMORIA DEL PC A 8 BITS


//extension de signo
// wire X[15:0], Y[31:0];
// description of X
// assign Y = { 16{X[31]}, X };


module MIPS_UNI (
	input wire 	clk, 
	input rst_n
	,output [2:0]aok_bit
);

wire [31:0] new_dir; // desde la salida del mux a la entrada del PC
wire [31:0] Instr;
wire [31:0] PC_Out;  //salida de datos del PC, de aqui se desglosa para la unidad de ctrl,
							//los dos apuntadores de reg, la direccion de escritura y la direccion
wire [31:0] PC_inc;  //salida del sumador de PC
wire [31:0] jmp_dir; //salida del calculador de salto sumador->mux
wire RegDst; 			//de la unidad de control al mux de entrada se reg_set
wire Branch; 			//de la unidad de control a la and del mux
wire MemRead;			//de la unidad de control a la memoria de datos
wire MemToReg;			//de la unidad de control al mux de salida de la memoria de datos
wire [1:0] ALU_Op;	//de la unidad de control a la unidad de contorl de la ALU
wire MemWrite; 		//de la unidad de control a la memoria de datos
wire ALU_Src;			//de la unidad de control a el mux de entrada a la ALU
wire RegWrite;			//de la unidad de control a el regset
wire [31:0] Sign_Ex; //de la unidad de extension de signo a el sumador de direcciones
wire [31:0]	RegOut1; //salida del RegSet;
wire [31:0]	RegOut2;	//salida del RegSet
wire [31:0] ALU_Out; //salida de la ALU
wire Zero; 				//salida de la ALU
wire [31:0]	DataRead;//SAlida de la memoria de Datos
wire [31:0]	RegWriteData; //salida del MUX del data memory 
wire [4:0]	MuxWriteReg;	//salida del mux de entrada a write del reg set
wire [31:0]	RegOrAddrs;	//salida del MUX de entrada a la alu
wire [2:0]	ALU_Sel; //de la salida del ALU_ctl al selector de la ALU
wire jmp;
supply1 VCC;
supply0 GND;
//Program Counter
GP_Reg #(.Reg_Width(32)) 
	PC 
	(
	.clk(clk),
	//.Data_In(new_dir),
	.reset(rst_n),
	.Data_In((jmp == 0)? new_dir : (Instr[25:0 ] << 2)),
	.Load(VCC),
	.Inc_Data_Value(GND),
	.Data_Out(PC_Out)

	);

////sumador para PC
AdderN 
#(	.DataABusWidth(32),
	.DataBBusWidth(32)
)
	PC_Incrmnt
(
	.OpA(PC_Out),
	.OpB(32'd4),
	.Res(PC_inc)
);


//sumador para instruccion
AdderN
#(	.DataABusWidth(32),
	.DataBBusWidth(32)
)
	Instr_Add
(
	.OpA(PC_inc),
	.OpB(Sign_Ex << 2),
	.Res(jmp_dir)
);

////Mux para input de ALU
//muxN_N Mux_ALU (
//		.DataA(RegOut2),
//		.DataB(Sign_Ex),
//		.Sel(ALU_Src),
//		.DataOut(RegOrAddrs)
//			);
Mux3ALU Mux_ALU(
	.RegData2(RegOut2),
	.SignExt(Sign_Ex),
	.Shamt(Instr[10:6]),
	.Sel({(|Instr[10:6]), ALU_Src}),
	.OutMux(RegOrAddrs)
	);

////MUX para salida de memoria de datos
muxN_N Mux_DataMem (
		.DataA(ALU_Out),
		.DataB(DataRead),
		.Sel(MemToReg),
		.DataOut(RegWriteData)
			);
////MUX para salida de sumador de saltos
muxN_N Mux_InstOffset (
		.DataA(PC_inc),
		.DataB(jmp_dir),
		.Sel(Zero & Branch),
		.DataOut(new_dir)
			);
			
////MUX para entrada a set de registros
muxN_N #(.BUSWIDTH(5))
Mux_RegSet (
		.DataA(Instr[20:16]),
		.DataB(Instr[15:11]),
		.Sel(RegDst),
		.DataOut(MuxWriteReg)
		);
////ALU
ALU #(
	.Bus_Width(32)
	)
ALU_UNI
( 
.DataA(RegOut1),
.DataB(RegOrAddrs),
.Inst_Sel(ALU_Sel),
.Zero(Zero), 
.Data_Out(ALU_Out)
);
////extension de signo
SignExtend
#(
	.InBusWidth(16), 				//ancho del bus de entrada	
	.OutBusWidth(32)				//ancho del bus de salida
)
	Sign_Extend
(	
	.In_Data(Instr[15:0]),
	.Out_Data(Sign_Ex)
);

////Register SET
DualPortMem
#( .DATA_WIDTH(32), .ADDR_WIDTH(5))
	RegSet
(
	.Addr_a(Instr[25:21]),
	.Addr_b(Instr[20:16]), 			//read index
	.WrAddr(MuxWriteReg), 							//write index
	.we_en(RegWrite),
	.clk(clk),								//control signals	
	.WrDta(RegWriteData),							//write data
	.Q_a(RegOut1),
	.Q_b(RegOut2)								//out data
);


////Memoria de programa
memoria	InstrMem
	(	
	.address(PC_Out[5:0])     , //in 6 bit
	.data(Instr)         //data_out 32 bit
	); 
////memoria de datos
Data_Mem #(
	.DATA_WIDTH(32),
	.ADDR_WIDTH(3)
)
	DataMemory
(
.clk(clk),
.Address(ALU_Out[4:0]),
.WriteData(RegOut2), 
.MemRead_en(MemRead),
.MemWrite_en(MemWrite),
.ReadData(DataRead)
);          

//unidad de control
Cntrl_Unit CntrlUnit
(
	.OpCode(Instr[31:26]),
	.RegDest(RegDst),
	.Branch(Branch),
	.MemRead(MemRead),
	.MemToReg(MemToReg),
	.ALUOp(ALU_Op), //distingue solo entre instrucciones de tipo reg, load/store y branch
	.MemWrite(MemWrite),
	.ALUSrc(ALU_Src),
	.RegWrite(RegWrite),
	.jmp(jmp) /////////////////////////////////////////////////////////////////////////////////////
);
//ALU_Ctrl
ALU_Cntrl ALUCntrl(
	.ALU_Op(ALU_Op),
	.FnctField(Instr[5:0]),
	.ALU_Cntl(ALU_Sel)
 );
 assign aok_bit = ALU_Sel;
////shift left 2 para saltos
//
//
//
endmodule //MIPS_UNI

