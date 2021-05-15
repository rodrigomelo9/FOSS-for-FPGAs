BUILD=_build
DOCKER=docker run --rm -v $(PWD)/..:$(PWD)/.. -w $(PWD)

sim:
	$(DOCKER) hdlc/sim:osvb mkdir -p $(BUILD)
	$(DOCKER) hdlc/sim:osvb ghdl -a --workdir=$(BUILD) --work=COUNTER_LIB ../vhdl/counter.vhdl ../vhdl/counter_pkg.vhdl
	$(DOCKER) hdlc/sim:osvb ghdl -a --workdir=$(BUILD) -P$(BUILD) ../vhdl/counter_tb.vhdl
	$(DOCKER) hdlc/sim:osvb ghdl -e --workdir=$(BUILD) -P$(BUILD) -o $(BUILD)/counter_tb counter_tb
	$(DOCKER) hdlc/sim:osvb $(BUILD)/counter_tb --wave=$(BUILD)/counter.ghw

syn:
	$(DOCKER) hdlc/impl mkdir -p $(BUILD)
	$(DOCKER) hdlc/impl ghdl -a --workdir=$(BUILD) ../vhdl/counter.vhdl
	$(DOCKER) hdlc/impl bash -c 'ghdl --synth --workdir=$(BUILD) -P$(BUILD) counter > $(BUILD)/counter_syn.vhdl'
	$(DOCKER) hdlc/impl bash -c 'ghdl --synth --workdir=$(BUILD) -P$(BUILD) --out=verilog counter > $(BUILD)/counter_syn.v'

view:
	gtkwave $(BUILD)/counter.ghw

clean:
	$(DOCKER) hdlc/sim:osvb rm -fr build
