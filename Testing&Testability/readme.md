# 🧪 Testing & Testability – ATPG using D-Algorithm  
**C17 Benchmark | Python + Perl Automation**

---

## 📌 Project Overview

This project implements a **prototype Automatic Test Pattern Generation (ATPG) flow**
for **stuck-at faults** using the **D-algorithm**, evaluated on the **ISCAS-85 C17 benchmark circuit**.

The goal of this work is to study **testability and fault detectability** through
formal D-algorithm reasoning (`D / D̅`), rather than performing fault simulation or
manufacturing-level testing.

The entire flow is **script-driven and automated**, reflecting how ATPG engines are
internally structured in real EDA tools.

---

## 🖼️ Conceptual View

![ATPG Flow](https://upload.wikimedia.org/wikipedia/commons/5/5f/Atpg_flow.png)

![D Algorithm Propagation](https://upload.wikimedia.org/wikipedia/commons/3/36/D_algorithm_fault_propagation.png)

![ISCAS C17 Circuit](https://upload.wikimedia.org/wikipedia/commons/9/9b/C17_ISCAS85_circuit.png)

---

## 🎯 Objectives

- Parse a benchmark netlist (`.bench`)
- Generate stuck-at fault models
- Implement **D-algorithm based ATPG**
- Symbolically propagate fault effects using `D / D̅`
- Classify faults as:
  - **Detectable**
  - **Redundant / Untestable**
- Automate the complete flow using **Perl scripting**
- Use **Python** as a reference model for fault generation

---

## 🧠 Why D-Algorithm?

The **D-algorithm** is a classical ATPG technique that:
- Uses **5-valued logic** (`0, 1, X, D, D̅`)
- Explicitly represents fault effects
- Ensures correct fault activation and propagation
- Avoids heuristic or random test generation

This makes it ideal for **formal testability analysis** and educational ATPG engines.

---

## 🏗️ Project Structure
Testing&Testability/
│
├── c17.bench
│ └── ISCAS-85 benchmark circuit (DUT)
│
├── c17_faults.py
│ └── Python reference model for:
│ • net extraction
│ • stuck-at fault generation
│ • equivalence fault collapsing
│
├── d_algorithm_atpg.pl
│ └── Perl-based ATPG engine implementing:
│ • fault activation
│ • gate sensitization
│ • forward implication
│ • detectability classification
│
└── README.md


---

## 🔄 ATPG Flow

1. **Benchmark Parsing**
   - Inputs, outputs, gates, and nets extracted from `c17.bench`

2. **Fault Selection**
   - Single stuck-at fault (SA0 / SA1) chosen

3. **Fault Activation**
   - SA0 → `D`
   - SA1 → `D̅`

4. **Gate Sensitization**
   - Side inputs set to non-controlling values

5. **Forward Implication**
   - `D / D̅` propagated through NAND gates

6. **Output Observation**
   - If `D / D̅` reaches an output → **Test Exists**
   - Else → **Fault Redundant / Untestable**

---

## 🧮 Logic System Used

| Symbol | Interpretation |
|------|---------------|
| `0` | Good = 0, Faulty = 0 |
| `1` | Good = 1, Faulty = 1 |
| `X` | Unknown |
| `D` | Good = 1, Faulty = 0 |
| `D̅` | Good = 0, Faulty = 1 |

---

## 🛠️ Tools & Technologies

- **Python 3**
  - Fault list generation
  - Reference (oracle) model

- **Perl**
  - ATPG engine
  - D-algorithm implementation
  - Automation scripting

- **Ubuntu Linux**
  - Execution environment

- **VS Code**
  - Development environment

---

## ▶️ How to Run

### Python – Fault Model Generation
```bash
python3 c17_faults.py
Generates:

Net list

Uncollapsed fault list

Collapsed fault list

Fault collapsing ratio

Perl – D-Algorithm ATPG
perl d_algorithm_atpg.pl


Produces:

Fault under test

Net value assignments (0 / 1 / X / D / D̅)

Detectability result

📊 Sample Output
Fault: net 10 SA0

Net values after ATPG attempt:
Net 10 : D
Net 22 : X
Net 23 : X

Result: FAULT REDUNDANT / UNTESTABLE


✔ Redundant faults are valid ATPG outcomes
✔ Demonstrates correct D-algorithm reasoning

📈 Key Outcomes

Automated ATPG using Perl

Correct D / D̅ based fault activation

Proper identification of redundant faults

Clear separation between:

fault modeling (Python)

test generation (Perl)

Realistic EDA-style scripting workflow

⚠️ Scope & Limitations

Combinational circuits only

NAND-gate support

Single fault at a time

No backtracking or multiple objectives

Prototype / educational ATPG engine

🚀 Future Enhancements

ATPG over all SA0 / SA1 faults

Test vector extraction at primary inputs

Backtracking and objective selection

Support for additional gate types

Fault coverage computation

🧠 Academic Relevance

This project demonstrates:

Testability analysis

Formal ATPG reasoning

D-algorithm implementation

EDA automation using scripting

Relevant to DFT, Verification, and Test Engineering roles.

👩‍💻 Author

Neethu-Jaisan
