VERILOG_SOURCES += ../../vlog/counter.v
TOPLEVEL = counter
MODULE = example

include $(shell cocotb-config --makefiles)/Makefile.sim

clean::
	@rm -fr __pycache__ *.xml *.o counter
