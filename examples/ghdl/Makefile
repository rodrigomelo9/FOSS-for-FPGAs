PROJECT=counter
SOURCE=../vhdl
BUILD=_build

PWD = $(shell pwd)

DOCKER=docker run --rm -v $(PWD)/..:$(PWD)/.. -w $(PWD)
SIM_IMG=hdlc/sim:osvb
SYN_IMG=hdlc/ghdl:yosys

sim $(BUILD)/$(PROJECT).ghw:
	$(DOCKER) $(SIM_IMG) mkdir -p $(BUILD)
	$(DOCKER) $(SIM_IMG) ghdl -a --workdir=$(BUILD) --work=$(PROJECT)_lib $(SOURCE)/$(PROJECT).vhdl $(SOURCE)/$(PROJECT)_pkg.vhdl
	$(DOCKER) $(SIM_IMG) ghdl -a --workdir=$(BUILD) -P$(BUILD) $(SOURCE)/$(PROJECT)_tb.vhdl
	$(DOCKER) $(SIM_IMG) ghdl -e --workdir=$(BUILD) -P$(BUILD) -o $(BUILD)/$(PROJECT)_tb $(PROJECT)_tb
	$(DOCKER) $(SIM_IMG) $(BUILD)/$(PROJECT)_tb --wave=$(BUILD)/$(PROJECT).ghw

syn:
	$(DOCKER) $(SYN_IMG) mkdir -p $(BUILD)
	$(DOCKER) $(SYN_IMG) ghdl -a --workdir=$(BUILD) $(SOURCE)/$(PROJECT).vhdl
	$(DOCKER) $(SYN_IMG) bash -c 'ghdl --synth --workdir=$(BUILD) -P$(BUILD) $(PROJECT) > $(BUILD)/$(PROJECT)_syn.vhdl'
	$(DOCKER) $(SYN_IMG) bash -c 'ghdl --synth --workdir=$(BUILD) -P$(BUILD) --out=verilog $(PROJECT) > $(BUILD)/$(PROJECT)_syn.v'

view: $(BUILD)/$(PROJECT).ghw
	gtkwave $(BUILD)/$(PROJECT).ghw

clean:
	$(DOCKER) $(SIM_IMG) rm -fr $(BUILD)
