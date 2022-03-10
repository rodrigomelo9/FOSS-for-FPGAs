DOCKER="docker run --rm -v $PWD/..:$PWD/.. -w $PWD"
IMAGE=hdlc/sim:osvb

$DOCKER $IMAGE make -C counter SIM=icarus

$DOCKER $IMAGE make -C counter SIM=ghdl VHDL_SOURCES=../../vhdl/counter.vhdl VERILOG_SOURCES=

$DOCKER $IMAGE make -C factory

$DOCKER $IMAGE make -C logging
$DOCKER $IMAGE make -C logging COCOTB_LOG_LEVEL=debug

$DOCKER $IMAGE make -C counter clean
$DOCKER $IMAGE make -C factory clean
$DOCKER $IMAGE make -C logging clean
