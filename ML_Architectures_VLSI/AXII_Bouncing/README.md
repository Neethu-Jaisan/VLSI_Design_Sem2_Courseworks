# AXI-Stream Based Alphabet Bounce Detector (FPGA)

## 📌 Overview
This project implements a simple streaming data-processing accelerator using
AXI4-Stream on FPGA.

The module detects consecutive repeated alphabet characters ("bouncing") in
an incoming data stream and modifies the output accordingly.

## 🎯 Functionality
- Input: Stream of ASCII characters (A–Z)
- If two consecutive characters are identical:
  → Output the next alphabet (Z wraps to A)
- Otherwise:
  → Output the character unchanged
- The first input character is intentionally treated as a bounce to ensure
  deterministic startup behavior.

### Example
Input:
A A B C C Z Z

Output:
B B B C D Z A

## 🧠 Design Approach
- Implemented in Vivado HLS using C++
- AXI4-Stream interfaces inferred using `hls::stream`
- One-sample state memory used for bounce detection
- Fully pipelined design with II = 1

## ⏱️ Performance
- Target clock: 100 MHz
- Initiation Interval (II): 1
- Latency: 2 cycles
- Resource usage:
  - LUTs: ~89
  - FFs: ~22
  - BRAM/DSP: 0

## 🛠️ Files
- `alphabet_bounce.cpp` : HLS source
- `alphabet_bounce.v`   : Generated AXI-Stream RTL
- `regslice_core.v`     : AXI register slice (auto-generated)
- `tb_alphabet_bounce.sv` : RTL testbench (SystemVerilog)

## 🧪 Verification
- Functional verification using C simulation (Vivado HLS)
- RTL verification using SystemVerilog AXI-Stream testbench

## 🔗 Tools Used
- Vivado HLS 2020.1
- Vivado 2020.1
- SystemVerilog

## 📌 Notes
This project focuses on demonstrating streaming dataflow design using AXI,
rather than memory-mapped control or ML accuracy.
