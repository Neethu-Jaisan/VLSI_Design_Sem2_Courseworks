# MNIST Letter Recognition using a Neural Network Accelerator on FPGA

## 📌 Overview
This project demonstrates handwritten letter recognition using the **EMNIST Letters** dataset, implemented with a **basic neural network accelerator** on an FPGA.

The focus of the work is **algorithm-to-hardware translation** and **accelerating ML inference** using a custom hardware architecture rather than maximizing model accuracy.

The accelerator is implemented using **Vivado HLS** with **fixed-point arithmetic**, highlighting trade-offs between accuracy, resource utilization, and performance.

---

## 🎯 Objective
- Design a simple neural network inference accelerator for handwritten character recognition  
- Understand how machine learning algorithms are mapped to hardware  
- Explore dataflow-oriented architectures suitable for FPGA implementation  
- Demonstrate the concept of hardware acceleration for ML workloads  

---

## 🧠 Problem Description
Handwritten character recognition involves classifying grayscale images of handwritten letters into one of **26 alphabet classes (A–Z)**.

- **Input image size:** 28 × 28  
- **Number of input features:** 784  
- **Output classes:** 26 (letters A–Z)  

The trained neural network performs **inference on the FPGA** using a custom accelerator architecture.

---

## ⚙️ Accelerator Concept
The accelerator in this project is a **custom neural network inference engine** implemented on FPGA.

It accelerates computation by:
- Using **fixed-point arithmetic** instead of floating-point  
- Implementing **Multiply–Accumulate (MAC)** operations directly in hardware  
- Exploiting **dataflow and pipelining**  
- Eliminating instruction and control overhead found in CPUs  

### Key Accelerator Blocks
- Input buffer for image pixels  
- Weight memory (ROM)  
- MAC unit for dot-product computation  
- Accumulator  
- Activation function (ReLU)  
- Output class selector (Argmax)  

---

## 🏗️ Neural Network Architecture
- **Input Layer:** 784 neurons  
- **Hidden Layer:** 64 / 128 neurons  
- **Output Layer:** 26 neurons  
- **Activation:** ReLU (hidden), Argmax (output)  

Training is performed in software, while **inference is executed on hardware**.

---
EMNIST Dataset
↓
Model Training (Python)
↓
Export Trained Weights
↓
Vivado HLS Accelerator
↓
FPGA-based Inference
↓
Recognized Letter (A–Z)

---

## 🛠️ Implementation Details

### Software
- Model training using Python  
- EMNIST Letters dataset  
- Weights exported in text format  

### Hardware
- Accelerator implemented using Vivado HLS  
- Fixed-point arithmetic (`ap_fixed`)  
- MAC-based computation  
- Testbench to validate inference functionality  

---

## 📊 Evaluation Metrics
- Classification accuracy (software vs hardware)  
- Impact of fixed-point precision  
- Resource utilization (LUTs, DSPs)  
- Latency (clock cycles per inference)  

A slight drop in accuracy is expected and analyzed as part of hardware trade-off evaluation.

---

## 📁 Repository Structure
mnist-fpga-accelerator/
├── training/ # Model training and weight export
├── accelerator_hls/ # HLS-based accelerator implementation
├── hardware/ # Architecture and block diagrams
├── results/ # Accuracy and resource analysis
├── report/ # Coursework report
└── README.md

---

## 🎓 Course Relevance
This project aligns with the course **Emerging Architectures for Machine Learning**, addressing:
- High-performance ML architectures  
- Hardware acceleration of ML inference  
- FPGA suitability for dataflow-intensive workloads  
- Evaluation of accuracy vs hardware efficiency  

---

## 🚀 Conclusion
This project demonstrates how a simple neural network can be accelerated using **custom FPGA hardware**, providing insight into emerging ML architectures and hardware-aware ML design.

The work serves as a foundational step toward more advanced accelerators such as **CNNs** and **sparse neural networks**.
