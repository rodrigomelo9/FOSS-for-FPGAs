import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


async def gen_reset(dut, cycles=1):
    """Generate reset."""

    await RisingEdge(dut.clk_i)
    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, cycles)
    dut.rst_i.value = 0


@cocotb.test()
async def test_reset(dut):
    """Test the reset value output"""

    cocotb.fork(Clock(dut.clk_i, 10, units='ns').start())

    await gen_reset(dut)
    await RisingEdge(dut.clk_i)
    assert dut.cnt_o.value == 0, f"reset value was incorrect"


@cocotb.test()
async def test_counter(dut):
    """Test the counter output"""

    cocotb.fork(Clock(dut.clk_i, 10, units='ns').start())

    await gen_reset(dut, 2)

    for i in range(10):
        await RisingEdge(dut.clk_i)
        assert dut.cnt_o.value == i, f"counter value was incorrect on the {i}th cycle"

@cocotb.test()
async def test_overflow(dut):
    """Test the overflow condition"""

    cocotb.fork(Clock(dut.clk_i, 10, units='ns').start())

    await gen_reset(dut)

    for i in range(16):
        await RisingEdge(dut.clk_i)

    await RisingEdge(dut.clk_i)
    assert dut.cnt_o.value == 0, f"counter value was incorrect after overflow"
