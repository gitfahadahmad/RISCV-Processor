# RISC-V Processor Collection | Verilog HDL

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![Architecture](https://img.shields.io/badge/ISA-RV32I-success)
![RTL](https://img.shields.io/badge/Design-RTL-orange)
![Status](https://img.shields.io/badge/Projects-3-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A collection of **32-bit RISC-V (RV32I) processor implementations** developed in **Verilog HDL**, demonstrating the evolution of processor architecture from a **Single-Cycle Processor** to a **Multicycle Processor**, and finally to a **5-Stage Pipelined Processor**.

Each processor is implemented using a modular RTL design methodology and verified through simulation using dedicated testbenches and waveform analysis.

---

# Repository Structure

```
RISC-V-Processors
│
├── Single Cycle Processor
│   ├── rtl
│   ├── tb
│   └── docs
│
├── Multicycle Processor
│   ├── rtl
│   ├── tb
│   └── docs
│
├── Pipeline Processor
│   ├── rtl
│   ├── tb
│   └── docs
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# Processor Implementations

| Processor | Description | Status |
|------------|-------------|--------|
| **Single-Cycle Processor** | Executes each instruction in a single clock cycle using dedicated hardware resources. | ✅ Completed |
| **Multicycle Processor** | Executes instructions across multiple clock cycles using an FSM-based control unit and shared hardware resources. | ✅ Completed |
| **5-Stage Pipeline Processor** | Implements instruction pipelining with hazard detection to improve throughput and processor performance. | ✅ Completed |

---

# Single-Cycle Processor

### Features

- 32-bit RV32I Processor
- Modular RTL Design
- Separate Instruction & Data Memories
- Register File
- ALU
- Immediate Generator
- Main Control Unit
- ALU Decoder
- Branch & Jump Logic
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

### Datapath

<p align="center">
<img src="Single%20Cycle%20Processor/docs/datapath.png" width="900">
</p>

### Block Diagram

<p align="center">
<img src="Single%20Cycle%20Processor/docs/block_diagram.png" width="850">
</p>

### Simulation Waveform

<p align="center">
<img src="Single%20Cycle%20Processor/docs/top_waveform.png">
</p>

---

# Multicycle Processor

### Features

- 32-bit RV32I Processor
- Finite State Machine (FSM) Controller
- Shared ALU
- Shared Memory
- Unified Datapath
- Non-Architectural Registers
- Modular RTL Design
- Automatic Verification Testbench

### Execution Stages

- Instruction Fetch
- Decode
- Execute
- Memory Access
- Write Back

### Processor Architecture

The implementation follows the classical multicycle architecture presented in *Digital Design and Computer Architecture – RISC-V Edition* by Sarah Harris and David Harris.

---

# 5-Stage Pipeline Processor

The pipelined processor increases instruction throughput by overlapping instruction execution across multiple stages while resolving hazards through dedicated hardware.

### Pipeline Stages

- Instruction Fetch (IF)
- Instruction Decode (ID)
- Execute (EX)
- Memory Access (MEM)
- Write Back (WB)

### RTL Modules

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

### Block Diagram

<p align="center">
<img src="Pipeline%20Processor/docs/block_diagram_pipeline_processor.png" width="900">
</p>

### Processor Schematic

<p align="center">
<img src="Pipeline%20Processor/docs/Schematic_diagram.png" width="900">
</p>

### Top-Level Simulation

<p align="center">
<img src="Pipeline%20Processor/docs/TOP_WAVEFORM.png">
</p>

---

# Repository Highlights

✔ RTL Design using Verilog HDL

✔ Modular Hardware Architecture

✔ RV32I Instruction Set

✔ Single-Cycle CPU

✔ Multicycle CPU

✔ 5-Stage Pipeline CPU

✔ Hazard Detection Unit

✔ FSM-Based Controller

✔ Processor Verification

✔ Simulation Waveforms

✔ Vivado Simulation

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
- Digital Logic Design
- Processor Datapath Design
- Pipeline Architecture
- Hazard Detection
- FSM Design
- Register File Design
- ALU Design
- Memory Interface
- Verification & Simulation
- FPGA Design Fundamentals

---

# Future Work

Planned enhancements include:

- Data Forwarding Unit
- Branch Prediction
- Instruction Cache
- Data Cache
- RV32M Extension (Multiply/Divide)
- CSR Instructions
- UART Peripheral
- FPGA Implementation and Hardware Validation

---

# Acknowledgements

The processor architectures and datapath concepts are based on:

**Sarah Harris & David Harris**

*Digital Design and Computer Architecture – RISC-V Edition*

The RTL implementation, integration, verification, and documentation were independently developed as part of my Digital IC Design & Verification training.

---

# Author

## Fahad Ahmad

**Electrical Engineer | Digital IC Design | RTL Design | FPGA | Verilog HDL | RISC-V | Embedded Systems**

**LinkedIn**

https://www.linkedin.com/in/fahad-ahmad-electricalengineer

**GitHub**

https://github.com/gitfahadahmad

---

# License

This project is licensed under the MIT License.