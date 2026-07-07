# Single-Cycle RISC-V Processor (RV32I) | Verilog HDL

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![Architecture](https://img.shields.io/badge/Architecture-RV32I-success)
![Processor](https://img.shields.io/badge/Processor-Single%20Cycle-orange)
![Status](https://img.shields.io/badge/Status-Completed-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A complete **32-bit Single-Cycle RISC-V Processor** designed from scratch in **Verilog HDL** implementing a subset of the **RV32I Instruction Set Architecture**.

The project follows the classical **single-cycle datapath architecture** where every instruction completes within one clock cycle. Every hardware module—including the ALU, Register File, Control Unit, Memories, Immediate Generator, and Program Counter—was designed independently before integration into the complete processor.

The processor has been verified using dedicated testbenches, simulation waveforms, and an automated top-level verification environment.

---

# Features

- 32-bit RV32I Processor
- Single-Cycle Architecture
- Modular RTL Design
- Register File
- ALU
- Immediate Generator
- Main Decoder
- ALU Decoder
- Program Counter
- Instruction Memory
- Data Memory
- Branch Logic
- Jump Logic
- Self-checking Testbench

---

# Supported Instructions

## Arithmetic

- ADD
- SUB
- ADDI

## Logical

- AND
- OR

## Comparison

- SLT

## Memory

- LW
- SW

## Control Flow

- BEQ
- JAL

---

# Processor Datapath

The processor datapath used for this implementation.

> Reference: *Digital Design and Computer Architecture – RISC-V Edition* by Sarah Harris & David Harris.

<p align="center">
<img src="docs/datapath.png" width="950">
</p>

---

# Processor Block Diagram

Overall architecture of the processor.

> Reference: *Digital Design and Computer Architecture – RISC-V Edition* by Sarah Harris & David Harris.

<p align="center">
<img src="docs/block_diagram.png" width="850">
</p>

---

# Repository Structure

```
Single-Cycle-RISCV
│
├── rtl/
│
├── tb/
│
├── docs/
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# RTL Modules

| Module | Description |
|---------|-------------|
| TOP | Top-level processor integration |
| Control_Unit | Main Decoder + ALU Decoder |
| ALU | Arithmetic Logic Unit |
| Register_File | 32 × 32 Register File |
| Instruction_Memory | Stores instruction program |
| Data_Memory | Load/Store memory |
| Extend | Immediate Generator |
| mux | Multiplexers |
| PC_Counter | Program Counter |
| Adder | 32-bit Adders |

---

# Testbenches

Every hardware module was verified independently before full system integration.

| Testbench |
|------------|
| tb_top |
| ALU_tb |
| data_memory_tb |
| Extend_tb |
| instruction_memory_tb |
| mux2_1_tb |
| mux3_1_tb |
| regfile_tb |
| tb_pc |

---

# Test Program

The processor executes the following verification program.

| Address | Instruction | Function |
|----------|-------------|----------|
| 0x00 | ADDI | x1 = 15 |
| 0x04 | ADDI | x2 = 10 |
| 0x08 | ADD | x3 = 25 |
| 0x0C | SUB | x4 = 5 |
| 0x10 | AND | x5 = 10 |
| 0x14 | OR | x6 = 15 |
| 0x18 | SLT | x7 = 1 |
| 0x1C | SW | Memory Write |
| 0x20 | LW | Memory Read |
| 0x24 | BEQ | Branch |
| 0x2C | JAL | Jump |
| 0x34 | BEQ | End Loop |

---

# Expected Register Values

| Register | Expected |
|-----------|----------|
| x1 | 15 |
| x2 | 10 |
| x3 | 25 |
| x4 | 5 |
| x5 | 10 |
| x6 | 15 |
| x7 | 1 |
| x8 | 25 |
| x9 | 0 |
| x10 | 48 |

The top-level testbench automatically verifies these values and reports **PASS** or **FAIL**.

---

# Simulation Results

## Complete Processor

<p align="center">
<img src="docs/top_waveform.png">
</p>

The waveform verifies:

- Program Counter Update
- Instruction Fetch
- Register Write-back
- ALU Operations
- Branch Decision
- Jump Execution
- Memory Read/Write

---

## Individual Module Verification

### ALU

![](docs/alu_waveform.png)

---

### Register File

![](docs/regfile_waveform.png)

---

### Program Counter

![](docs/pccounter_waveform.png)

---

### Instruction Memory

![](docs/instructionmemory_waveform.png)

---

### Data Memory

![](docs/datamemory_waveform.png)

---

### Immediate Generator

![](docs/extend_waveform.png)

---

### Multiplexer

![](docs/mux3x1_waveform.png)

---

# Tools Used

- Verilog HDL
- Xilinx Vivado
- Vivado Simulator
- Git
- GitHub

---

# Concepts Demonstrated

- Computer Architecture
- RTL Design
- Verilog HDL
- Digital Logic Design
- Processor Datapath
- Control Unit Design
- Instruction Decoding
- Register File Design
- ALU Design
- Memory Interface
- Branch Prediction Logic
- FPGA Design Fundamentals

---

# Future Improvements

- Five-Stage Pipeline
- Hazard Detection Unit
- Data Forwarding Unit
- RV32M Extension
- CSR Instructions
- Instruction Cache
- Data Cache
- UART Interface
- FPGA Implementation

---

# Author

## Fahad Ahmad

Electrical Engineer | FPGA Design | Digital Design | Verilog HDL | RISC-V | Embedded Systems

**LinkedIn**

https://www.linkedin.com/in/fahad-ahmad-electricalengineer

**GitHub**

https://github.com/gitfahadahmad

---

# Acknowledgements

The processor architecture and datapath are based on concepts presented in:

**Sarah Harris & David Harris**

*Digital Design and Computer Architecture – RISC-V Edition*

The RTL implementation, integration, verification, and testing were developed independently as part of this project.

---

# License

This project is licensed under the MIT License.