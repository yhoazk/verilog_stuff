APP=lfsr
APP_TB=${APP}_tb
all: clean comp run

clean:
	rm -rf *.log ${APP}.vcd ${APP_TB}.exe

comp:
	iverilog -o ${APP_TB}.exe ${APP}.v ${APP_TB}.v

run:
	vvp ${APP_TB}.exe
	gtkwave ${APP}.vcd &
