/*
 * Modulo de PWM se da como parametro la 
 * freq del clk. El duty cicle y el periodo
 * son variables.
 *
 * el periodo se basa en la comparacion del contador
 * respecto a la entrada del PWM, si period es menor
 * que el counter sigue contando si no se pasa a estado
 * de reset.
 * 
 * el duty cicle es parecido, si es menor que el counter
 * la salida pasa a cero.
 *
 *
 * */


module pwm #(parameter CLK_FREQ = 100000) (
    input clk,
    input nrst,
    input [6:0] duty_percent,
    input [31:0] period,
    output reg pwm_out
);

reg [31:0] counter;
reg [31:0] duty;
reg period_end;

reg cycle_end;

reg [1:0]ss_period_end;

/* Should this be edge alinged? */
always@(*) begin
    period_end = (period == counter)? 1'b1:1'b0;
end

always@(*) begin
    cycle_end = (duty == counter)? 1'b1:1'b0;
end

always@(posedge clk) begin
        if(nrst)begin
                pwm_out <= 'b0;
        end else begin
                pwm_out <= pwm_out ^ cycle_end;
        end
end

/* reset the counter for the next period */
always @(posedge clk)begin
    if(nrst) begin
        ss_period_end <= 2'b0;
    end else begin
        ss_period_end <= {ss_period_end[0], period_end};
    end
end

/**
 * 
 * */
wire end_period = ss_period_end[0] == 1'b0 && ss_period_end[1] == 1'b1;

always @(posedge clk) begin
    if(nrst) begin
        counter <= 'b0;
    end else  begin
        if(period_end) 
            counter <= 'b0;
        else
            counter <= counter + 32'b1;    
    end
end

/* Adjust the duty cycle to the percentage */
always @(posedge clk) begin
    if(nrst) begin
        duty <= 'b0;
    end else  begin
        if(cycle_end) 
            duty <= 'b0;
        else 
            duty <= duty + 32'b1;    
    end
end



endmodule
