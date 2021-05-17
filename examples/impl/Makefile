# Based on an example from https://github.com/im-tomu/fomu-workshop

PROJECT=top
BUILD=_build
VHDLS=../vhdl/counter.vhdl ../vhdl/top.vhdl

# EDU-CIAA-FPGA
PCF=../constraints/edu-ciaa-fpga.pcf
PNRFLAGS = --hx8k --package tq144:4k

PWD = $(shell pwd)

DOCKER=docker run --rm -v $(PWD)/..:$(PWD)/.. -w $(PWD)
YOSYS_IMG   = hdlc/ghdl:yosys
NEXTPNR_IMG = hdlc/nextpnr:ice40
ICEPACK_IMG = hdlc/icestorm
PROG_IMG    = hdlc/prog

all: $(BUILD)/$(PROJECT).bit

$(BUILD)/$(PROJECT).json: $(VHDLS)
	mkdir -p $(BUILD)
	$(DOCKER) $(YOSYS_IMG) yosys -m ghdl -p \
		"ghdl $^ -e; synth_ice40 -top $(PROJECT) -json $@"

$(BUILD)/$(PROJECT).asc: $(BUILD)/$(PROJECT).json $(PCF)
	$(DOCKER) $(NEXTPNR_IMG) nextpnr-ice40 $(PNRFLAGS) --pcf $(PCF) --json $< --asc $@

$(BUILD)/$(PROJECT).bit: $(BUILD)/$(PROJECT).asc
	$(DOCKER) $(ICEPACK_IMG) icepack $< $@

prog: $(BUILD)/$(PROJECT).bit
	$(DOCKER) --device /dev/bus/usb $(PROG_IMG) iceprog $(BUILD)/$(PROJECT).bit

clean:
	$(DOCKER) $(YOSYS_IMG) rm -fr $(BUILD)
