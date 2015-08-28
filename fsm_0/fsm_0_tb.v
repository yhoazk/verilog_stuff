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


initial begin
    $dumpfile();
    $dumpvars();
end


task state_change;
    input [7:0]state2set;
#15 

initial begin
    $monitor();
end



endmodule /* fsm_0_tb */
