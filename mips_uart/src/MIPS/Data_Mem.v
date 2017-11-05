
module Data_Mem #(
	parameter 	DATA_WIDTH = 32,
					ADDR_WIDTH = 4,
					RAM_DEPTH = 1 << ADDR_WIDTH
)
(
input clk,
input [ADDR_WIDTH-1:0] Address,
input [DATA_WIDTH-1:0] WriteData, 
//input MemRead_en,
input MemWrite_en,
output [DATA_WIDTH-1:0]ReadData
);          

/*****************ASSEMBLER DEFINES****************/
localparam OpR_Type = 6'b000_000;
localparam OpSW 	= 6'b100_011;
localparam OpLW 	= 6'b101_011;
localparam OpBEQ 	= 6'b000_100;
localparam OpADDI 	= 6'b000_011;
localparam OpJMP 	= 6'b000_010;

localparam	AND	  	= 3'b000,
			OR		= 3'b001,
			ADD 	= 3'b010,
			SUBTRCT	= 3'b110,
			SRL		= 3'b100,
			SLL		= 3'b101,
			XOR		= 3'b111;
			
localparam 	R0	= 5'b0_0000,
			R1	= 5'b0_0001,
			R2	= 5'b0_0010,
			R3	= 5'b0_0011,
			R4	= 5'b0_0100,
			R5	= 5'b0_0101,
			R6	= 5'b0_0110,
			R7	= 5'b0_0111,
			R8	= 5'b0_1000,
			R9	= 5'b0_1001,
			R10	= 5'b0_1010,
			R11	= 5'b0_1011,
			R12 = 5'b0_1100,
			R13	= 5'b0_1101,
			R14	= 5'b0_1110,
			R30 = 5'b1_1110,
			R31 = 5'b1_1111;
/*****************ASSEMBLER DEFINES****************/ 





reg [(DATA_WIDTH-1):0]   DataOut_reg;
reg [(DATA_WIDTH-1):0] memory [(RAM_DEPTH-1):0];
integer i;
initial begin

	for(i=3; i<=(2**ADDR_WIDTH)-1; i=i+1) begin
		//memory[i] = {(DATA_WIDTH-1){1'b0}};
		memory[i] = i;
	end
	//memory[0] = 32'b000000_00001_00010_01010_00000_000000; //and entre R1 y R2 se almaena en R10
	//memory[0] = 32'b000000_00001_00010_01010_00000_000010; //suma entre R1 y R2 se almaena en R10
	//memory[0] = 32'b000000_00001_00010_01010_00000_000110; //resta entre R1 y R2 se almaena en R10
	//memory[0] = 32'b000000_00001_00010_01010_00000_000100;	 //SRL  entre R1 y R2 se almaena en R10
	//memory[0] = 32'b000000_00001_00010_01010_00000_000101;	 //SLL  entre R1 y R2 se almaena en R10
	//memory[0] = 32'b000000_00001_00010_01010_00000_000111;	 //Xor  entre R1 y R2 se almaena en R10
	//memory[0] = 32'b101011_00001_00010_00000_00000_000111;	 //SW  entre R1 y R2 se almaena en 9
	//memory[0] = 32'b101011_00001_00010_00000_00000_000111;	 //LW  entre 9 R1 y R2 se almaena en R2
	//memory[0] = 32'b000100_00001_00010_00000_00000_000101;	 //Beq offset de 5 para ir a instr 6
	//memory[0] = 32'b000100_00101_00011_00000_00000_000010;	 //Beq R3 R5offset de 5 para ir a instr 6
	
	//memory[0] = 32'b000011_00001_00010_00000_00000_000111;	 // ADDI 
	
	ADDI_Fnct(R0,R3, 16'h00_FA,memory[0] );	 	//cargar un valor en un reg3
	ADDI_Fnct(R0,R2, 16'h00_01,memory[1] );		//cargar el valor del incremento en el reg2
	memory[2] = 32'b000000_00010_00011_11111_00000_000010;	//add r31=r2 +r3
	memory[3] = 32'b000000_00010_00011_00011_00000_000010;	//add R31=R3+R31
	ADDI_Fnct(R3,R31, 16'h00_00,memory[4] );		
	memory[5] = 32'b000010_00000_00000_00000_00000_000011;	 //jump a insrt 3
	//ADD_Fnct(R3,R2,R31,memory[2] );		//cargar el valor en el registro de envio sumadole cero
	//J_Fnct(28'd2,memory[3] );
	//ADDI_Fnct(R0, R3,16'h00_FF,memory[4] );//Poner en el reg el valor a decrementar para el delay
	//decrementar el valor del reg hasta cero
	
	//memory[1] = 32'b000000_00001_00010_01010_00000_000010; //suma entre R1 y R2 se almaena en R10
	//memory[2] = 32'b101011_00001_00010_00000_00000_000111;	 //LW  entre R1 y R2 se almaena en 9
	
	//memory[4] = 32'hAB1E;////
	//memory[5] = 32'hAB2E;
	//memory[6] = 32'b000000_00001_00010_01010_00000_000000;	 //SRL  entre R1 y R2 se almaena en R10
	//memory[7] = 32'hAB6E;
	memory[8] = 32'h1B6E;
	memory[9] = 32'hA26E;
	memory[10] = 32'hA36E;
	memory[11] = 32'hAB4E;
	
end

//initial begin
// $readmemh("vectors.vec", mem);
//end

//initial begin 
//	mem[0] = 'h0;
//	mem[1] = 32'h00000FFA;
//	mem[2] = 32'h0000BFFA;
//end
//write
always @ (posedge clk)
begin
   if ( MemWrite_en ) begin
       memory[Address] <= WriteData;
   end
end

//read
always @ (Address, MemWrite_en, clk)
begin 
    
      DataOut_reg = memory[Address];
    
end

assign ReadData = DataOut_reg;
//
//genvar j;
//generate
// for(j=0; j < DATA_WIDTH; j=j+1) begin: block_generate_Ands
//	and myAnd(ReadData[j],DataOut_reg[j], MemRead_en);
// end
//endgenerate


/**********************************ASSEMBLER********************************/


task ADD_Fnct;
input [4:0] RS;
input [4:0] RD;
input [4:0] RT;
output [31:0] Instr;
	begin
		Instr = {OpR_Type, RS, RT, RD, 7'b0_0000, ADD};
	end
endtask

task ADDI_Fnct;
input [4:0] RS;
input [4:0] RT;
input [15:0] OpADDI_Val;
output [31:0] Instr;
	begin
		Instr = {OpADDI, RS, RT, OpADDI_Val};
	end
endtask

task SUB_Fnct;
input [4:0] RS;
input [4:0] RD;
input [4:0] RT;
output [31:0] Instr;
	begin
		Instr = {OpR_Type, RS, RT, RD, 7'b0_0000, SUBTRCT};
	end
endtask

task SRL_Fnct;
input [4:0] RS;
input [4:0] RD;
input [4:0] RT;
output [31:0] Instr;
	begin
		Instr = {OpR_Type, RS, RT, RD, 7'b0_0000, SRL};
	end
endtask

task SLL_Fnct;
input [4:0] RS;
input [4:0] RD;
input [4:0] RT;
output [31:0] Instr;
	begin
		Instr = {OpR_Type, RS, RT, RD, 7'b0_0000, SLL};
	end
endtask

task AND_Fnct;
input [4:0] RS;
input [4:0] RD;
input [4:0] RT;
output [31:0] Instr;
	begin
		Instr = {OpR_Type, RS, RT, RD, 7'b0_0000, AND};
	end
endtask

task XOR_Fnct;
input [4:0] RS;
input [4:0] RD;
input [4:0] RT;
output [31:0] Instr;
	begin
		Instr = {OpR_Type, RS, RT, RD, 7'b0_0000, XOR};
	end
endtask

task LW_Fnct;
input [4:0] RS;
input [4:0] RT;
input [15:0] ADDRS;
output [31:0] Instr;
	begin
		Instr = {OpLW, RS, RT, ADDRS};
	end
endtask

task SW_Fnct;
input [4:0] RS;
input [4:0] RT;
input [15:0] ADDRS;
output [31:0] Instr;
	begin
		Instr = {OpSW, RS, RT, ADDRS};
	end
endtask

task BEQ_Fnct;
input [4:0] RS;
input [4:0] RT;
input [15:0] ADDRS;
output [31:0] Instr;
	begin
		Instr = {OpBEQ, RS, RT, ADDRS};
	end
endtask

task J_Fnct;
input [27:0] ADDRS;
output [31:0] Instr;
	begin
		Instr = {OpJMP, ADDRS};
	end
endtask


endmodule // End of Module ram_sp_ar_aw
