from random import randrange
import cocotb
from cocotb.regression import TestFactory

async def example(dut, a, b, c):
    dut._log.info(f'* A={a} - B={b} - C={c}')

tf1 = TestFactory(test_function=example)
tf1.add_option('a', range(2))
tf1.add_option(('b', 'c'), [(0, 1), (2, 3)])
tf1.generate_tests(prefix='pre_')

tf2 = TestFactory(test_function=example)
tf2.add_option('a', range(2))
tf2.add_option('b', [randrange(16), randrange(16, 32)])
tf2.add_option('c', [0])
tf2.generate_tests(postfix='_post')
