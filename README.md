
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

# SEMI-MIPS

MIPS is a reduced instruction set computer (RISC) instruction set architecture developed by MIPS Technologies (formerly MIPS Computer Systems). The early MIPS architectures were 32-bit, with 64-bit versions added later.

But this project is not implementing the mips itself but implementing a limeted version with limited instructions MIPS called SEMI-MIPS.

## Purpose

Designing and implementing two pars :

* ### Controller
* ### Datapath

**Functionality of the processor:** This CPU exploits a 16-bit data-bus and a 8-bit
address-bus. All of instructions hvae 16 bit width. Read more about instructions [here](/docs/Instruction.md)

## Documentation

You can see full documentation [here](/docs).

## How to run

This project is managed by GBMS&copy;. So if you want this building management system you should have GtkWave and GHDL installed on your OSX or any linux distributed operting system.

Simulation can be started simply by running the following command:

`./run.sh`

You can also simulate and synthesis the project with any other HDL simulators like ModelSIM. Just copy and import the files in the `/src` directory.