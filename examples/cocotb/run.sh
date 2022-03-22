DOCKER="docker run --rm -v $PWD/..:$PWD/.. -w $PWD"
IMAGE=hdlc/sim:osvb

docker pull $IMAGE

$DOCKER $IMAGE make -C counter SIM=icarus

$DOCKER $IMAGE make -C counter SIM=ghdl VHDL_SOURCES=../../vhdl/counter.vhdl VERILOG_SOURCES=

$DOCKER $IMAGE make -C factory

$DOCKER $IMAGE make -C logging
$DOCKER $IMAGE make -C logging COCOTB_LOG_LEVEL=debug

$DOCKER $IMAGE make -C testend

$DOCKER $IMAGE make -C timeout

$DOCKER $IMAGE make -C counter clean
$DOCKER $IMAGE make -C factory clean
$DOCKER $IMAGE make -C logging clean
$DOCKER $IMAGE make -C testend clean
$DOCKER $IMAGE make -C timeout clean
