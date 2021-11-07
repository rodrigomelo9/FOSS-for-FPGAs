#!/usr/bin/make

ODIR=_build
OPTS=--theme moon --static $(ODIR)

vpath %.html $(ODIR)

%.html: %.md
	reveal-md $(OPTS) $<
	reveal-md $(OPTS) index.md

html: foss-for-fpga.html cocotb.html

clean:
	rm -fr $(ODIR)
