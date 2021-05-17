PROJECT=top
BUILD=_build
VHDLS=../vhdl/counter.vhdl ../vhdl/top.vhdl

# EDU-CIAA-FPGA
PCF=../constraints/edu-ciaa-fpga.pcf
PNRFLAGS = --hx8k --package tq144:4k

DOCKER=docker run --rm -v $(PWD)/..:$(PWD)/.. -w $(PWD)
YOSYS_IMG   = hdlc/ghdl:yosys
NEXTPNR_IMG = hdlc/nextpnr:ice40
ICEPACK_IMG = hdlc/icestorm

all: $(BUILD)/$(PROJECT).bit

# Use *Yosys* to generate the synthesized netlist.
# This is called the **synthesis** and **tech mapping** step.
$(BUILD)/$(PROJECT).json: $(VHDLS)
	mkdir -p $(BUILD)
	$(DOCKER) $(YOSYS_IMG) yosys -m ghdl -p \
		"ghdl $^ -e; synth_ice40 -top $(PROJECT) -json $@"

# Use **nextpnr** to generate the FPGA configuration.
# This is called the **place** and **route** step.
$(BUILD)/$(PROJECT).asc: $(BUILD)/$(PROJECT).json $(PCF)
	$(DOCKER) $(NEXTPNR_IMG) nextpnr-ice40 $(PNRFLAGS) --pcf $(PCF) --json $< --asc $@

# Use icepack to convert the FPGA configuration into a "bitstream" loadable onto the FPGA.
# This is called the bitstream generation step.
$(BUILD)/$(PROJECT).bit: $(BUILD)/$(PROJECT).asc
	$(DOCKER) $(ICEPACK_IMG) icepack $< $@

clean:
	$(DOCKER) $(YOSYS_IMG) rm -fr $(BUILD)
