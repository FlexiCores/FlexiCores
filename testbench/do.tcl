vlog -sv -work work  ../rtl/pc.v ../rtl/alu.v ../rtl/core.v ../rtl/decoder.v ../rtl/regfile.v ../rtl/datapath.v ../rtl/decoder3_8.v
vlog -sv -work work testbench.sv

vsim -L work testbench
