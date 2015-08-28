all: clean comp run

clean:
	rm -rf *.log fsm_0.vcd fsm_0_tb.exe

comp:
	iverilog -o fsm_0_tb.exe fsm_0.v fsm_0_tb.v

run:
	vvp fsm_0_tb.exe
	gtkwave fsm_0.vcd &
