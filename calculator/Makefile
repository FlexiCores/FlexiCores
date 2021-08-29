HEX := hex
SRC := src

SOURCES := $(wildcard $(SRC)/*.asm)
HEXES := $(patsubst $(SRC)/%.asm, $(HEX)/%.hex, $(SOURCES))

all: $(HEXES)
	echo $(HEXES)

$(HEX)/%.hex: $(SRC)/%.asm
	python3 assembler.py $< >$@

