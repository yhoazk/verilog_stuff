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


module pwm #(parameter CLK_FREQ = 100000,
                ) (
        input clk,
        input rst,
        input [6:0] duty_percent,
        input [31:0] period,
        output reg  pwm_out
);

reg [31:0] counter;
reg period_end;
reg cycle_end;
always@(*) begin
        period_end = (period >= counter)? 1'b1:1'b0;
end

always@(*) begin
        cycle_end = (duty >= counter)? 1'b1:1'b0;
end

always @(posedge clk or posedge rst)begin
        if(rst or period_end or cycle_end)
end

/**
 * 
 * ***/
always @(posedge clk or posedge rst) begin
        if(rst or period_end) begin
            counter <= 'b0;
        end
            else  begin
                counter <= counter + 1'b1;    
            end
end


endmodule
