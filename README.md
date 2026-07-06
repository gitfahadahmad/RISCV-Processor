# Single-Cycle RISC-V Processor (Verilog)

A complete **32-bit Single-Cycle RISC-V Processor** designed in **Verilog HDL** following the RV32I instruction set architecture. The processor was developed from scratch by implementing each hardware block individually and then integrating them into a complete datapath and control unit.

The design was verified through simulation using a custom testbench and waveform analysis.

---

## Features

- 32-bit RV32I Single-Cycle Processor
- Modular Verilog implementation
- Separate Control Unit and ALU Decoder
- Register File with 32 Registers
- Instruction Memory
- Data Memory
- Immediate Generator
- ALU supporting arithmetic and logical operations
- Program Counter with Branch and Jump support
- Automatic verification testbench
- Waveform verification

---

## Supported Instructions

### Arithmetic

- `ADD`
- `SUB`
- `ADDI`

### Logical

- `AND`
- `OR`

### Comparison

- `SLT`

### Memory

- `LW`
- `SW`

### Control Flow

- `BEQ`
- `JAL`

---

## Processor Datapath

The processor consists of the following modules:

```
                +----------------+
                | Program Counter|
                +-------+--------+
                        |
                        v
             +----------------------+
             | Instruction Memory   |
             +----------+-----------+
                        |
            +-----------+------------+
            |                        |
            v                        v
     Control Unit             Register File
            |                        |
            +-----------+------------+
                        |
                  Immediate Generator
                        |
                        v
                      ALU
                        |
              +---------+---------+
              |                   |
              v                   v
        Data Memory         Result MUX
              |                   |
              +---------+---------+
                        |
                 Write Back
```

---

## Project Structure

```
Single-Cycle-RISCV/
│
├── top.sv
├── Control_Unit.sv
├── main_decoder.sv
├── ALUDecoder.sv
├── ALU.sv
├── register_file.sv
├── instruction_memory.sv
├── data_memory.sv
├── Extend.sv
├── mux2_1.sv
├── mux3_1.sv
├── PC_Counter.sv
├── adder32bit.sv
├── tb_top.sv
├── waveform.png
└── README.md
```

---

## Test Program

The instruction memory contains a demonstration program that verifies every major hardware block.

| Address | Instruction | Description |
|----------|------------|-------------|
| 0x00 | ADDI x1,x0,15 | Load immediate |
| 0x04 | ADDI x2,x0,10 | Load immediate |
| 0x08 | ADD x3,x1,x2 | Arithmetic |
| 0x0C | SUB x4,x1,x2 | Arithmetic |
| 0x10 | AND x5,x1,x2 | Logical |
| 0x14 | OR x6,x1,x2 | Logical |
| 0x18 | SLT x7,x2,x1 | Comparison |
| 0x1C | SW x3,0(x0) | Store |
| 0x20 | LW x8,0(x0) | Load |
| 0x24 | BEQ x3,x8 | Branch |
| 0x2C | JAL x10 | Jump |
| 0x34 | BEQ x0,x0 | End Loop |

---

## Expected Register Values

| Register | Expected Value |
|----------|---------------|
| x1 | 15 |
| x2 | 10 |
| x3 | 25 |
| x4 | 5 |
| x5 | 10 |
| x6 | 15 |
| x7 | 1 |
| x8 | 25 |
| x9 | 0 *(Skipped due to Branch/Jump)* |
| x10 | 48 *(Return Address from JAL)* |

The provided testbench automatically verifies these values and reports whether the processor passes all tests.

---

## Simulation Result

The processor successfully executes the complete instruction sequence, including:

- Arithmetic operations
- Logical operations
- Memory read/write
- Branch decision
- Jump instruction
- Register write-back

### Waveform

> Place your waveform image in the project folder as:

```
waveform.png
```

Then GitHub will display it automatically:

```markdown
![Simulation Waveform](waveform.png)
```

---

## Tools Used

- Verilog HDL
- Xilinx Vivado Simulator
- Vivado Design Suite
- Git
- GitHub

---

## Learning Outcomes

This project demonstrates understanding of:

- Computer Architecture
- RISC-V ISA
- Processor Datapath Design
- Control Unit Design
- ALU Design
- Register File Design
- Memory Interface
- Branch and Jump Logic
- Verilog HDL
- Digital System Design
- FPGA Design Fundamentals

---

## Future Improvements

- Pipeline implementation (5-stage)
- Hazard Detection Unit
- Forwarding Unit
- Instruction Cache
- Data Cache
- CSR Instructions
- Multiplication & Division Extension (RV32M)
- UART Interface
- FPGA Hardware Implementation

---

## Author

**Fahad Ahmad**

Electrical Engineer | FPGA Design | Digital Design | RISC-V | Verilog HDL

- LinkedIn: *(Add your LinkedIn URL here)*
- GitHub: *(Add your GitHub Profile URL here)*

---

## License

This project is released under the MIT License.