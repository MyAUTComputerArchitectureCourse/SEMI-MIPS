# Instruction

## Instruction Formation

This processor has three types of instructions:

* **R-Type:** This is the register type instructions that has this formation:

|Opcode|Destination Register ID|Source1 Register ID|Source2 Register ID|
|--|--|--|--|
|4 bit|4 bit|4 bit|4 bit|

* **I-Type:** This is the immedaite type instructions that has this formation:

|Opcode|Destination Register ID|Source1 Register ID|Source2 Register ID|
|--|--|--|--|
|4 bit|4 bit|4 bit|4 bit|

* **J-Type:** This is the immedaite type instructions that has this formation:

|Opcode|Destination Register ID|Source1 Register ID|Source2 Register ID|
|--|--|--|--|
|4 bit|4 bit|4 bit|4 bit|

## Instructions List

|Instruction Assembly|Instruction Formation|Instruction Type|
|:---:|:---:|:---:|
|`nop`|0000-00-00|Zeroer|
|`hlt`|0000-00-01|Zeroer|