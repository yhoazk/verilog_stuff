`define WIDTH 8
module comb_logic_tb;
reg [7:0] a;
reg [7:0] b;
wire  [7:0] out_and;
wire [7:0] out_or;
wire [7:0] out_xor;
wire [7:0] out_not;

// Parametrized module: Setting bus width to 8
comb_logic #(8) DUT  (
    .a(a), .b(b), .out_and(out_and), .out_or(out_or), .out_xor(out_xor), .out_not(out_not)
);


initial begin
    a = 8'b0;
    b = 8'b0;
//    x = 1'b0; This is a wire cannot be driven here, only by regs from the module
#5  a = 8'b1; 
#5  b = 8'b1;
#20 a = 8'b0;
end

/* FOR GTK WAVE */
initial
  begin
    $dumpfile("comb_logic.vcd");
    $dumpvars(0, comb_logic_tb);
  end

endmodule
