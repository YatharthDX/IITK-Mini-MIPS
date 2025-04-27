# IITK Mini MIPS Processor

This project implements a **Mini MIPS Processor** using **Verilog** on **Xilinx Vivado**.  
The processor supports a variety of **R-type**, **I-type**, and a few **floating-point** operations, modeled after the MIPS instruction set.

---

## Features

- **Instruction Memory** and **Data Memory** using Vivado's `dist_mem_gen` IP.
- **Register File** with:
  - 32 General-purpose integer registers
  - 32 Floating-point registers
- **Arithmetic and Logic Unit (ALU)**:
  - Basic operations: `ADD`, `SUB`, `ADDU`, `SUBU`, `AND`, `OR`, `XOR`, `NOT`
  - Shift operations: `SLL`, `SRL`, `SRA`
  - Multiplication operations: `MUL`, `MADD`, `MADDU`
  - Immediate operations: `ADDI`, `ADDIU`, `ANDI`, `ORI`, `XORI`
- **Memory Access**:
  - `LW` (Load Word)
  - `SW` (Store Word)
- **Branch Instructions**:
  - `BEQ` (Branch if Equal)
  - `BNE` (Branch if Not Equal)
  - `BGT` (Branch if Greater Than)
- **Special Instructions**:
  - `LUI` (Load Upper Immediate)
- **Basic Floating Point Operations**:
  - Floating point addition (`add.s`)
  - Floating point subtraction (`sub.s`)

---

## Project Structure

- `main.v`:  
  Main module that integrates the instruction memory, data memory, register file, ALU, floating point operations, and basic control logic.

- `myALU.v`:  
  ALU implementation that supports integer operations.

- `FLU.v`:  
  Module to handle simple floating-point addition and subtraction.

---

## Implementation Details

- **Platform**: Xilinx Vivado
- **Language**: Verilog
- **Clock and Reset**:
  - `clk`: System clock input
  - `reset`: Reset signal
- **Instruction Decode**:
  - Supports parsing `opcode`, `rs`, `rt`, `rd`, `shamt`, `funct`, `immediate`, and `target` fields.
- **Program Counter**:
  - Maintains the flow of execution and supports basic branching.
- **Memory Access**:
  - Load (`LW`) and Store (`SW`) instructions are handled with memory-mapped IPs.
- **Write-Back**:
  - The results of ALU and memory operations are written back to the register file.

---

## How to Run

1. Open **Vivado**.
2. Create a new project and add all Verilog files (`main.v`, `myALU.v`, `floating_adder.v`, etc.).
3. For instruction and data memories, create Vivado IPs (`dist_mem_gen`) and initialize them using `.coe` files.
4. Instantiate the `main` module for simulation.
5. Use Vivado’s built-in simulation tools (XSim) to test and verify the design.

---

## Memory Note

- The **instruction memory** and **data memory** are not provided as Verilog files.
- They should be created using Vivado's `dist_mem_gen` IP cores.
- You can initialize them with your own `.coe` files for loading instruction and data values.
- (Example: In this project, `dist_mem_gen_1` was used for data memory, and `dist_mem_gen_2` for instruction memory.)

---
