/*
 * */
module shift_left( clk,  rst,  shift);
 input clk;
 input rst;
 output [7:0] shift;

reg [7:0] shift_r;
always @(posedge clk) begin
    if(rst == 1'b1) begin
        shift_r <= 8'b0000_0001;
    end else begin
        shift_r <= {shift_r[6:0], shift_r[7]};
    end
end

assign shift[7:0] = shift_r[7:0];

endmodule /* shift_left */
