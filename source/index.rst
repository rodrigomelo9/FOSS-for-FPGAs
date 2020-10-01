Getting started with FOSS for FPGAs
===================================

The content is distributed in the following categories:

* :doc:`introduction`: the FOSS digital hardware design tools are based on general-purpose FOSS tools that you should know.
* :doc:`simulation`: here you will found VHDL and Verilog simulators, as well as waveform viewers. A sofware framework joins proven tools, libraries and metodologies, to reach a particular technical goal easier. HDL testing and verification is a software task, and as such, there are frameworks for that.
* :doc:`implementation`: a Synthesizer takes a hierarchical HDL and creates a structural description (a netlist of basic structures) based on it. It is the first step of an FPGA or ASIC toolchain. here you will found tools specially tailored to work with FPGAs, such as the employed to perform Place and Route, Static Timing Analyzing, bitstream generation and devices programming.
* :doc:`languages`: the commonly used Hardware Description Languages (HDL) are VHDL and Verilog, with System Verilog being incorporated by some tools, but there exists also other alternatives, mainly based on Python and Scala.
* :doc:`wrappers/index`: a wrapper allows to avoid/hide complexities, for example in a program invocation, offering an easiest way to perform the same.
* :doc:`libraries/index`: under this category you will find from single IP cores to libraries of them, sometimes involving package managers.
* :doc:`others`: a linter is a code analyzer which is used to flag programming style errors, avoiding potential errors and verifying guidelines. here you will found Integrated Development Environments or plugins for editors.

.. toctree::
   :maxdepth: 1
   :hidden:

   introduction
   simulation
   implementation
   languages
   wrappers/index
   libraries/index
   others
