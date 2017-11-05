//Maquina de estados para el MIPS_multi


module Cntrl_FSM (
	input clk,
	input rst,
	input [5:0] OpCode,
	input  [5:0]Function,
	output wire PCWrite,
	output wire Branch_Cntrl,
	output wire [1:0]PCSrc,
	output wire [2:0]ALUCntrl,
	output wire ALUSrcA,
	output wire [1:0]ALUSrcB,
	output wire RegWrite,
	output wire MemToReg,
	output wire RegDst,
	output wire IRWrite,
	output wire MemWrite,
	output wire IorD
	
);
reg [15:0] Out;
reg [3:0] State = 4'b0000; 
//reg [3:0] Next_State = 4'b0000; 

localparam 	FETCH 	= 4'd0,
			DECODE 	= 4'd1,
			MEMADR 	= 4'd2,
			MEMREAD	= 4'd3,
			MEMWRBK	= 4'd4,
			MEMWR	= 4'd5,
			EXEC	= 4'd6,
			ALUWRBK	= 4'd7,
			BRANCH	= 4'd8,
			ADDIEX	= 4'd9,
			ADDIWRBK= 4'd10,
			JMP		= 4'd11;

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
			
// always @(State) begin
	// case(State)
		
// end



always @(posedge clk or negedge rst) begin
	if(!rst) begin
		State <= FETCH;
	end else	
	case(State) //case para ramificacion entre instrucciones
		FETCH: begin
			Out <= 16'b1_0_00_010_0_01_0_0_0_1_0_0;
			State <= DECODE;
		end
		DECODE: begin
			Out <= 16'b0_0_00_010_0_11_0_0_0_0_0_0;  //alusrca =1
			case(OpCode)
				OpR_Type: 	State <= EXEC;
				OpLW:		State <= MEMADR;
				OpSW:		State <= MEMADR;
				OpBEQ:		State <= BRANCH;
				OpADDI:		State <= ADDIEX;
				OpJMP:		State <= JMP;
				default: 	State <= FETCH;
			endcase
		end
		MEMADR: begin
			Out <= 16'b0_0_00_010_1_10_0_0_0_0_0_0;
			if(OpCode == OpLW) begin
				State <= MEMREAD;
			end else begin //OpSW
				State <= MEMWR;
			end
		end
		MEMREAD: begin
			Out <= 16'b0_0_00_010_1_10_0_0_0_0_0_1;
			State <= MEMWRBK;
		end
		MEMWRBK: begin
			Out <= 16'b0_0_00_010_1_10_1_1_0_0_1_1;
			State <= FETCH;
		end
		MEMWR: begin
			Out <= 16'b0_0_00_010_1_10_0_0_0_0_1_1;
			State <= FETCH;
		end
		EXEC: begin
			//case para diferenciar la operacion de la ALU
			case(Function)
				AND:		Out <= 16'b0_0_00_000_1_00_0_0_0_0_0_0;
				ADD:		Out <= 16'b0_0_00_010_1_00_0_0_0_0_0_0;
				OR:			Out <= 16'b0_0_00_001_1_00_0_0_0_0_0_0;
				SRL:		Out <= 16'b0_0_00_100_1_00_0_0_0_0_0_0;
				SLL:		Out <= 16'b0_0_00_101_1_00_0_0_0_0_0_0;
				SUBTRCT:	Out <= 16'b0_0_00_110_1_00_0_0_0_0_0_0;
				//ADDI:		Out <= 16'b0_0_00_010_0_00_0_0_0_0_0_0;
				XOR:		Out <= 16'b0_0_00_111_1_00_0_0_0_0_0_0;
				default:	Out <= 16'b0_0_00_000_1_00_0_0_0_0_0_0;
			endcase
			
			State <= ALUWRBK;
		end
		ALUWRBK: begin
			Out <= 16'b0_0_00_000_0_00_1_0_1_0_0_0;
			State <= FETCH;
		end
		BRANCH: begin
			Out <= 16'b0_1_01_110_1_00_0_0_0_0_0_0;
			State <= FETCH;
		end
		ADDIEX: begin
			Out <= 16'b0_0_00_010_1_10_0_0_0_0_0_0;
			State <= ADDIWRBK;
		end
		ADDIWRBK: begin
			Out <= 16'b0_0_00_000_0_00_1_0_0_0_0_0;
			State <= FETCH;
		end
		JMP: begin
			Out <= 16'b1_0_10_000_0_00_0_0_0_0_0_0;
			State <= FETCH;
		end
		default: begin
			Out <= 16'b0_0_00_000_0_00_0_0_0_0_0_0;
			State <= FETCH;
		end
	endcase
end

assign {PCWrite, Branch_Cntrl, PCSrc[1], PCSrc[0], ALUCntrl[2],ALUCntrl[1],
		ALUCntrl[0], ALUSrcA, ALUSrcB[1], ALUSrcB[0], RegWrite, MemToReg,
		RegDst, IRWrite, MemWrite, IorD}= Out;
		
endmodule //Cntrl_FMS



