/* Test bech for a simple FSM */
module fsm_0_tb();
reg [7:0] state;
reg [7:0] out_val;
reg clk;
reg rstn;

fsm_0 DUT (
     .clk(clk),
     .rstn(rstn),
     .in_val(state),
     .out_val()
    );
/* Clock generation */
always begin
    #10 clk = ~clk;
end

/* Stimuli generation */
initial begin
    clk = 1'b0;
    rstn = 1'b1;
#15 rstn = 1'b0; // start
#200 $finish;
end

//task state_change;
input [7:0]state2set;
//#15 

initial begin
    $monitor();
end

/* For GTK wave simulation*/
initial begin
    $dumpfile("fsm_0.vcd");
    $dumpvars(0, fsm_0_tb);
end

endmodule /* fsm_0_tb */
