import cocotb

@cocotb.test()
async def example(dut):
    dut._log.debug("hello world!")
    dut._log.info("hello world!")
    dut._log.warning("hello world!")
    dut._log.error("hello world!")
    dut._log.critical("hello world!")
