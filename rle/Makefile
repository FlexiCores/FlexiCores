HEX := hex
SRC := src

SOURCES := $(wildcard $(SRC)/*.asm)
HEXES := $(patsubst $(SRC)/%.asm, $(HEX)/%.hex, $(SOURCES))

all: hex $(HEXES) simv
	mkdir -p hex

hex:
	mkdir -p hex

$(HEX)/%.hex: $(SRC)/%.asm
	python3 assembler.py $< >$@

simv:
	vcs -full64 -sverilog +incdir+../rtl tb/top.sv

clean:
	rm -rf simv.daidir tmp_dir_*_vcs csrc simv hex
