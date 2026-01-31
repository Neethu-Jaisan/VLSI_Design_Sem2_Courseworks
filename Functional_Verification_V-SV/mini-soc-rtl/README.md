# Mini SoC Design and System-Level Verification (SystemVerilog)

## Project Intention & Motivation

Modern digital systems are rarely built as isolated hardware blocks. Instead, they are designed as **Systems-on-Chip (SoCs)**, where multiple functional blocks—control logic, peripherals, and interfaces—communicate through a common interconnect.  
The goal of this project was to **understand and implement the core principles of an SoC** at a fundamental level, focusing on **integration, communication, and verification**, rather than complexity or protocol overhead.

This project intentionally keeps the architecture simple to emphasize **correct design methodology**, **register-based communication**, and **system-level functional verification** using simulation.

---

## What This Project Is

This project implements a **mini SoC** using **Verilog/SystemVerilog**, integrating multiple RTL blocks that communicate through a **simple memory-mapped register interface**.  
The design demonstrates how control registers, peripherals, and internal logic interact within a single SoC framework and how such a system is verified using waveform-based simulation.

---

## Core Architecture Overview

The mini SoC consists of the following key components:

### 1. Control Logic
- A memory-mapped **control register** that is written by software/testbench
- Control bits drive the behavior of other blocks (e.g., enabling the counter)
- Demonstrates **register-based control**

### 2. Address Decoding Logic
- Decodes incoming addresses
- Generates select signals for individual blocks
- Enables **memory-mapped access** to internal registers and peripherals

### 3. Peripheral Modules
- **Counter Peripheral**
  - Increments when enabled by the control register
- **GPIO Peripheral (4-bit)**
  - Memory-mapped output register
  - Demonstrates basic I/O-style peripheral behavior

### 4. Status Logic
- Aggregates internal state (control and GPIO status)
- Readable through a status register

### 5. Clock and Reset
- Single system clock
- Active-low reset (`rst_n`)
- Reset sequencing verified during simulation

---

## Communication Mechanism

The SoC uses a **simple memory-mapped register-based communication interface**, consisting of:

- `addr`  – Address bus
- `wdata` – Write data bus
- `rdata` – Read data bus
- `wr_en` – Write enable
- `rd_en` – Read enable

### Read/Write Behavior
- **Write transactions** update internal registers or peripherals using `wdata`
- **Read transactions** return data on `rdata` when `rd_en` is asserted
- `rdata` is only valid during active read cycles

This approach represents the **most fundamental form of SoC communication**, commonly used as the basis for more advanced protocols such as APB or AXI.

---

## Inter-Block Communication

Inter-block communication in this SoC is achieved through **register-level interactions**, including:

- Control register enabling the counter peripheral
- GPIO output reflected in the status register
- Address decoding routing transactions to the correct block

This demonstrates **true SoC behavior**, where blocks are not isolated but coordinated through shared control and data paths.

---

## Verification Strategy

The project includes **system-level functional verification** using **ModelSim simulation**.

### Verification Focus Areas
- Reset sequencing and initialization
- Correct address decoding
- Write → internal state update → readback correctness
- Inter-block interaction (control → counter, GPIO → status)
- Peripheral read/write behavior

### Testbench Features
- SystemVerilog interface with clocking block
- Driver and monitor components
- Directed test sequences
- Waveform-based debugging

Verification was performed by analyzing waveforms to validate control logic behavior and data flow across the system.

---
## Results
![GPIO write and read waveform showing rdata validity](images/wave_form.png)

## Tools Used
- **Language:** Verilog / SystemVerilog
- **Simulation Tool:** ModelSim (Questa-FPGA Starter Edition)

---

## Project Scope Clarification

This project intentionally does **not** include:
- AXI/APB protocols
- UVM-based verification
- Coverage closure
- FPGA implementation

The focus is on **fundamental SoC concepts**, correctness, and clarity.

---

## Key Learning Outcomes

- Understanding the structure and components of an SoC
- Implementing memory-mapped communication
- Designing register-based control logic
- Integrating and verifying peripheral modules
- Performing system-level functional verification using simulation
- Debugging hardware behavior through waveform analysis

---

## Conclusion

This mini SoC project demonstrates how multiple RTL blocks can be integrated into a cohesive system using simple, well-defined communication mechanisms. By focusing on clarity and correctness, the project provides a solid foundation for understanding larger and more complex SoC architectures and verification methodologies.

---

