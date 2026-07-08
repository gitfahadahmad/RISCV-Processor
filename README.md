# RISC-V Processor Design in Verilog HDL

![Verilog](https://img.shields.io/badge/Language-Verilog-blue)
![ISA](https://img.shields.io/badge/ISA-RV32I-success)
![Architecture](https://img.shields.io/badge/Processor-RISC--V-orange)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

A collection of **32-bit RISC-V processor implementations** designed and verified in **Verilog HDL**.

This repository documents my journey through processor design, beginning with a **Single-Cycle RV32I Processor** and progressing to a **Multicycle RV32I Processor**. Each implementation follows a modular RTL design methodology, supported by dedicated verification testbenches, simulation waveforms, and comprehensive documentation.

---

# Repository Contents

```
RISC-V-Processor
│
├── Single-Cycle Processor/
│
│   ├── rtl/
│   ├── tb/
│   ├── docs/
│
├── Multicycle Processor/
│
│   ├── rtl/
│   ├── tb/
│   ├── docs/
│
├── README.md
├── LICENSE
└── .gitignore
```

---

# Implemented Processors

| Processor | Status | Description |
|-----------|--------|-------------|
| Single-Cycle RV32I | ✅ Complete | Executes every instruction in one clock cycle. |
| Multicycle RV32I | ✅ Complete | Executes instructions over multiple cycles using an FSM-based control unit and shared hardware resources. |

---

# Single-Cycle Processor

The Single-Cycle processor implements the classical RV32I datapath where each instruction completes within one clock cycle.

## Features

- 32-bit RV32I Processor
- Separate Instruction & Data Memories
- Register File
- ALU
- Immediate Generator
- Main Decoder
- ALU Decoder
- Program Counter
- Branch Logic
- Jump Logic
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
<img src="Single-Cycle Processor/docs/datapath.png" width="900">
</p>

### Block Diagram

<p align="center">
<img src="Single-Cycle Processor/docs/block_diagram.png" width="850">
</p>

### Top-Level Simulation

<p align="center">
<img src="Single-Cycle Processor/docs/top_waveform.png">
</p>

---

# Multicycle Processor

The Multicycle processor extends the single-cycle architecture by introducing an FSM-based control unit, unified memory, and hardware resource sharing to reduce hardware cost.

## Features

- 32-bit RV32I Processor
- Unified Instruction/Data Memory
- FSM-based Main Decoder
- Moore State Machine
- Non-Architectural Pipeline Registers
- Shared ALU
- Shared Memory
- Automatic Verification Testbench

### Execution Stages

- Instruction Fetch
- Decode
- Execute
- Memory Access
- Write Back

### Processor Architecture

The processor implements the classical multicycle datapath described in *Digital Design and Computer Architecture – RISC-V Edition* by Sarah Harris & David Harris.

---

# Verification

Both processors were verified using dedicated module-level and top-level simulation environments.

## Single-Cycle Verification

- ✅ ALU
- ✅ Register File
- ✅ Program Counter
- ✅ Instruction Memory
- ✅ Data Memory
- ✅ Immediate Generator
- ✅ Multiplexers
- ✅ Complete Processor

## Multicycle Verification

- ✅ Unified Memory
- ✅ Datapath
- ✅ Control Unit
- ✅ Main FSM
- ✅ Register File
- ✅ ALU
- ✅ Immediate Generator
- ✅ Top-Level Integration

---

# Repository Highlights

- Modular RTL Design
- Verilog HDL
- RV32I ISA
- Single-Cycle Processor
- Multicycle Processor
- Processor Datapath Design
- FSM Control Unit
- Register File
- ALU
- Memory Interface
- Simulation & Verification
- Vivado Simulation
- Waveform Analysis

---

# Tools Used

- Verilog HDL
- Xilinx Vivado
- Vivado Simulator
- Git
- GitHub

---

# Future Work

The repository will continue to expand with more advanced processor implementations, including:

- Five-Stage Pipelined Processor
- Hazard Detection Unit
- Forwarding Unit
- Branch Prediction
- RV32M Extension
- Instruction Cache
- Data Cache
- UART Peripheral
- FPGA Deployment

---

# Acknowledgements

The processor architectures and datapath concepts are based on:

**Sarah Harris & David Harris**

*Digital Design and Computer Architecture – RISC-V Edition*

The RTL implementation, module integration, simulation, verification, and documentation were developed independently as part of my Digital IC Design & Verification training.

---

# Author

## Fahad Ahmad

Electrical Engineer | Digital IC Design | RTL Design | FPGA | Verilog HDL | RISC-V | Embedded Systems

**LinkedIn**

https://www.linkedin.com/in/fahad-ahmad-electricalengineer

**GitHub**

https://github.com/gitfahadahmad

---

# License

This project is licensed under the MIT License.