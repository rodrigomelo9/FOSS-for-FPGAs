<!-- .slide: data-background="#145A32" -->

# cocotb tutorial

#### (cocotb 1.8, python 3.6+)

[github.com/rodrigomelo9/FOSS-for-FPGAs](https://github.com/rodrigomelo9/FOSS-for-FPGAs)

**Rodrigo A. Melo**

[Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/)

---
<!-- ###################################################################### -->
## Introduction
<!-- ###################################################################### -->

![cocotb](images/logos/cocotb.png)

cocotb is a **CO**routine based **CO**simulation **T**est**B**ench environment for verifying
VHDL and (System)Verilog RTL using Python.

* **Repo:** [github.com/cocotb/cocotb](https://github.com/cocotb/cocotb)
* **Docs:** [docs.cocotb.org/en/stable](https://docs.cocotb.org/en/stable)

----

### Why cocotb?

* Writing Python is fast (very productive language).
* It's easy to interface to other languages.
* Has a huge library of existing code to re-use.
* It's interpreted, so tests can be edited and re-run without having to recompile.
* Far more engineers know Python than one HDL.

|     |
|:---:|
| cocotb was specifically designed to lower the overhead of creating a test |
|     |

----

### A Brief History of cocotb

```
* 2012: started by Chris Higgs and Stuart Hodgson (Potential Ventures).
* 2013: Open sourced (BSD, Jun). cocotb 0.1 (Jul), 0.2 (Jul) and 0.3 (Sep).
* 2014: cocotb 0.4 (Feb).
* 2015: cocotb 1.0 (Feb).
* 2018: FOSSi Foundation.
* 2019: cocotb 1.1 (Jan), 1.2 (Jul).
* 2020: cocotb 1.3 (Jan), 1.4 (Jul).
* 2021: cocotb 1.5 (Mar), 1.6 (Oct).
* 2022: cocotb 1.7 (Sep)
* 2023: cocotb 1.8 (Jun)
* cocotb 1.9/2.0 under development.
```
<!-- .element: style="font-size: 0.4em !important;" -->

![cocotb unofficial](images/logos/cocotb-unofficial.png)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![FOSSi](images/logos/fossi.png)

----

### How does it work?

![cocotb overview](images/diagrams/cocotb_overview.png)

**Source:** [docs.cocotb.org/en/stable](https://docs.cocotb.org/en/stable)

----

### Installation (Debian based systems)

```bash
apt install make python3 python3-pip
pip3 install cocotb
```

**Others:** [docs.cocotb.org/en/stable/install.html](https://docs.cocotb.org/en/stable/install.html)

### Supported simulators

[Icarus Verilog](https://github.com/steveicarus/iverilog),
[Verilator](https://github.com/verilator/verilator),
Synopsys VCS,
Aldec Riviera-PRO and Active-HDL,
Mentor Questa and ModelSim,
Cadence Incisive and Xcelium,
[GHDL](https://github.com/ghdl/ghdl),
Tachyon [CVC](https://github.com/cambridgehackers/open-src-cvc).

---
<!-- ###################################################################### -->
## Example
### (crash course)
<!-- ###################################################################### -->

----

### Elements of a simulation

* One (top-level) or more HDL files (the DUT)
* A Python script with one or more individual tests
* A `Makefile`

----

### DUT (HDL)

```verilog
module counter #(
    parameter          WIDTH=4
) (
    input              clk_i,
    input              rst_i,
    output [WIDTH-1:0] cnt_o
);

    reg [WIDTH-1:0] cnt;

    always @(posedge clk_i) begin
        if (rst_i == 1'b1)
            cnt <= {WIDTH{1'b0}};
        else
            cnt <= cnt + 1'b1;
    end

    assign cnt_o = cnt;

endmodule
```
<!-- .element: style="font-size: 0.40em !important;" -->

----

### Testbench (Python)

```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ClockCycles

@cocotb.test()
async def test_reset(dut):
    cocotb.start_soon(Clock(dut.clk_i, 10, units='ns').start())
    await Reset(dut)
    assert dut.cnt_o.value == 0, 'counter is not 0 after reset'

@cocotb.test()
async def test_counter(dut):
    cocotb.start_soon(Clock(dut.clk_i, 10, units='ns').start())
    await Reset(dut, 2)
    for i in range(16):
        assert dut.cnt_o.value == i, f'counter is wrong at index {i}'
        await RisingEdge(dut.clk_i)
    assert dut.cnt_o.value == 0, 'counter is not 0 after overflow'

async def Reset(dut, cycles=1):
    await RisingEdge(dut.clk_i)
    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, cycles)
    dut.rst_i.value = 0
    await RisingEdge(dut.clk_i)
```
<!-- .element: style="font-size: 0.30em !important;" -->

----

### Makefile

```makefile
VERILOG_SOURCES += ../vlog/counter.v
TOPLEVEL = counter
MODULE = counter

include $(shell cocotb-config --makefiles)/Makefile.sim

view:
	gtkwave counter.vcd &

clean::
	@rm -fr __pycache__ *.vcd *.xml *.o counter
```

----

### Run

```bash
make
```

![cocotb run](images/screens/cocotb-example.png)

or with docker
<!-- .element: style="font-size: 0.4em !important;" -->
```bash
docker run --rm -v $PWD/../../:$PWD/../../ -w $PWD hdlc/sim:osvb make
```
<!-- .element: style="font-size: 0.4em !important;" -->

----

### Waveforms

```bash
make view
```

![Waveforms](images/screens/gtkwave-counter.png)

---
<!-- ###################################################################### -->
## Writing Testbenches
### (The Python side)
<!-- ###################################################################### -->
----

### Structure of a Python testbench

```python
import cocotb                        # Concurrent and sequential execution
from cocotb.<MODULE> import <CLASS>  #
                                     # An *await* will run an *async*
@cocotb.test()                       # *coro* and wait for it to complete.
async def test1(dut):                #
    await <TRIGGER>|<CORO>           # The called *coro* blocks the execution
                                     # of the current *coro*.
@cocotb.test()                       #
async def test2(dut):                # Wrapping the call in *start()* or
    await <TRIGGER>|<CORO>           # *start_soon()* runs the *coro*
                                     # concurrently.
async def coro1(dut):                #
    await <TRIGGER>|<CORO>           # You can *await* the result of the
    [return <VALUE>]                 # forked *coro*, which will block until
                                     # the forked *coro* finishes.
async def coro2(dut):
    await <TRIGGER>|<CORO>
    [return <VALUE>]

def func():
    return <VALUE>
```
<!-- .element: style="font-size: 0.35em !important;" -->

----

### Accessing the design

```python
# When cocotb initializes it finds the toplevel instantiation
# in the simulator and creates a handler.

@cocotb.test()
async def my_test1(dut):
    dut.data_i.value = 1    # Write an input port
    data = dut.data_o.value # Read an output port
    width = dut.WIDTH.value # Read a generic/parameter
    data = dut.data_i       # Get a reference
    data.value = 1          # Write into the reference
    # Assign a value deep in the hierarchy
    dut.sub_block.memory.array[4].value = 2
    # Representations
    dout = dut.output_signal.value
    print(dout.binstr)  # 1X1010
    print(dout.integer) # 42
    print(dout.n_bits)  # 6 (number of bits)
```
<!-- .element: style="font-size: 0.35em !important;" -->

**WARNING:** a common mistake is forgetting **.value** (which just gives you a reference to the handler).

----

### Forcing and freezing signals

```python
# Deposit action
dut.my_signal.value = 12
dut.my_signal.value = Deposit(12)  # equivalent syntax

# Force action: my_signal stays 12 until released
dut.my_signal.value = Force(12)

# Release action: reverts any force/freeze assignments
dut.my_signal.value = Release()

# Freeze action: my_signal stays at current value until released
dut.my_signal.value = Freeze()
```
<!-- .element: style="font-size: 0.5em !important;" -->

----

### Clock and reset generation

```python
import cocotb
from cocotb.clock import Clock

@cocotb.test()
async def example(dut):
    cocotb.start_soon(Clock(dut.clk_i, 1, units='ns').start())
    await reset(dut)
    ...

async def reset(dut, cycles=1):
    dut.rst_i.value = 1
    await ClockCycles(dut.clk_i, cycles)
    dut.rst_i.value = 0
    await RisingEdge(dut.clk_i)
    dut._log.info("the core was reset")
```
<!-- .element: style="font-size: 0.5em !important;" -->

----

### Logging

It is based on Python logging
```python
@cocotb.test()
async def example(dut):
    dut._log.debug("hello world!")
    dut._log.info("hello world!")
    dut._log.warning("hello world!")
    dut._log.error("hello world!")
    dut._log.critical("hello world!")
```

![INFO logging](images/screens/cocotb-info.png)
![DEBUG logging](images/screens/cocotb-debug.png)

----

### Triggers

```python
from cocotb.triggers import RisingEdge, ... # Triggers are used to indicate when the cocotb
                                            # scheduler should resume coroutine execution.
async def coro():                           # To use a trigger, a coroutine should await it.
    print("Some time before the edge")      # This will cause execution of the current
    await RisingEdge(clk)                   # coroutine to pause. When the trigger fires,
    print("Immediately after the edge")     # execution of the paused coroutine will resume.

# Simulator Triggers
# * Signals
#   * RisingEdge(dut.clk)
#   * FallingEdge(dut.clk)
#   * Edge(dut.clk)
#   * ClockCycles(dut.clk, 3)
# * Timing
#   * Timer(100, units='ns')
# Python Triggers
# * Combine(*triggers)                      <-- Fires when all of triggers have fired
# * First(*triggers)                        <-- Fires when the first trigger in triggers fires.
# * Join(coro)                              <-- Fires when a task (a running coro) completes
# Synchronization
# * with_timeout(<trigger|coro>, 100, 'ns') <-- Useful to avoid not-ending simulations
```
<!-- .element: style="font-size: 0.35em !important;" -->

[Full list](https://docs.cocotb.org/en/latest/triggers.html)

----

### Passing and Failing Tests

```python
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
```
<!-- .element: style="font-size: 0.3em !important;" -->

```
     0.00ns INFO     running test_pass (1/4)
     0.00ns INFO     test_pass passed
     0.00ns INFO     running test_success (2/4)
     0.00ns INFO     test_success passed
     0.00ns INFO     running test_fail (3/4)
     0.00ns INFO     test_fail passed: failed as expected (result was AssertionError)
     0.00ns INFO     running test_error (4/4)
     1.00ns INFO     test_error passed: errored as expected (result was SimTimeoutError)
     1.00ns INFO     **************************************************************************************
                     ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                     **************************************************************************************
                     ** example.test_pass              PASS           0.00           0.00          1.97  **
                     ** example.test_success           PASS           0.00           0.00         14.61  **
                     ** example.test_fail              PASS           0.00           0.00         19.15  **
                     ** example.test_error             PASS           1.00           0.00       4373.44  **
                     **************************************************************************************
                     ** TESTS=4 PASS=4 FAIL=0 SKIP=0                  1.00           0.01        146.15  **
                     **************************************************************************************
```
<!-- .element: style="font-size: 0.3em !important;" -->

----

### Failing examples

```
     0.00ns INFO     running test_pass (1/4)
     0.00ns INFO     test_pass passed
     0.00ns INFO     running test_success (2/4)
     0.00ns INFO     test_success passed
     0.00ns INFO     running test_fail (3/4)
     0.00ns INFO     test_fail failed
                     Traceback (most recent call last):
                       File "/<PATH>/FOSS-for-FPGAs/examples/cocotb/testend/example.py", line 16, in test_fail
                         assert 1>2
                     AssertionError
     0.00ns INFO     running test_error (4/4)
     1.00ns INFO     test_error failed
                     Traceback (most recent call last):
                       File "/<PATH>/FOSS-for-FPGAs/examples/cocotb/testend/example.py", line 20, in test_error
                         await with_timeout(Timer(2, 'ns'), 1, 'ns')
                       File "/usr/local/lib/python3.8/dist-packages/cocotb/triggers.py", line 944, in with_timeout
                         raise cocotb.result.SimTimeoutError
                     cocotb.result.SimTimeoutError
     1.00ns INFO     **************************************************************************************
                     ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                     **************************************************************************************
                     ** example.test_pass              PASS           0.00           0.00          2.18  **
                     ** example.test_success           PASS           0.00           0.00         14.77  **
                     ** example.test_fail              FAIL           0.00           0.00         18.56  **
                     ** example.test_error             FAIL           1.00           0.00       4297.34  **
                     **************************************************************************************
                     ** TESTS=4 PASS=2 FAIL=2 SKIP=0                  1.00           0.01        145.35  **
                     **************************************************************************************
```
<!-- .element: style="font-size: 0.29em !important;" -->

----

### Timeout

```python
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
```
<!-- .element: style="font-size: 0.3em !important;" -->

```
     0.00ns INFO     running test_timeout_pass (1/4)
     2.00ns INFO     test_timeout_pass passed
     2.00ns INFO     running trigger_timeout_pass (2/4)
     4.00ns INFO     trigger_timeout_pass passed
     4.00ns INFO     running test_timeout_fail (3/4)
     5.00ns INFO     test_timeout_fail passed: errored as expected (result was SimTimeoutError)
     5.00ns INFO     running trigger_timeout_fail (4/4)
     6.00ns INFO     trigger_timeout_fail passed: errored as expected (result was SimTimeoutError)
     6.00ns INFO     **************************************************************************************
                     ** TEST                          STATUS  SIM TIME (ns)  REAL TIME (s)  RATIO (ns/s) **
                     **************************************************************************************
                     ** example.test_timeout_pass      PASS           2.00           0.00       2955.21  **
                     ** example.trigger_timeout_pass   PASS           2.00           0.00      10596.97  **
                     ** example.test_timeout_fail      PASS           1.00           0.00       4613.73  **
                     ** example.trigger_timeout_fail   PASS           1.00           0.00       5727.83  **
                     **************************************************************************************
                     ** TESTS=4 PASS=4 FAIL=0 SKIP=0                  6.00           0.01        856.96  **
                     **************************************************************************************
```
<!-- .element: style="font-size: 0.3em !important;" -->

----

### TestFactory

![TestFactory](images/screens/cocotb-tf.png)

---
<!-- ###################################################################### -->
## Build options
### (The Makefile side)
<!-- ###################################################################### -->

----

### Common variables

```
SIM = icarus|verilator|vcs|riviera|activehdl|questa|modelsim|ius|xcelium|ghdl|cvc

TOPLEVEL_LANG = <verilog|vhdl>
VERILOG_SOURCES += <LIST_OF_VERILOG_SOURCES>
VHDL_SOURCES += <LIST_OF_VHDL_SOURCES>
VHDL_SOURCES_<LIB> += <LIST_OF_VHDL_SOURCES_IN_LIB>

TOPLEVEL = <TOP_LEVEL_NAME>
MODULE = <PYTHON_SCRIPT_NAME_WITHOUT_PY_EXTENSION>

include $(shell cocotb-config --makefiles)/Makefile.sim
```
<!-- .element: style="font-size: 0.40em !important;" -->

----

### Verilog sources example

```
PATH = ../hdl/vlog
TOPLEVEL_LANG = verilog
VERILOG_SOURCES  = $(PATH)/file_1.v $(PATH)/file_2.v
VERILOG_SOURCES += $(PATH)/file_3.v $(PATH)/top.v
TOPLEVEL = top
```
<!-- .element: style="font-size: 0.40em !important;" -->

### VHDL sources example

```
PATH = ../hdl/vhdl
TOPLEVEL_LANG = vhdl
VHDL_SOURCES_lib1  = $(PATH)/file_a.vhdl $(PATH)/file_b.vhdl
VHDL_SOURCES_lib2  = $(PATH)/file_c.vhdl $(PATH)/file_d.vhdl
VHDL_SOURCES_lib2 += $(PATH)/file_e.vhdl
VHDL_SOURCES  = $(PATH)/file_1.vhdl $(PATH)/file_2.vhdl
VHDL_SOURCES += $(PATH)/file_3.vhdl $(PATH)/top.vhdl
TOPLEVEL = top
```
<!-- .element: style="font-size: 0.40em !important;" -->

----

### Passing variables from command-line

```
# Specify which simulator to use
make SIM=verilator

# Select which test/s to run
make TESTCASE=test_reset,test_counter

# Run with a specified seed (to recreate a previous run)
make RANDOM_SEED=<SEED>
```

----

### Other useful variables

* **COMPILE_ARGS**, **SIM_ARGS**, **EXTRA_ARGS**: arguments/flags for compile, execution or boths phases of the simulator (eg: generics/parameters).
* **COCOTB_ENABLE_PROFILING**: enable performance analysis of the Python portion.
* **COVERAGE**: enable to report Python coverage (and HDL in some simulators).
* **GUI**: enable this mode (if supported).

[Full list](https://docs.cocotb.org/en/stable/building.html)

---
<!-- ###################################################################### -->
## Miscellaneous
<!-- ###################################################################### -->

----

### Extensions

* [cocotb-bus](https://github.com/cocotb/cocotb-bus): reusable bus interfaces (AMBA, Avalon, others).
* [cocotbext-axi](https://github.com/alexforencich/cocotbext-axi): AXI, AXI lite, and AXI stream simulation models.
* [cocotb-coverage](https://github.com/mciepluc/cocotb-coverage): Functional Coverage and Constrained Randomization.

[Others](https://github.com/cocotb/cocotb/wiki/Further-Resources#extension-modules-cocotbext)

----

### PyUVM

* [PyUVM](https://github.com/pyuvm/pyuvm) is UVM (IEEE 1800.2) implemented in Python instead of SystemVerilog.
* It uses cocotb to interact with the simulator and schedule simulation events.
* Supported by [Siemens](https://blogs.sw.siemens.com/verificationhorizons/2021/09/09/python-and-the-uvm).

![PYUVM](images/others/pyuvm.png)

---
<!-- ###################################################################### -->
# Questions?
<!-- .slide: data-background="#1F618D" -->
<!-- ###################################################################### -->

|   |   |
|---|---|
| ![GitHub icon](images/icons/github.png) | [rodrigomelo9](https://github.com/rodrigomelo9) |
| ![Twitter icon](images/icons/twitter.png) | [rodrigomelo9ok](https://twitter.com/rodrigomelo9ok) |
| ![LinkedIn icon](images/icons/linkedin.png) | [rodrigoalejandromelo](https://www.linkedin.com/in/rodrigoalejandromelo/) |
|   |   |
