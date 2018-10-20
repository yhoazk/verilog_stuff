`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    01:59:57 11/23/2012
// Design Name:
// Module Name:    mips
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:0
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module mips(
    input clk,
    input rst,
    output [7:0] outWord,
    output outFlag,
    input [7:0] inWord
    ,input inFlag
    );

parameter RAM_WIDTH = 32;
parameter RAM_ADDR_BITS = 5;
parameter BUS_WIDTH = 32;

localparam  FETCH       = 4'd0,
            DECODE      = 4'd1,
            MEMADR      = 4'd2,
            MEMREAD     = 4'd3,
            MEMWRBK     = 4'd4,
            MEMWR       = 4'd5,
            EXEC        = 4'd6,
            ALUWRBK     = 4'd7,
            BRANCH      = 4'd8,
            ADDIEX      = 4'd9,
            ADDIWRBK    = 4'd10,
            POST_FETCH  = 4'd12,
            POST_FETCH2 = 4'd14,
            POST_MREAD  = 4'd13,
            JMP         = 4'd11;

localparam OpR_Type = 6'b000_000;
localparam OpSW     = 6'b100_011;
localparam OpLW     = 6'b101_011;
localparam OpBEQ    = 6'b000_100;
localparam OpADDI   = 6'b000_011;
localparam OpJMP    = 6'b000_010;


localparam  AND      = 3'b000,
            OR       = 3'b001,
            ADD      = 3'b010,
            SUBTRCT  = 3'b110,
            SRL      = 3'b100,
            SLL      = 3'b101,
            XOR      = 3'b111;


localparam  mem2reg_on       = 16'b1000_0000_0000_0000,
            reg_dest_on      = 16'b0100_0000_0000_0000,
            iod_on           = 16'b0010_0000_0000_0000,
            pc_src_0on       = 16'b0000_0000_0000_0000,
            pc_src_1on       = 16'b0000_1000_0000_0000,
            pc_src_2on       = 16'b0001_0000_0000_0000,
            alu_srcB_sel_0on = 16'b0000_0000_0000_0000,
            alu_srcB_sel_1on = 16'b0000_0010_0000_0000,
            alu_srcB_sel_2on = 16'b0000_0100_0000_0000,
            alu_srcB_sel_3on = 16'b0000_0110_0000_0000,
            alu_srcA_sel_on  = 16'b0000_0001_0000_0000,
            ir_wen_on        = 16'b0000_0000_1000_0000,
            pc_wen_on        = 16'b0000_0000_0100_0000,
            mem_we_on        = 16'b0000_0000_0010_0000,
            branch_on        = 16'b0000_0000_0001_0000,
            reg_wen_on       = 16'b0000_0000_0000_0010,
            alu_0op          = 16'b0000_0000_0000_0000,
            alu_1op          = 16'b0000_0000_0000_0100,
            alu_2op          = 16'b0000_0000_0000_1000,
            alu_3op          = 16'b0000_0000_0000_1100,
            ram_enable_on    = 16'b0000_0000_0000_0001;


wire [1:0] pc_src;    //selecciona de la fuente del nuevo dato para el program counter
wire reg_dest;        //
wire mem2reg;
reg [2:0]op_sel;
reg [RAM_WIDTH-1:0] alu_srcA; //entrada de datos a la ALU operando A
reg [RAM_WIDTH-1:0] alu_srcB; //entrada de datos a la ALU operando B
reg  [RAM_WIDTH-1:0] alu_res; //resultado de la operacion de la ALU
wire alu_srcA_sel;
wire [1:0]alu_srcB_sel;
wire alu_zero;
reg [RAM_WIDTH-1:0] mem_data_reg;
reg [RAM_WIDTH-1:0] reg_alu_res;
wire mem_we; // wire para escribir en la memoria de programa
wire iod; //instruction or data
wire ram_enable; // activa la salida de datos de la memoria de programa
reg [RAM_WIDTH-1:0] reg_outA;   //registros que almacenan la salida del register file
reg [RAM_WIDTH-1:0] reg_outB;
reg [RAM_WIDTH-1:0] inst_reg;
reg [BUS_WIDTH-1:0] pc; // registro del program counter
wire pc_wen; //enable capute data progam counter
reg [RAM_WIDTH-1:0] pc_din; // datos de entrada para el pc
wire branch;
wire ir_wen;

wire reg_wen; //habilita la escritura de los registros
//(* ram_style = "{auto|block|distributed|pipe_distributed|block_power1|block_power2}" *)
(* ram_style = "block" *)
reg [RAM_WIDTH-1:0] mem [(2**RAM_ADDR_BITS)-1:0];  //LA memoria de programa
reg [RAM_WIDTH-1:0] mem_dout;     //salida de datos de la memoria de programa

wire [RAM_ADDR_BITS-1:0] mem_addr; // address para memoria de programa
wire [RAM_WIDTH-1:0] mem_in;  // datos para escribir en la memoria
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// C O N T R O L   P A T H
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

reg [3:0] control_state;
reg [15:0]  control_reg;
always@(posedge clk)
   if(rst) begin
    control_state <= FETCH;
//    control_reg <= (alu_srcB_sel_1on | ir_wen_on | pc_wen_on | ram_enable_on);
    control_reg <= (alu_srcB_sel_1on | ir_wen_on | ram_enable_on);
    end
   else begin
   control_reg <= 'b0;
   case(control_state)
      FETCH:begin
         control_state <= POST_FETCH;
         control_reg <= (alu_srcB_sel_1on | ir_wen_on | pc_wen_on | ram_enable_on);
      end
      POST_FETCH:begin  //estado de espera por que ahora la memoria es synch
         control_state <= DECODE;
//         control_reg <= (alu_srcB_sel_1on | ir_wen_on | ram_enable_on);
         control_reg <= (alu_srcB_sel_1on );
//         control_reg <= (alu_srcB_sel_1on | ram_enable_on);
         
      end
      DECODE:begin
         case(inst_reg[31:26 ]) //opcode
            OpR_Type: control_state <= EXEC;
            OpSW:     control_state <= MEMADR;
            OpLW:     control_state <= MEMADR;
            OpBEQ:    control_state <= BRANCH;
            OpADDI:   control_state <= ADDIEX; //diferenciar en el estado branch si es para beq o addi
            OpJMP:    control_state <= JMP;
            default: control_state <= EXEC;
         endcase        
         control_reg <= (alu_srcB_sel_3on);
      end
      MEMADR:begin //memory address  computation
         control_state <= (inst_reg[31:26] == OpLW)? MEMREAD:MEMWR;
         control_reg <= alu_srcA_sel_on | alu_srcB_sel_2on;
      end
      MEMREAD:begin //memory access -- espearar 1 clk cycle para tener los datos de la memoria
         control_state <= POST_MREAD;
         control_reg <= iod_on | ram_enable_on;
      end
      POST_MREAD:begin
         control_state <= MEMWRBK ;
         control_reg <= 'b0;
      end
      MEMWRBK:begin  //escribir en los registros
         control_state <= FETCH;
         control_reg <= reg_wen_on | mem2reg_on | ram_enable_on;
      end
      MEMWR:begin // memory access para op sw -- no necesita de delay extra, por ser escritura
         control_state <= FETCH;
         control_reg <= iod_on | mem_we_on | ram_enable_on;
      end
      EXEC:begin //ejecucion del comando para las instucciones tipo reg
         control_state <= ALUWRBK;
         control_reg <= alu_srcA_sel_on | alu_srcB_sel_0on | alu_2op;
      end
      ALUWRBK:begin //R type completion
         control_state <= FETCH;
         control_reg <= reg_dest_on | reg_wen_on;
      end
      BRANCH:begin //branch completion
         control_state <= POST_FETCH2;
//           control_state <= FETCH;
         control_reg <= alu_srcA_sel_on | ram_enable_on | alu_1op | branch_on | pc_src_1on;//branch_on = pcwritecond
      end
      POST_FETCH2:begin
        control_state <= FETCH;
        control_reg <= ram_enable_on;
      end
      ADDIEX:begin
         control_state <= ADDIWRBK;
         control_reg <= alu_srcA_sel_on | alu_srcB_sel_2on;
      end
      ADDIWRBK:begin //escribir el resultado en los registros
         control_state <= FETCH;
         control_reg <=  reg_wen_on;
      end

      JMP:begin
         control_state <= FETCH;
         control_reg <= pc_wen_on | pc_src_2on;
      end
      default:begin
         control_state <= FETCH;
//         control_reg <= ;
      end
   endcase
end


wire [1:0]alu_op;
assign mem2reg      = control_reg[15]; //cambia la fuente de los datos mux que apunta la direccion del dato a escribir en los regs
assign reg_dest     = control_reg[14]; //selecciona la fuente del address de los registros
assign iod          = control_reg[13];      //selecciona la fuente del address para la memoria ROM
assign pc_src       = control_reg[12:11];   //de donde viene la sig instruccion
assign alu_srcB_sel = control_reg[10:9]; // selecciona el operando de entrada a la ALU
assign alu_srcA_sel = control_reg[8]; // selecciona el operando de entrada a la ALU
assign ir_wen       = control_reg[7];       //activa la escritura en el instruction register
assign mem_we       = control_reg[5];       //activa la escritura en la memoria de I/D
assign pc_wen       = control_reg[6];      // habilita la escritura en el program counter
assign branch       = control_reg[4];      //se activa cuando la instriuccion es para branch
assign alu_op       = control_reg[3:2];
assign reg_wen      = control_reg[1];     // habilita la escritura en los register file
assign ram_enable   = control_reg[0];                  


            

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// D A T A   P A T H
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



/******** program memory ***********/
   //  The following code is only necessary if you wish to initialize the RAM
   //  contents via an external file (use $readmemb for binary data)
   //initial
   //     $readmemh("C:/Users/gaespind/Dropbox/tarea5/memData.dat", mem);


//   initial begin    //cargar los datos contenidos en el registro 2 + contenido del reg 1
//   mem[0]  
//   mem[4]  = 32'hfefa_ff1f;
//   mem[10]  = 32'hfede_1210;
//   mem[5]  = 32'hfede_1210;
//   end
   
   
   initial begin
   //mem[0] = {OpLW, 5'b00001, 5'd29,16'h0002};
//     mem[0] = {OpSW, 5'b00001, 5'd29,16'h0018};
   //mem[0] = {OpR_Type, 5'd1, 5'd2, 5'd31,  5'd0, 6'b100100}; //and
//   mem[0] = {OpR_Type, 5'd1, 5'd2, 5'd30,  5'd0, 6'b100101}; //or
//   mem[0] = {OpR_Type, 5'd1, 5'd2, 5'd30,  5'd0, 6'b100000}; //add
//   mem[0] = {OpR_Type, 5'd1, 5'd2, 5'd30,  5'd0, 6'b110000}; //srl
//   mem[0] = {OpR_Type, 5'd1, 5'd2, 5'd30,  5'd0, 6'b101010}; //xor
//     mem[0] = {OpBEQ, 5'd29, 5'd28,-16'h0001}; //beq**************
   ////////// M A I N
   mem[0] = {OpADDI, 5'd0, 5'd1,16'h0100}; //almacenar la mascara en el reg 1
   mem[1] = {OpADDI, 5'd0, 5'd31,16'h0000}; // captura el valor de salida de la uart
   mem[2] = {OpR_Type,5'd1,5'd31,5'd2, 6'b100100};//hacer una and del reg 31 y la mask 
   mem[3] = {OpBEQ, 5'd0, 5'd2, 16'h0001}; //beq**************
   mem[4] = {OpJMP, 26'd1}; //jmp a inicio
   mem[5] = {OpADDI, 5'd0, 5'd5,16'h0000};     //guardar operando 1 en R5
   
   
   ////////E N D   M A I N
   //verificar si el resultado de la op and fue cero sisi continuar polling, sino el bit esta activo, capturar y limpiar bit
//   mem[1] = {OpR_Type, }
//   mem[0] = {OpJMP, 26'd12}; //jmp
     //mem[1] = {OpBEQ, 5'd29, 5'd28,-16'h0001}; 
//     mem[1] = {OpADDI, 5'd31, 5'd31,16'h0000};
//     mem[2] = {OpADDI, 5'd31, 5'd31,16'h0001};
//     mem[3] = {OpADDI, 5'd31, 5'd31,16'h0001};
//     mem[4] = {OpADDI, 5'd31, 5'd31,16'h0001};
//     mem[5] = {OpBEQ, 5'd29, 5'd05,16'h0003}; //beq**************
     mem[6] = {OpADDI, 5'd29, 5'd30,16'h0103};
     mem[7] = {OpADDI, 5'd29, 5'd29,16'h0005};
//   mem[2] = 32'h0000_0005;
//   mem[3] = 32'h0000_0006;
//   mem[4] = 32'h0000_0007;
// mem[5] = 32'h0000_0008;s
//   mem[6] = 32'h0000_0009;
//   mem[7] = 32'h0000_0010;
   mem[8] = {OpADDI, 5'd0, 5'd30,16'h0001};
   mem[9] = {OpADDI, 5'd0, 5'd30,16'h0001};
   mem[10] = {OpADDI, 5'd29, 5'd28,16'h0001};
   mem[11] = {OpJMP, 26'd1}; //jmp
   mem[12] = 32'h0000_0014;
   mem[13] = 32'h0000_0015;
   mem[14] = 32'h0000_0169;
   mem[15] = 32'h0000_0179;
   mem[16] = 32'h0000_0009;
   mem[17] = 32'h0000_0189;
   mem[18] = 32'h0000_0019;
   mem[19] = 32'h0000_0009;
   mem[20] = 32'h0020_0009;
   mem[21] = 32'h0000_2109;
   mem[22] = 32'h0000_0022;
   mem[23] = 32'h2300_0009;
   mem[24] = 32'h0024_0009;
   mem[25] = 32'h0000_2509;
   mem[26] = 32'h0000_0026;
   mem[27] = 32'h2700_0009;
   mem[28] = 32'h0028_0009;
   mem[29] = 32'h0000_0000;
   mem[30] = 32'h0000_0030;
   mem[31] = 32'h3100_0009;
   
end
   
   
   
   //mux de entrada para address de memdata
   assign mem_addr = (iod)? reg_alu_res:{2'b00,pc[31:2]};
   assign mem_in = reg_outB;
   
   always @(posedge clk)
      if (ram_enable) begin
         if (mem_we)
            mem[mem_addr] <= mem_in;
         mem_dout <= mem[mem_addr];
      end
/******** program memory ***********/


/******** progam counter **********/


//mux para la entrada de pc

always@(*)
   case(pc_src)
      2'b00: pc_din = alu_res; //salida directa de la ALU
      2'b01: pc_din = reg_alu_res; //salida registrada de la ALU
      2'b10: pc_din = {pc[31:28],{inst_reg[23:0],2'b00}};
      default: pc_din = alu_res;
   endcase
always@(posedge clk) begin
   if(rst)
      pc <= {BUS_WIDTH{1'b0}};
   else
      pc <= (pc_wen || (alu_zero && branch))? pc_din:pc;
end
/******** /progam counter **********/

/******* register file ***************/
//Dual port distributed async memory

(* ram_style="distributed" *)
reg [RAM_WIDTH-1:0] registers [(2**RAM_ADDR_BITS)-1:0];

initial begin
   registers[0] = 32'h0000_0011;
   registers[1] = -32'h0000_0005;
   registers[2] = 32'h0000_0001;
   registers[3] = 32'h0000_0003;
   registers[4] = 32'h0000_0004;
   registers[5] = 32'h0000_0005;
   registers[6] = 32'h0000_0006;
   registers[7] = 32'h0000_0007;
   registers[8] = 32'h0000_0009;
   registers[9] = 32'h0000_0009;
   registers[10] = 32'h0000_0010;
   registers[11] = 32'h0000_0011;
   registers[12] = 32'h0000_0012;
   registers[13] = 32'h0000_0012;
   registers[14] = 32'h0000_0013;
   registers[15] = 32'h0000_0014;
   registers[16] = 32'h0000_0015;
   registers[17] = 32'h0000_0016;
   registers[18] = 32'h0000_0017;
   registers[19] = 32'h0000_0018;
   registers[20] = 32'h0000_0019;
   registers[21] = 32'h0000_0020;
   registers[22] = 32'h0000_0021;
   registers[23] = 32'h0000_0022;
   registers[24] = 32'h0000_0023;
   registers[25] = 32'h0000_0024;
   registers[26] = 32'h0000_0025;
   registers[27] = 32'h0000_0026;
   registers[28] = 32'h0000_0027;
   registers[29] = 32'h0000_0000;
   registers[30] = 32'h0000_0030;
   registers[31] = 32'h0000_0030;
   
end

wire [RAM_WIDTH-1:0] outA; //salida A combinacional de los registros
wire [RAM_WIDTH-1:0] outB; //salida B combinacional de los registros

wire [RAM_ADDR_BITS-1:0] reg_addrA, reg_addrB; //read address
wire [RAM_ADDR_BITS-1:0] reg_waddr; //direcciona los registros a escribir
wire [RAM_WIDTH-1:0] reg_din; //datos a escribir

//mux para seleccionar la addrs de escritura de los regs
//wire reg_dst;
assign reg_waddr = (reg_dest)? inst_reg[15:11]:inst_reg[20:16];
//mux para datos a escrbir en los registros

assign reg_din = (mem2reg)? mem_data_reg:reg_alu_res;


assign reg_addrA = inst_reg[25:21];
assign reg_addrB = inst_reg[20:16];

always @(posedge clk)
   if (reg_wen)
      registers[reg_waddr] <= (reg_waddr == 5'd31)? {23'b0,inFlag,inWord}:reg_din;
    //registro 31 como entrada

// registro cero solo lectura
assign outA = (reg_addrA == {RAM_ADDR_BITS{1'b0}})?  {RAM_WIDTH{1'b0}}:registers[reg_addrA];
assign outB = (reg_addrB == {RAM_ADDR_BITS{1'b0}})?  {RAM_WIDTH{1'b0}}:registers[reg_addrB];
/*
** Registro 30 salida de datos
*/
assign {outFlag, outWord} = registers[5'd30];

always@(posedge clk)
   reg_outA <= outA;

always@(posedge clk)
   reg_outB <= outB;
/****** /register file **************/


/********** instruction reg***********/


always@(posedge clk)
   if(rst)
      inst_reg <= {RAM_WIDTH{1'b0}};
   else
      inst_reg <= (ir_wen)? mem_dout:inst_reg;
/********** /instruction reg***********/


/********** ALU *********************/
// operaciones que debe realizar la ALU
// ADD
// shift left
// shift rigth
// and
// or
// xor


//----------->>> MUX para entrada A de ALU
always@(*)
case(alu_srcA_sel)
   1'b0: alu_srcA = pc;
   1'b1: alu_srcA = reg_outA;
   default: alu_srcA = reg_outA;
 endcase
//----------->>> MUX para entrada B de ALU
wire [RAM_WIDTH-1:0] sign_ext = $signed({ {16{ inst_reg[15] }}, inst_reg[15:0]});
always@(*)
case(alu_srcB_sel)
   2'b00: alu_srcB = reg_outB;
   2'b01: alu_srcB = 32'h4;
   2'b10: alu_srcB = sign_ext;//extension de signo para los comandos imm
   2'b11: alu_srcB = {sign_ext[13:0],2'b00}; //shift left 2
   default: alu_srcB = reg_outB;
 endcase

 localparam _LOAD_WORD  	= 8'b00_XXXXXX,
				_STORE_WORD 	= 8'b00_XXXXXX,
				_BRANCH_EQ	= 8'b01_XXXXXX,
				_ADD			= 8'b10_100000,
				_SUBTRACT  	= 8'b10_100010,
				_AND			= 8'b10_100100,
				_OR			= 8'b10_100101,
				_SRL			= 8'b10_110000,
				_SLL			= 8'b10_111000,
				_ADDI		   = 8'b11_XXXXXX,
				_XOR			= 8'b10_101010;



always@(*)
   casex({alu_op, inst_reg[5:0]}) //salida de la control FSM 2 bit y del inst reg funct field 6bit
      _LOAD_WORD:  op_sel = ADD;
    //  _STORE_WORD: op_sel = ADD;
      _BRANCH_EQ:  op_sel = SUBTRCT;
      _ADD:	      op_sel = ADD;
      _SUBTRACT:   op_sel = SUBTRCT;
      _AND:        op_sel = AND;
      _OR:         op_sel = OR;
      _SRL:        op_sel = SRL;
      _SLL:        op_sel = SLL;
      _ADDI:       op_sel = ADD;
      _XOR:        op_sel = XOR;
      default:    op_sel = OR;
   endcase

always@(*)
case(op_sel)
   AND:
      alu_res = alu_srcA & alu_srcB;
   OR:
      alu_res = alu_srcA | alu_srcB;
   ADD:
      alu_res = $signed(alu_srcA) + $signed(alu_srcB);
   SUBTRCT:
      alu_res = $signed(alu_srcA) - $signed(alu_srcB);
   SRL:
      alu_res = alu_srcA >> alu_srcB;
   SLL:
      alu_res = alu_srcA << alu_srcB;
   XOR:
      alu_res = alu_srcA ^ alu_srcB;
   default:
      alu_res = alu_srcA;
endcase

assign alu_zero = !(|alu_res); //indica cuando el resultado de la operacion es cero
                               // solo se debe tomar en cuenta cuando la operaciones de tipo
                               //arithmetico

always@(posedge clk)
   reg_alu_res <= alu_res;

/********** /ALU *********************/

/********** memory data reg***********/

always@(posedge clk)
   if(rst)
      mem_data_reg <= {RAM_WIDTH{1'b0}};
   else
      mem_data_reg <= mem_dout;
/********** /memory data reg **********/

/******* /data path ***************/
//assign outFlag = 

endmodule

