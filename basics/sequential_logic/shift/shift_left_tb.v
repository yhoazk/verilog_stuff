/*
 * initial statement para hacer el test bench
 * cada incremento de tiempo es con #<dd>
 * */

module shift_left_tb();

reg clk;
reg rst;
wire [7:0] shift_out;

shift_left DUT ( .clk(clk),
                 .rst(rst),
                 .shift(shift_out));

always begin
    #10 clk = ~clk;
end

initial begin
$display($time,"<<< BEGIN >>>");
$monitor("%d\t%d\t%d\t%b\t", $time, clk, rst, shift_out);
    clk = 1'b0;
    rst = 1'b1;
#15  rst = 1'b0;
#200 $finish;
end

/* FOR GTK WAVE */
initial
  begin
    $dumpfile("shift.vcd");
    $dumpvars(0, shift_left_tb);
  end

endmodule /* shift_left_tb */
