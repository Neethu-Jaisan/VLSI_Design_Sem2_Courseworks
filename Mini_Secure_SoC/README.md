# Mini Secure SoC – RTL + HLS Integration Project

## 📌 Project Overview

This project implements a **Mini System-on-Chip (SoC)** integrating **handwritten RTL modules** with a **Vivado HLS–generated accelerator**, verified using **SystemVerilog layered testbench methodology** and industry-standard EDA tools.

The goal is to demonstrate **end-to-end SoC design flow** — from architecture definition and RTL integration to simulation, synthesis, and basic hardware security features — in a manner aligned with **industry RTL design practices**.

---

## 🎯 Objectives

* Design a modular mini SoC using SystemVerilog RTL
* Integrate an HLS-generated accelerator into RTL fabric
* Implement register-based control and inter-block communication
* Verify functionality using layered SystemVerilog testbench
* Perform synthesis and basic timing analysis
* Introduce lightweight hardware security mechanisms

---

## 🧠 SoC Architecture (High-Level)

**Main Components:**

* SoC Top Module
* Simple AXI-Lite–style Interconnect
* Control & Status Register Block
* HLS Accelerator (DSP / Compute block)
* GPIO / Timer Peripheral
* On-chip Memory (BRAM model)
* Security Monitor Block

**Control Model:**

* Testbench acts as AXI-Lite master
* Register-mapped communication between blocks
* Interrupt-style signaling from accelerator

---

## 🔧 Technology & Tools

### Design & Verification

* SystemVerilog (RTL + Testbench)
* Vivado HLS (C/C++ → RTL)
* Synopsys VCS (Simulation)

### Synthesis & Analysis

* Synopsys Design Compiler (Synthesis)
* Basic Static Timing Analysis (STA awareness)
* Conceptual Physical Design (PD awareness)

---

## 🔐 Hardware Security Features

* Register access locking via key-based unlock
* Address-range protection for accelerator access
* Security alert flag for illegal access attempts

---

## 🧪 Verification Strategy

* Layered SystemVerilog testbench (UVM-lite style)
* AXI-Lite interface driver & monitor
* Scoreboard for data correctness
* Reset, register access, data flow, and security checks

---

## 📂 Repository Structure

```
Mini_Secure_SoC/
├── rtl/
│   ├── soc_top.sv
│   ├── interconnect.sv
│   ├── ctrl_regs.sv
│   ├── gpio.sv
│   ├── memory.sv
│   └── security_monitor.sv
├── hls/
│   └── accelerator.cpp
├── tb/
│   ├── axi_lite_if.sv
│   ├── driver.sv
│   ├── monitor.sv
│   ├── scoreboard.sv
│   └── test.sv
├── syn/
│   └── dc_scripts/
├── reports/
└── README.md
```

---

## 📅 Project Phases

1. **Architecture Definition & Register Map**
2. RTL Backbone Implementation
3. HLS Accelerator Development
4. RTL + HLS Integration
5. System-Level Verification (VCS)
6. Synthesis & Timing Analysis
7. Security Feature Integration & Documentation

---

## 📄 Resume Mapping

This project supports resume claims related to:

* RTL integration and SoC design
* HLS-based hardware acceleration
* SystemVerilog verification
* Industry EDA tool exposure
* Hardware security fundamentals

---

## 🧩 Future Extensions

* RISC-V core integration
* Advanced power intent (UPF)
* Clock-domain crossing (CDC) analysis
* Enhanced security policies

---

> **Note:** This project prioritizes architectural clarity, verification quality, and professional workflow over excessive feature complexity.
## Owner Neethu Jaisan
