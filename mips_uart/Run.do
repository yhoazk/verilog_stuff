vlog -reportprogress 300 -work work C:/questasim_6.5c/examples/MIPS_UART/Src/UART/baid_generator.v C:/questasim_6.5c/examples/MIPS_UART/Src/UART/Pulse_Generator.v C:/questasim_6.5c/examples/MIPS_UART/Src/UART/PushButton_Debouncer.v C:/questasim_6.5c/examples/MIPS_UART/Src/UART/UART.v C:/questasim_6.5c/examples/MIPS_UART/Src/UART/Rx_uart_v2.v C:/questasim_6.5c/examples/MIPS_UART/Src/UART/tx_uart.v C:/questasim_6.5c/examples/MIPS_UART/Src/UART/uart_tx.v
vlog -reportprogress 300 -work work C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/muxN_N.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/ALU_Cntrl.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/SignExtend.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/Mux4.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/ALU.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/SyncLoadReg.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/SyncLoadRegEn.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/Cntrl_FSM.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/MIPS_Multi.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/DualPortMem.v C:/questasim_6.5c/examples/MIPS_UART/Src/MIPS/Data_Mem.v

vsim -voptargs=+acc work.Calc

add wave \
{sim:/Calc/Top_MIPS/RegFile/Mem } 
add wave \
{sim:/Calc/Top_MIPS/IDMem/memory } 
add wave \
{sim:/Calc/Top_MIPS/PC/Data } 
add wave \
{sim:/Calc/Top_MIPS/Cntrl/State } 


add wave \
{sim:/Calc/Top_UART/Transmisor/SW_data } 

add wave \
{sim:/Calc/Top_MIPS/OutW } 

add wave sim:/Calc/*
force -freeze sim:/Calc/clk_T 0 0, 1 {25 ns} -r 50
force -freeze sim:/Calc/Prty_Sel 0 0
force -freeze sim:/Calc/SendSign 0 0
force -freeze sim:/Calc/clr_T 0 0
run 100
force -freeze sim:/Calc/clr_T St1 0
run 397