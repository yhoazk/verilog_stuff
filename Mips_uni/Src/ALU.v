///ALU

//operaciones
	//AND
	//ADD
	//complemento
	//incremento
	//bypass
	//shift R
	//shift L
//debe tener senial de ZERO
module ALU
//parameters
#(
	parameter Bus_Width = 16	
)
//I/O ports

( 
input wire [Bus_Width-1:0] DataA,
input wire [Bus_Width-1:0] DataB,
input wire [2:0] Inst_Sel,
output wire Zero, 
output wire [Bus_Width-1:0] Data_Out
//,output wire Cout, Z
);
localparam 	AND 		= 3'b000,
				OR			= 3'b001,
				ADD 		= 3'b010,
				SUBTRCT 	= 3'b110,
				SRL		= 3'b100,
				SLL		= 3'b101,
				XOR		= 3'b111;

reg [Bus_Width-1:0] Data_Out_Reg;
			 
always@(*) begin//bloque combinacional
	
	case(Inst_Sel)
		AND: 
		begin
			Data_Out_Reg = DataA & DataB;
		end
		OR:
		begin
			Data_Out_Reg = DataA | DataB;
		end
		ADD:
		begin
			Data_Out_Reg = DataA + DataB;
		end
		SUBTRCT:
		begin
			Data_Out_Reg = DataA - DataB;
		end
		SRL:
		begin
			Data_Out_Reg = DataA >> DataB;
		end
		SLL:
		begin
			Data_Out_Reg = DataA << DataB;
		end
		XOR:
		begin
			Data_Out_Reg = DataA ^ DataB;
			//(Data_Out_Reg  == 0)? Zero= 1'b1 : Zero = 1'b0;
		end
		default: //same as bypass
		begin 
			Data_Out_Reg = 'b0;
		end
	endcase
end	
assign Data_Out = Data_Out_Reg;
assign Zero = !(|Data_Out);
endmodule


