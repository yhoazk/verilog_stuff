
module memoria
	#(
	parameter 	DATA_WIDTH = 8,
					ADDR_WIDTH = 6,
					RAM_DEPTH = 1 << ADDR_WIDTH
	)
	(	
	input		[(ADDR_WIDTH-1):0]address     , // Address Input
	output reg	[31:0]data         //data_out
	);          

reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

	
		//mem[0] = 32'b000010_00000000000000000000000001;
	 //mem[0] = 32'b000000_00001_00000_00010_00000_100000; //tipo reg: sumar reg1 +reg0 = reg0
	 //mem[0] = 32'b000000_00001_00000_00010_00000_100010; //tipo reg: Restar regs - regt = regd
	 //mem[0] = 32'b000000_00001_00000_00010_00000_100100; //tipo reg: Restar regs & regt = regd
	 //mem[0] = 32'b000000_00001_00000_00010_00000_101010; //tipo reg: Restar regs ^ regt = regd
	//{mem[0],mem[1],mem[2],mem[3]} = 32'b000000_00001_00000_00010_00010_111000; //tipo reg: Restar regs >> regt = regd
	//	{mem[0],mem[1],mem[2],mem[3]} = 32'b100011_00001_00010_00000_00000_000001; //load regdest = mem(reg-base + offset) debe cargar la locacion de memoria 2 en el regisro 2
		//{mem[0],mem[1],mem[2],mem[3]} = 32'b101011_00001_00010_00000_00000_000010; //SW almacenar dato del reg a la mem
			//almacenar el registro 2 en la locacion de memoria resultante de la suma de 00001 y 00000_00000_000010 
		//{mem[0],mem[1],mem[2],mem[3]} = 32'b000100_00001_00010_00000_00000_000100; //BEQ salto si reg 2 == 1 a la direccion		   PC+2
		//{mem[0],mem[1],mem[2],mem[3]} = 32'b010000_00001_00010_00100_00000_000100; //addi op-code[31:26], rs[25:21], rt[20:16], Amount[15:0]
		integer i;
		initial begin 
		for(i=0; i < RAM_DEPTH; i= i+1) begin
			mem[i]=8'b0000_0000;
		end
		{mem[0],mem[1],mem[2],mem[3]} = 32'b000010_00000_00000_00000_00000_000101;
		{mem[4],mem[5],mem[6],mem[7]} = 32'b000000_00001_00000_00010_00000_101010; //tipo reg: Restar regs ^ regt = regd
		{mem[8],mem[9],mem[10],mem[11]}=32'b000000_00001_00000_00010_00010_110000;
		//instruccion para salto
		{mem[20],mem[21],mem[22],mem[23]} = 32'b000000_00001_00000_00010_00000_100000; //tipo reg: sumar reg1 +reg0 = reg0
		
	end
always @ (address)
begin
      data ={ mem[address], mem[address + 2'b01], mem[address + 2'b10], mem[address + 2'b11]};
end

endmodule 


