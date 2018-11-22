

module pwm_tb ();

reg clk;
reg rst;
reg [6:0] duty_cycle;
reg [31:0] per;
wire out;

always begin
  #5 clk = ~clk;
end

  pwm DUT(
    .clk(clk),
    .nrst(rst),
    .duty_percent(duty_cycle),
    .period(per),
    .pwm_out(out)
  );


initial begin
    duty_cycle = 10;
    per = 20;
    clk = 1'b0;
    rst = 1'b1;
#15 rst = 1'b0;
#900 $finish;
end
/* FOR GTK WAVE */
initial
  begin
    $dumpfile("pwm.vcd");
    $dumpvars(0, pwm_tb);
  end
  
endmodule