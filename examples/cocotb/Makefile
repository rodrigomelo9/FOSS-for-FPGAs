VERILOG_SOURCES += ../vlog/counter.v
TOPLEVEL = counter
MODULE = counter

SIM ?= icarus

ifeq ($(SIM), icarus) # Hack for iverilog (should be before the Makefile include)
	VERILOG_SOURCES += iverilog_dump.v
	COMPILE_ARGS += -s iverilog_dump
endif

include $(shell cocotb-config --makefiles)/Makefile.sim

ifeq ($(SIM), icarus) # Hack for iverilog (should be after the Makefile include)
iverilog_dump.v:
	@echo 'module iverilog_dump();' > $@
	@echo 'initial begin' >> $@
	@echo '    $$dumpfile("$(TOPLEVEL).vcd");' >> $@
	@echo '    $$dumpvars(0, $(TOPLEVEL));' >> $@
	@echo 'end' >> $@
	@echo 'endmodule' >> $@
endif

view:
	gtkwave counter.vcd &

clean::
	@rm -fr __pycache__ *.vcd *.xml *.o counter iverilog_dump.v
