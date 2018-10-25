module ffsr_tb;

reg clk, rstn, s_in, r_in;
wire sr_out;

ffsr DUT(
    .clk(clk),
    .rstn(rstn),
    .s(s_in),
    .r(r_in),
    .q(sr_out)
);

always begin
#5    clk = ~clk;
end

initial begin
    clk = 1'b0;
    rstn = 1'b1;
#11 rstn = 1'b0; // enable FFD
#10 s_in = 1'b0; r_in = 1'b1;
#10 s_in = 1'b1; r_in = 1'b1;
#10 s_in = 1'b1; r_in = 1'b0;
#15 $finish;
end

/* FOR GTK WAVE */
initial
  begin
    $dumpfile("ffsr.vcd"); // DUT name
    $dumpvars(0, ffsr_tb); // TB name
  end
endmodule