
/* Implementation of Flip flop SR set reset */

/****************************************************************
Exitation table for the  FF SR

 y(t)   S(t)    R(t)     y(t+1)
 ------------------------------
   0     0       0        0
   0     0       1        0
   0     1       1        X
   0     1       0        1
   1     1       0        1
   1     1       1        X
   1     0       1        0
   1     0       0        1

****************************************************************/

module ffsr(input clk, input rstn, input s, input r, output  q);
reg mem;
assign q = mem;
// Sync reset type, the type of reset is dependant on the arch
// of the Logic block RTFM
always @(posedge clk) begin
    if (!rstn) begin
        case({s,r})
        2'b00: begin
            mem <= mem;
        end
        2'b01: begin
            mem <= 1'b0;
        end
        2'b10: begin
            mem <= 1'b1;
        end
        default: begin
            mem <= mem;
        end
        endcase
    end else begin
        mem <= 1'b0;
    end
end

endmodule /* ffd */