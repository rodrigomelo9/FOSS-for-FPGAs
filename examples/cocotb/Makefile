VERILOG_SOURCES += ../vlog/counter.v
TOPLEVEL = counter
MODULE = counter

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	@rm -fr __pycache__ *.vcd *.xml *.o counter
