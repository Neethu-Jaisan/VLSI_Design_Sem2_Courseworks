# Vivado HLS – Clocked Adder Example

This project demonstrates a simple clocked adder implemented using Vivado HLS.
The goal is to understand how latency constraints and control interfaces affect
hardware generation, rather than to optimize arithmetic performance.

## Overview
- Tool: Vivado HLS 2020.1
- Target FPGA: Artix-7 (xc7a35t)
- Language: C++
- Clock Period: 10 ns

## Design Details
- 8-bit signed inputs (`a`, `b`)
- 9-bit signed output (`sum`)
- One-cycle latency enforced using HLS latency constraints
- Handshake-based control interface (`ap_ctrl_hs`)
- Registers inferred in control path (FSM)

## Key Learning Outcomes
- Difference between combinational and sequential hardware in HLS
- Why registers may be optimized away unless latency is enforced
- How HLS separates control path (FSM) and datapath
- Interpreting HLS reports and generated RTL

## Files
- `src/adder_clk.cpp` – HLS C++ source
- `rtl/adder_clk.v` – Generated Verilog RTL
- `tb/` – Simple testbench (optional)

## Notes
This design intentionally keeps the datapath combinational while enforcing
latency through the control FSM, reflecting Vivado HLS optimization behavior.

## Author
Neethumol  
M.Tech VLSI Design
