
.PHONY: clean

DESIGN_SRCS = $(addprefix ../rtl/, \
	alu.v \
	core.v \
	datapath.v \
	decoder.v \
	decoder2_4.v \
	params.v \
	pc.v \
	regfile.v \
)

compile:
	vcs -sverilog -debug_access+r +incdir+../rtl $(DESIGN_SRCS) tb.sv


clean:
	rm -rf csrc simv simv.daidir
