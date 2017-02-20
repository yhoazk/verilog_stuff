all: clean comp run

clean:
	rm -rf *.log division.vcd division_tb.exe

comp:
	"C:\iverilog\bin\iverilog.exe" -o division_tb.exe division.v division_tb.v

run:
	"C:\iverilog\bin\vvp.exe" division_tb.exe
	"C:\iverilog\gtkwave\bin\gtkwave.exe" division.vcd &
