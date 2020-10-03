Getting started with FOSS for FPGAs
===================================

The content is distributed in the following categories:

* :doc:`introduction`: the FOSS for FPGAs is based on general-purpose FOSS tools that you should know.
* :doc:`simulation`: previous to be transferred to an FPGA, you need to ensure that your HDL works as expected. Here you will find simulators and waveform viewers, as well as frameworks and methodologies for testing and verification.
* :doc:`implementation`: this section describes the tools involved from the HDL synthesis to the bitstream generation and programming.
* :doc:`libraries`: because is not always needed to reinvent the wheel, you will find here libraries of IP cores, sometimes involving a package manager.
* :doc:`managers`: with the aim of hiding tools complexities and heterogeneity, and to provide a common interface to deal with the project sources, there are a few tools/project managers.
* :doc:`languages`: the commonly used Hardware Description Languages (HDL) are VHDL and Verilog, with System Verilog being incorporated by some tools, but there exists also other alternatives, mainly based on Python and Scala.
* :doc:`others`: the rest of tools, not included in the previous categories.

.. toctree::
   :maxdepth: 1
   :hidden:

   introduction
   simulation
   implementation
   libraries
   managers
   languages
   others
