//ALu control
module ALU_Cntrl(
	input [1:0] ALU_Op,
	input [5:0] FnctField,
	output [2:0] ALU_Cntl
 );
 
 localparam LOAD_WORD  	= 8'b00_XXXXXX,
				STORE_WORD 	= 8'b00_XXXXXX,
				BRANCH_EQ	= 8'b01_XXXXXX,
				ADD			= 8'b10_100000,
				SUBTRACT		= 8'b10_100010,
				AND			= 8'b10_100100,
				OR				= 8'b10_100101,
				SRL			= 8'b10_110000,
				SLL			= 8'b10_111000,
				ADDI			= 8'b11_XXXXXX,
				XOR			= 8'b10_101010;
reg [2:0]ALU_Cntrl_reg;
wire [7:0] cat_Cntrl = {ALU_Op, FnctField};
 always@(cat_Cntrl) begin
	casex(cat_Cntrl)
//		LOAD_WORD: begin
//			ALU_Cntrl_reg = 3'b010;
//		end
		STORE_WORD: begin
			ALU_Cntrl_reg = 3'b010;
		end
		BRANCH_EQ: begin
			ALU_Cntrl_reg = 3'b110;
		end
		ADDI:
		begin
			ALU_Cntrl_reg = 3'b010;
		end
		ADD: 
		begin
			ALU_Cntrl_reg = 3'b010;
		end
		SUBTRACT:begin
			ALU_Cntrl_reg = 3'b110;
		end
		AND:begin
			ALU_Cntrl_reg = 3'b000;
		end
		OR: begin
			ALU_Cntrl_reg = 3'b001;
		end
		SRL: begin
			ALU_Cntrl_reg = 3'b100;
		end
		SLL: begin
			ALU_Cntrl_reg = 3'b101;
		end
		XOR:begin
			ALU_Cntrl_reg = 3'b111;
		end
		default: begin
			ALU_Cntrl_reg = 3'b000;
		end
	endcase
 end
 assign ALU_Cntl = ALU_Cntrl_reg;

endmodule //ALU_Cntrl
