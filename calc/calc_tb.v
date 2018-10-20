`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   18:42:58 11/28/2012
// Design Name:   calc
// Module Name:   C:/Users/gaespind/Documents/MDE/tar6/ise/calc/calc_tb.v
// Project Name:  calc
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: calc
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module calc_tb;

	// Inputs
	reg clk;
	reg rst;
	reg rx;

	// Outputs
	wire tx;
	wire [7:0] leds;

   reg [7:0] SW_data;
	reg Send;
	reg prtysel;

   // Note: CLK must be defined as a reg when using this method
   
   parameter PERIOD = 20;

   always begin
      clk = 1'b0;
      #(PERIOD/2) clk = 1'b1;
      #(PERIOD/2);
   end  
				

	// Instantiate the Unit Under Test (UUT)
	calc uut (
		.clk(clk), 
		.rst(rst), 
		.rx(tx_out), 
		.tx(tx), 
		.leds(leds)
	);

	uart_tx tester (
    .clk(clk), 
    .SW_data(SW_data),
    .Parity_sel(prtysel), 
    .Send(Send), 
    .tx(tx_out)
    );



	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 1;
		rx = 0;
		SW_data = 0;
		Send = 0;
		prtysel = 0;
		// Wait 100 ns for global reset to finish
		#100;
      rst = 0;
		// Add stimulus here
      #200;
		@(posedge clk) SW_data = 8'h55;
		@(posedge clk) Send = 1;
		@(posedge clk) Send = 0;
		#600000;
		@(posedge uut.inFlag) // se tarmino la recepcion
		prtysel = 1;
		#600000;
		@(posedge clk) SW_data = 8'h55;
		@(posedge clk) Send = 1;
		@(posedge clk) Send = 0;
		#600000;
		@(posedge uut.inFlag)
		#600000;
		@(posedge clk) SW_data = 8'h00;
		@(posedge clk) Send = 1;
		@(posedge clk) Send = 0;
		#600000;
		@(posedge uut.inFlag)
		prtysel = 0;
		#600000;
		@(posedge clk) SW_data = 8'h80;
		@(posedge clk) Send = 1;
		@(posedge clk) Send = 0;
		#2000000;
      $stop;

	end
      
endmodule

