module division_tb();

reg clk;
reg rst;
reg [7:0] numerator;
reg [7:0] denominator;
reg start;

wire [7:0] integer_result;
wire [7:0] reminder_result;
wire done_flag;

mod_div DUT (
     .clk(clk),
     .rst(rst),
     .start(start),
     .num(numerator),
     .den(denominator),
     .res(integer_result),
     .rem(reminder_result),
     .done(done_flag)
 );


always begin
    #10 clk = ~clk;
end

initial begin
    clk = 1'b0;
    rst = 1'b1;
#15 rst = 1'b0;
    numerator = 17;
    denominator = 5;
#1  start = 1;
#20 start = 0;
#200 $finish;
end

/* FOR GTK WAVE */
initial
  begin
    $dumpfile("division.vcd");
    $dumpvars(0, division_tb);
  end

endmodule 

