import cocotb
from cocotb.triggers import Timer, with_timeout

@cocotb.test(timeout_time=3, timeout_unit='ns')
async def test_timeout_pass(dut):
    await Timer(2, 'ns')

@cocotb.test()
async def trigger_timeout_pass(dut):
    await with_timeout(Timer(2, 'ns'), 3, 'ns')

@cocotb.test(timeout_time=1, timeout_unit='ns', expect_error=cocotb.result.SimTimeoutError)
async def test_timeout_fail(dut):
    await Timer(2, 'ns')

@cocotb.test(expect_error=cocotb.result.SimTimeoutError)
async def trigger_timeout_fail(dut):
    await with_timeout(Timer(2, 'ns'), 1, 'ns')
