import cocotb
from cocotb.result import TestSuccess, SimTimeoutError
from cocotb.triggers import Timer, with_timeout

@cocotb.test()
async def test_pass(dut):
    assert 1<2

@cocotb.test()
async def test_success(dut):
    raise TestSuccess("Reason")
    assert 1>2

@cocotb.test(expect_fail=True)
async def test_fail(dut):
    assert 1>2

@cocotb.test(expect_error=SimTimeoutError)
async def test_error(dut):
    await with_timeout(Timer(2, 'ns'), 1, 'ns')
