DOCKER="docker run --rm -v $PWD/..:$PWD/.. -w $PWD"
IMAGE=hdlc/sim:osvb

$DOCKER $IMAGE make -C counter SIM=icarus

$DOCKER $IMAGE make -C counter SIM=ghdl VHDL_SOURCES=../../vhdl/counter.vhdl VERILOG_SOURCES=

$DOCKER $IMAGE make -C factory

$DOCKER $IMAGE make -C counter clean
$DOCKER $IMAGE make -C factory clean
