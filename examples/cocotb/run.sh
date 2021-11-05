DOCKER="docker run --rm -v $PWD/..:$PWD/.. -w $PWD"
IMAGE=hdlc/sim:osvb

$DOCKER $IMAGE make SIM=icarus VERILOG_SOURCES=../vlog/counter.v

$DOCKER $IMAGE make SIM=ghdl VHDL_SOURCES=../vhdl/counter.vhdl VERILOG_SOURCES=

$DOCKER $IMAGE make clean
