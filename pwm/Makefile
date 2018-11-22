APP=pwm
APP_TB=${APP}_tb
# for windows
#IVERILOG="C:\iverilog\bin\iverilog.exe" 
#VVP="C:\iverilog\bin\vvp.exe"
#GTK_WAVE="C:\iverilog\gtkwave\bin\gtkwave.exe" 
# Linux
IVERILOG=iverilog
VVP=vvp
GTK_WAVE=gtkwave

all: clean comp run

clean:
	rm -rf *.log  ${APP}.vcd ${APP_TB}.exe

comp:
	${IVERILOG} -o ${APP_TB}.exe ${APP}.v ${APP_TB}.v

run:
	${VVP} ${APP_TB}.exe
	${GTK_WAVE} ${APP}.vcd &
