<!-- .slide: data-background="#145A32" -->

# cocotb tutorial

#### (cocotb 1.6, python 3.6+)

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

### A Brief History of cocotb

* 2012: started by Chris Higgs and Stuart Hodgson (Potential Ventures).
* 2013: Open sourced (BSD, Jun). cocotb 0.1 (Jul), 0.2 (Jul) and 0.3 (Sep).
* 2014: cocotb 0.4 (Feb).
* 2015: cocotb 1.0 (Feb).
* 2018: FOSSi Foundation.
* 2019: cocotb 1.1 (Jan), 1.2 (Jul).
* 2020: cocotb 1.3 (Jan), 1.4 (Jul).
* 2021: cocotb 1.5 (Mar), 1.6 (Oct).
* cocotb 1.7/2.0 under development.

----

### How does it work?

![cocotb overview](images/diagrams/cocotb_overview.png)

**Source:** [docs.cocotb.org/en/stable](https://docs.cocotb.org/en/stable)

----

### Installation (Debian based systems)

```bash
apt install make gcc g++ python3 python3-dev python3-pip
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
## Elements of a simulation
<!-- ###################################################################### -->

* One (top-level) or more HDL files (the DUT)
* A Python script with one or more individual tests
* A `Makefile`

----

### Example DUT

```
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

### Example Python

```
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
```
<!-- .element: style="font-size: 0.40em !important;" -->

----

### Example Makefile

```
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

### Example Run

```
make
```

![cocotb run](images/screens/cocotb.png)

----

### Example waveforms

```
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

```
import cocotb
from cocotb.<MODULE> import <CLASS>

@cocotb.test()
async def test1(dut):

@cocotb.test()
async def test2(dut):

async def coro1(dut):

async def coro2(dut):

def func():
```

<!--**More at:**-->
<!--* https://docs.cocotb.org/en/stable/library_reference.html-->
<!--* https://docs.cocotb.org/en/stable/coroutines.html-->

----

### Accessing the design

```
@cocotb.test()
async def my_test1(dut):
    # Assign a signal
    dut.data_i.value = 1
    # Get a reference and assign a signal
    data_i = dut.data_i
    data_i.value = 1
    # Assign a value to a memory deep in the hierarchy
    dut.memory_inst.memory.array[4].value = 2
    # Read a signal
    count = dut.count_o.value
```

A common mistake is forgetting the **.value**.

<!-- the Python type depends on the handle's HDL type -->

----

### Signed and unsigned values

```
module my_module (
    input   logic       clk,
    input   logic       rst,
    input   logic [2:0] data_in,
    output  logic [2:0] data_out
    );
```

```
dut.data_in.value = -4
dut.data_in.value = 7
dut.data_in.value = 8   # raises OverflowError
dut.data_in.value = -5  # raises OverflowError
```

`-2^(Nbits-1) <= value <= 2^Nbits-1`

----

### Concurrent and sequential execution

----

### Forcing and freezing signals

```
# Deposit action
dut.my_signal.value = 12
dut.my_signal.value = Deposit(12)  # equivalent syntax
# Force action
dut.my_signal.value = Force(12)    # stays 12 until released
# Freeze action
dut.my_signal.value = Freeze()     # stays at current value
# Release action
dut.my_signal.value = Release()    # Reverts any force/freeze
```

----

### Passing and Failing Tests

----

### Logging

----

### Triggers

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

[**Full list**](https://docs.cocotb.org/en/stable/building.html)

---
<!-- ###################################################################### -->
# Miscellaneous
<!-- ###################################################################### -->

----

### Extensions

* [cocotb-bus](https://github.com/cocotb/cocotb-bus): reusable bus interfaces (AMBA, Avalon, others).
* [cocotbext-axi](https://github.com/alexforencich/cocotbext-axi): AXI, AXI lite, and AXI stream simulation models.
* [cocotbext-wishbone](https://github.com/wallento/cocotbext-wishbone): driver and monitor modules for the Wishbone bus.

----

### PyUVM

* [PyUVM](https://github.com/pyuvm/pyuvm) is UVM (IEEE 1800.2) implemented in Python instead of SystemVerilog.
* It uses cocotb to interact with the simulator and schedule simulation events.

Supported by [Siemens](https://blogs.sw.siemens.com/verificationhorizons/2021/09/09/python-and-the-uvm/)

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
