PROJECT=counter
SOURCE=../vlog
BUILD=_build

PWD = $(shell pwd)

DOCKER=docker run --rm -v $(PWD)/..:$(PWD)/.. -w $(PWD)
IMAGE=hdlc/sim:osvb

lint:
	$(DOCKER) $(IMAGE) verilator --lint-only -Wall $(SOURCE)/$(PROJECT).v
