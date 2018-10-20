module fsm_0(
    input clk,
    input rstn,
    input [7:0] in_val,
    output [7:0] out_val
    );

localparam STATE_INITIAL = 5'b0_0001;
localparam STATE_FIRST   = 5'b0_0010;
localparam STATE_SECOND  = 5'b0_0100;
localparam STATE_THIRD   = 5'b0_1000;
localparam STATE_FOURTH  = 5'b1_0000;


localparam OUT_ST_0 = 8'b0000_0001;
localparam OUT_ST_1 = 8'b0000_0011;
localparam OUT_ST_2 = 8'b0000_0101;
localparam OUT_ST_3 = 8'b0000_1001;
localparam OUT_ST_4 = 8'b0001_0001;


reg [7:0] out_val;
reg [4:0] curr_state;


reg [4:0] nxt_state;
/* Next state logic */
always@(*)begin
    nxt_state = curr_state;
    case(curr_state)
    STATE_INITIAL: begin
        if(in_val == 8'b1000_0001)begin
            nxt_state = STATE_FIRST;
        end else begin
            nxt_state = STATE_INITIAL;
        end
    end
    STATE_FIRST: begin
        if(in_val == 8'b0100_0010)begin
            nxt_state = STATE_SECOND;
        end else begin
            nxt_state = STATE_INITIAL;
        end
    end
    STATE_SECOND: begin
        if(in_val == 8'b0010_0100)begin
            nxt_state = STATE_THIRD;
        end else begin
            nxt_state = STATE_INITIAL;
        end
    end
    STATE_THIRD: begin
        if(in_val == 8'b0001_1000)begin
            nxt_state = STATE_FOURTH;
        end else begin
            nxt_state = STATE_INITIAL;
        end
    end
    STATE_FOURTH: begin
        if(in_val == 8'b0001_1100)begin
            nxt_state = STATE_FOURTH;
        end else begin
            nxt_state = STATE_INITIAL;
        end
    end
    default: begin
        nxt_state = curr_state;
    end
end

always@(posedge clk) begin
    if(rstn == 1'b0)begin
        out_val <= 8'b0;
        end else begin
            out_val <= out_val;
          case(curr_state)
            STATE_INITIAL: begin
              out_val <= OUT_ST_0;
            end
            STATE_FIRST: begin
              out_val <= OUT_ST_1;
            end
            STATE_SECOND: begin
              out_val <= OUT_ST_2;
            end
            STATE_THIRD: begin
              out_val <= OUT_ST_3;
            end
            STATE_FOURTH: begin
              out_val <= OUT_ST_4;
            end
        end
end

always@(posedge clk)begin
    if(rstn == 1'b0)begin
        curr_state <= STATE_INITIAL;
    end
    else begin
        curr_state <= nxt_state;
    end
end




endmodule /*fsm_0*/ 
