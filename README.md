# RISC-V Processor Collection | Verilog HDL

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![ISA](https://img.shields.io/badge/ISA-RV32I-success)
![RTL](https://img.shields.io/badge/Design-RTL-orange)
![Projects](https://img.shields.io/badge/Processors-3-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A collection of **32-bit RISC-V (RV32I) processor implementations** developed in **Verilog HDL**, demonstrating the evolution of processor architecture from a **Single-Cycle Processor** to a **Multicycle Processor**, and finally to a **5-Stage Pipelined Processor**.

Each processor is implemented using a modular RTL design methodology and verified through simulation using dedicated testbenches and waveform analysis.

---

# Repository Structure

```
RISCV-Processor
│
├── Single Cycle Processor RISCV
│   ├── rtl
│   ├── tb
│   └── docs
│
├── Multi Cycle Processor RISCV
│   ├── rtl
│   ├── tb
│   └── docs
│
├── Pipeline Processor RISCV
│   ├── rtl
│   ├── tb
│   └── docs
│
├── README.md
├── LICENSE
└── .gitattributes
```

---

# Processor Implementations

| Processor | Description | Status |
|------------|-------------|--------|
| **Single-Cycle Processor** | Executes every instruction in one clock cycle. | ✅ Completed |
| **Multicycle Processor** | Executes instructions over multiple clock cycles using an FSM-based controller. | ✅ Completed |
| **5-Stage Pipeline Processor** | Executes instructions using a classic 5-stage pipeline with hazard detection. | ✅ Completed |

---

# Single Cycle Processor

## Features

- RV32I Architecture
- 32-bit Datapath
- Modular RTL Design
- Separate Instruction & Data Memories
- Register File
- ALU
- Immediate Generator
- Branch & Jump Support
- Self-checking Testbench

### Supported Instructions

- ADD
- SUB
- ADDI
- AND
- OR
- SLT
- LW
- SW
- BEQ
- JAL

## Datapath

![Datapath](./Single%20Cycle%20Processor%20RISCV/docs/datapath.png)

---

## Block Diagram

![Block Diagram](./Single%20Cycle%20Processor%20RISCV/docs/block_diagram.png)

---

## Top-Level Simulation

![Top Waveform](./Single%20Cycle%20Processor%20RISCV/docs/top_waveform.png)

---

# Multi Cycle Processor

## Features

- RV32I Architecture
- Finite State Machine Controller
- Shared ALU
- Shared Memory
- Unified Datapath
- Multi-Cycle Execution
- Reduced Hardware Utilization
- Modular RTL Design

### Execution Stages

- Instruction Fetch
- Decode
- Execute
- Memory Access
- Write Back

---

# Pipeline Processor

The pipelined processor improves throughput by overlapping instruction execution across five stages while resolving hazards using dedicated hardware.

## Pipeline Stages

- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

## RTL Modules

- Fetch
- Decode
- Execute
- Memory
- WriteBack
- Hazard Unit
- Control Unit
- Register File
- ALU
- Instruction Memory
- Data Memory
- Immediate Generator
- Pipeline Registers
- Multiplexers
- Top Module

---

## Block Diagram

![Pipeline Block Diagram](./Pipeline%20Processor%20RISCV/docs/block_diagram_pipeline_processor.png)

---

## Processor Schematic

![Pipeline Schematic](./Pipeline%20Processor%20RISCV/docs/Schematic_diagram.png)

---

## Top-Level Simulation

![Pipeline Waveform](./Pipeline%20Processor%20RISCV/docs/TOP_WAVEFORM.png)

---

# Repository Highlights

- ✔ Modular RTL Design
- ✔ Verilog HDL
- ✔ RV32I Instruction Set
- ✔ Single-Cycle Architecture
- ✔ Multicycle Architecture
- ✔ 5-Stage Pipeline Architecture
- ✔ Hazard Detection Unit
- ✔ Datapath Design
- ✔ FSM-Based Controller
- ✔ Simulation & Verification
- ✔ Vivado Simulation

---

# Tools Used

- Verilog HDL
- Xilinx Vivado
- Vivado Simulator
- Git
- GitHub

---

# Skills Demonstrated

- Computer Architecture
- RTL Design
- FPGA Design
- Digital Logic Design
- Processor Datapath Design
- Pipeline Architecture
- Hazard Detection
- Register File Design
- ALU Design
- Control Unit Design
- Memory Interface Design
- Verification & Simulation

---

# Future Work

Planned enhancements include:

- Data Forwarding Unit
- Branch Prediction
- Instruction Cache
- Data Cache
- RV32M Extension
- UART Peripheral
- FPGA Hardware Implementation
- Performance Benchmarking

---

# Acknowledgements

The processor architectures and datapath concepts are based on:

**Sarah Harris & David Harris**

*Digital Design and Computer Architecture – RISC-V Edition*

The RTL implementation, module integration, verification environment, and documentation were independently developed as part of my Digital IC Design & Verification training.

---

# Author

## Fahad Ahmad

**Electrical Engineer | Digital IC Design | RTL Design | FPGA | Verilog HDL | RISC-V | Embedded Systems**

### LinkedIn

https://www.linkedin.com/in/fahad-ahmad-electricalengineer

### GitHub

https://github.com/gitfahadahmad

---

# License

This project is licensed under the MIT License.
