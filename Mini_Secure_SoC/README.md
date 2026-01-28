# Mini System-on-Chip (SoC) – RTL Integration Project

## Overview
This project focuses on designing and verifying a **mini System-on-Chip (SoC)** by integrating multiple RTL blocks using **Verilog/SystemVerilog**.  
The primary goal is to understand **RTL integration, control logic, memory-mapped interfaces, and system-level functional verification**.

The project is developed as an **independent RTL integration exercise** alongside academic coursework.

---

## Project Duration
**Dec 2025 – Jan 2026 (Ongoing)**

---

## Key Features
- Integration of multiple RTL blocks to form a mini SoC  
- Register-based control and configuration  
- Memory-mapped address decoding for peripheral access  
- System-level functional verification using simulation  
- Debugging through waveform analysis  

---

## SoC Architecture (High-Level)
The mini SoC consists of:
- Top-level SoC module  
- Control logic / FSM  
- Address decoder for memory-mapped access  
- Register block(s) for configuration and status  
- Peripheral module(s) (e.g., counter / simple ALU / GPIO-style logic)  

Each peripheral is accessed through a **fixed address range**, enabling inter-block communication using read/write control signals.

---

## Functional Verification
- A system-level testbench is used to verify:
  - Reset sequencing  
  - Read and write transactions  
  - Data flow between integrated blocks  
  - Correct control signal behavior  
- Functional issues are debugged using **waveform analysis**.

---

## Tools & Technologies
- **Languages:** Verilog / SystemVerilog  
- **Simulation:**  
  - Synopsys **VCS** (used during FVHDL coursework for functional verification experiments)  
  - GTKWave / DVE for waveform viewing  
- **Environment:** Linux (Ubuntu)

> **Note:** Simulation concepts and debugging methodologies learned using VCS were applied during the functional verification of this project.

---

## Project Status
- RTL integration completed for core blocks  
- Functional simulation in progress  
- Additional peripherals and refinements planned  

---

## Learning Outcomes
- Hands-on experience with RTL integration  
- Understanding of memory-mapped interfaces  
- Improved debugging skills using waveforms  
- Exposure to industry-standard simulation workflows  

---

## Disclaimer
This project is intended for **learning and academic demonstration purposes** and does not target physical tapeout or full SoC implementation.
