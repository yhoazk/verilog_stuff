all: clean comp run

clean:
	rm -rf *.log shift.vcd shift_tb.exe

comp:
	iverilog -o shift_tb.exe shift_left.v shift_left_tb.v

run:
	vvp shift_tb.exe
	gtkwave shift.vcd &
