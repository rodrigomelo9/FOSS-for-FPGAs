#!/usr/bin/make

ODIR=_build
OPTS=--theme moon --static $(ODIR)

vpath %.html $(ODIR)

%.html: %.md
	reveal-md $(OPTS) $<

html: cocotb.html README.html

clean:
	rm -fr $(ODIR)
