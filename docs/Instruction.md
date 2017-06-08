# Instruction

## Instruction Formation

This processor has three types of instructions:

* **R-Type:** This is the register type instructions that has this formation:

|Opcode|Destination Register ID|Source1 Register ID|Source2 Register ID|
|--|--|--|--|
|4 bit|4 bit|4 bit|4 bit|

* **I-Type:** This is the immedaite type instructions that has this formation:

|Opcode|Destination Register ID|Source Register ID|Immedaite Value|
|--|--|--|--|
|4 bit|4 bit|4 bit|8 bit|

* **J-Type:** This is the immedaite type instructions that has this formation:

|Opcode|Zero Const|Memory Address (Immediate)|
|--|--|--|
|4 bit|0000|8 bit|

## Instructions List

|Instruction Assembly|Instruction Formation|Instruction Type|
|:---:|:---:|:---:|
|`add`|0000-DR-SR1-SR2|R-Type|
|`addi`|1000-DR-SR-Immediate|I-Type|
|`sub`|0001-DR-SR1-SR2|R-Type|
|`and`|0010-DR-SR1-SR2|J-Type|
|`andi`|1010-DR-SR-Immediate|I-Type|
|`or`|0011-DR-SR1-SR2|J-Type|
|`ori`|1011-DR-SR-Immediate|I-Type|
|`xor`|0100-DR-SR1-SR2|R-Type|
|`not`|0101-DR-SR1-SR2|R-Type|
|`mul`|0110-DR-SR1-SR2|R-Type|
|`jmp`|0111-0000-MemoryAddress(Immediate)|J-Type|
|`brnz`|1111-0000-MemoryAddress(Immediate)|J-Type|
|`store`|1101-SR-MemoryAddress(Immediate)|I-Type|
|`load`|1110-DR-MemoryAddress(Immediate)|I-Type|
|`srl`|1001-DR-SR-Immediate|I-Type|