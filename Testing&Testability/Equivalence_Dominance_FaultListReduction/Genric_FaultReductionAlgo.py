# ==========================================================
# Generic Benchmark Fault Collapsing Engine
# Supports: AND, OR, NAND, NOR, NOT, BUF
# ==========================================================

# -------- Step 1: Read benchmark file --------
with open("test_1.bench", "r") as f:
    lines = f.readlines()

inputs = []
outputs = []
gates = []

for line in lines:
    line = line.strip()

    if line.startswith("INPUT"):
        net = line[line.find("(") + 1 : line.find(")")]
        inputs.append(net)

    elif line.startswith("OUTPUT"):
        net = line[line.find("(") + 1 : line.find(")")]
        outputs.append(net)

    elif "=" in line:
        left, right = line.split("=")
        out_net = left.strip()
        gate_type = right[: right.find("(")].strip().upper()
        in_nets = right[right.find("(") + 1 : right.find(")")].split(",")
        gates.append((out_net, gate_type, in_nets))


# -------- Step 2: Identify all nets --------
nets = set(inputs + outputs)

for out, gate_type, ins in gates:
    nets.add(out)
    for i in ins:
        nets.add(i)

print("Total nets:", len(nets))


# -------- Step 3: Generate uncollapsed faults --------
uncollapsed_faults = []

for net in nets:
    uncollapsed_faults.append(f"{net}-SA0")
    uncollapsed_faults.append(f"{net}-SA1")

print("Total uncollapsed faults:", len(uncollapsed_faults))


# ==========================================================
# -------- Equivalence Rules Dictionary --------
# format: gate : (input_fault_to_remove, output_equivalent)
# ==========================================================

equivalence_rules = {
    "AND":  ("SA1", "SA0"),
    "NAND": ("SA0", "SA1"),
    "OR":   ("SA0", "SA1"),
    "NOR":  ("SA1", "SA0"),
}

# NOT and BUF handled separately


# -------- Step 4: Equivalence Collapsing --------
eq_collapsed = set(uncollapsed_faults)

for out, gate_type, ins in gates:

    if gate_type in equivalence_rules:
        input_fault, output_fault = equivalence_rules[gate_type]

        for i in ins:
            fault_to_remove = f"{i}-{input_fault}"
            if fault_to_remove in eq_collapsed:
                eq_collapsed.remove(fault_to_remove)

    elif gate_type == "NOT":
        # Input SA0 ≡ Output SA1
        if f"{ins[0]}-SA0" in eq_collapsed:
            eq_collapsed.remove(f"{ins[0]}-SA0")

    elif gate_type == "BUF":
        # Input SA0 ≡ Output SA0
        if f"{ins[0]}-SA0" in eq_collapsed:
            eq_collapsed.remove(f"{ins[0]}-SA0")

print("Faults after equivalence:", len(eq_collapsed))
print("Equivalence ratio:", len(eq_collapsed)/len(uncollapsed_faults))


# ==========================================================
# -------- Dominance Rules Dictionary --------
# format: gate : input_fault_to_remove
# ==========================================================

dominance_rules = {
    "AND":  "SA0",
    "NAND": "SA1",
    "OR":   "SA1",
    "NOR":  "SA0",
}

# -------- Step 5: Dominance Collapsing --------
dom_collapsed = set(uncollapsed_faults)


for out, gate_type, ins in gates:

    if gate_type in dominance_rules:
        input_fault = dominance_rules[gate_type]

        for i in ins:
            fault_to_remove = f"{i}-{input_fault}"
            if fault_to_remove in dom_collapsed:
                dom_collapsed.remove(fault_to_remove)

print("Faults after dominance:", len(dom_collapsed))
print("Dominance ratio:", len(dom_collapsed)/len(eq_collapsed))

print("Overall collapsing ratio:", len(dom_collapsed)/len(uncollapsed_faults))


# -------- Final Fault List --------
print("\nFinal Collapsed Fault List:")
for f in sorted(dom_collapsed):
    print(f)
