# ARMv2-CPU
VHDL description of a functionnal ARM v2 compatible CPU

This repository is made of all the sources from the main project of our VLSI course at Sorbonne University.  
It aims at providing a fully functionnal description of an ARM v2 compatible CPU.

The chosen architecture is organized around a monocore 4 stages single pipeline implementation.  
The function of the CPU supports cache misses and freeze cycles in such a case.

Almost all instructions of the ARM v2 set are supported correctly.  
It is to note though that the multiple transfer instructions make the CPU freeze completely.

A few assembly codes for testing are provided as well.

## Building
To build the simulator based on the VHDL sources, run `make all` in a terminal while in the folder `src/TB`.  
It will produce the main exectuable, with which any program written in assembly and compiled to a memory image can be executed.  
To compile such programs, go in the asm folder, and customize the makefile.  
It will generate .elf files that can be used with the main executable.

Note : programs made with compilers such as gcc may use unsupported instructions (namely multiple transfers). As such, it is better to write the assembly code directly.