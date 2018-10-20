module ffd_tb;

reg clk, rstn, stimuli;
wire dout;

ffd DUT(
    .clk(clk),
    .rstn(rstn),
    .in(stimuli),
    .d(dout)
);

always begin
#5    clk = ~clk;
end

initial begin
    clk = 1'b0;
    rstn = 1'b1;
#11  rstn = 1'b0; // enable FFD
#10 stimuli = 1'b0;
#20 stimuli = 1'b1;
#15 $finish;
end

/* FOR GTK WAVE */
initial
  begin
    $dumpfile("ffd.vcd"); // DUT name
    $dumpvars(0, ffd_tb); // TB name
  end
endmodule