import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles


@cocotb.test()
async def test_reset(dut):
    cocotb.start_soon(Clock(dut.clk_i, 10, units='ns').start())
    await Reset(dut)
    await RisingEdge(dut.clk_i)
    assert dut.cnt_o.value == 0, 'counter is not 0 after reset'


@cocotb.test()
async def test_counter(dut):
    cocotb.start_soon(Clock(dut.clk_i, 10, units='ns').start())
    await Reset(dut, 2)
    for i in range(10):
        await RisingEdge(dut.clk_i)
        assert dut.cnt_o.value == i, f'counter is wrong at index {i}'


@cocotb.test()
async def test_overflow(dut):
    clock = Clock(dut.clk_i, 10, units='ns')
    cocotb.start_soon(clock.start())
    await Reset(dut)
    for i in range(16):
        await RisingEdge(dut.clk_i)
    await RisingEdge(dut.clk_i)
    assert dut.cnt_o.value == 0, 'counter is not 0 after overflow'


async def Reset(dut, cycles=1):
    await RisingEdge(dut.clk_i)
    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, cycles)
    dut.rst_i.value = 0