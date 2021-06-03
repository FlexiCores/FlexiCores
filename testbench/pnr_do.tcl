vlog -sv -work pnr_work ../out_pnr/core.v ../../lib/lib_dstd.v
vlog -sv -work work testbench.sv

vsim -L work -L pnr_work testbench
