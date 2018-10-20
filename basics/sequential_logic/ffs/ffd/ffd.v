
/* Implementation of Flip flop d */
module ffd(input clk, input rstn, input in, output  d);
reg mem;
assign d = mem;
// Sync reset type, the type of reset is dependant on the arch
// of the Logic block RTFM
always @(posedge clk) begin
    if (!rstn) begin
        mem <= in;
    end else begin
        mem <= 1'b0;
    end
end

endmodule /* ffd */