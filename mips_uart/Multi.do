vlog -reportprogress 300 -work work C:/questasim_6.5c/examples/MIPS_Multi/Src/MIPS_Multi.v C:/questasim_6.5c/examples/MIPS_Multi/Src/muxN_N.v C:/questasim_6.5c/examples/MIPS_Multi/Src/ALU_Cntrl.v C:/questasim_6.5c/examples/MIPS_Multi/Src/SignExtend.v C:/questasim_6.5c/examples/MIPS_Multi/Src/ALU.v C:/questasim_6.5c/examples/MIPS_Multi/Src/SyncLoadReg.v C:/questasim_6.5c/examples/MIPS_Multi/Src/Cntrl_FSM.v C:/questasim_6.5c/examples/MIPS_Multi/Src/Mux4.v C:/questasim_6.5c/examples/MIPS_Multi/Src/DualPortMem.v C:/questasim_6.5c/examples/MIPS_Multi/Src/Data_Mem.v C:/questasim_6.5c/examples/MIPS_Multi/Src/SyncLoadRegEn.v


vsim -vopt -voptargs=+acc work.MIPS_Multi

add wave sim:/MIPS_Multi/*
add wave \
{sim:/MIPS_Multi/RegFile/Mem } 
add wave \
{sim:/MIPS_Multi/RegFile/WrAddr } 
add wave \
{sim:/MIPS_Multi/Cntrl/State } 

add wave \
{sim:/MIPS_Multi/IDMem/memory } 



force -freeze sim:/MIPS_Multi/rst_n 0 0
force -freeze sim:/MIPS_Multi/clk 0 0, 1 {50 ns} -r 100
run 40
force -freeze sim:/MIPS_Multi/rst_n St1 0
run 60
force -freeze sim:/MIPS_Multi/rst_n 0 0
run 20
force -freeze sim:/MIPS_Multi/rst_n St1 0

