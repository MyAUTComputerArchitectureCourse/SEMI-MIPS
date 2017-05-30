
[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](http://www.gnu.org/licenses/gpl-3.0)

# SAYEH

## 1 Purpose

Design and implementation of a small modular processor, called SAYEH (Simple Architecture, Yet
Enough Hardware) which contains the following major components:

* ### Controller
* ### Datapath

**Functionality of the processor:** This CPU exploits a 16-bit data-bus and also a 16-bit
address-bus. Instructions used in this processor has 8 or 16-bit width. Short instructions (8-bit
ones) contain shadow instructions, which effectively pack 2 such instructions (8-bit) into a single
16-bit word. Figure 1 shows SAYEH’s interface (it’s the overview of the whole module):

## Documentation
You can see full documentation [here](/docs).