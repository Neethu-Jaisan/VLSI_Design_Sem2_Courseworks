# ============================================================
# MERO Interactive Trojan Analysis Tool
# Generic BENCH Parser + User-Controlled Theta and N
# ============================================================

import math
import numpy as np
import os

# ------------------------------------------------------------
# STEP 1: Ask for BENCH file
# ------------------------------------------------------------

bench_file = input("Enter BENCH file name (e.g., c17.bench): ").strip()

if not os.path.exists(bench_file):
    print("File not found. Please check the file name.")
    exit()

# ------------------------------------------------------------
# STEP 2: Parse BENCH File
# ------------------------------------------------------------

inputs = []#lists to store input and output node names
outputs = [] #lists to store input and output node names
gates = {} #dictionary to store gate info: {out_node: (gate_type, [in_nodes])}

with open(bench_file, "r") as file:  #open the specified BENCH file for reading
    for line in file: #read the file line by line

        line = line.strip() #remove leading and trailing whitespace from the line

        if not line or line.startswith("#"): #skip empty lines and comments (lines starting with #)
            continue 

        if line.startswith("INPUT"): #if the line starts with "INPUT", it indicates an input node definition. The node name is extracted and added to the inputs list.
            inputs.append(line[6:-1]) #The line is sliced to remove the "INPUT(" prefix and the closing ")" at the end, leaving just the node name.

        elif line.startswith("OUTPUT"): #if the line starts with "OUTPUT", it indicates an output node definition. The node name is extracted and added to the outputs list.
            outputs.append(line[7:-1]) #The line is sliced to remove the "OUTPUT(" prefix and the closing ")" at the end, leaving just the node name.

        elif "=" in line: #if the line contains an "=", it indicates a gate definition. The line is split into the left and right parts at the "=". The left part gives the output node name, while the right part contains the gate type and its input nodes.
            left, right = line.split("=") #The line is split into two parts at the "=" character. The left part (before the "=") is stored in the variable left, and the right part (after the "=") is stored in the variable right.

            out_node = left.strip() #The left part is stripped of leading and trailing whitespace to get the output node name, which is stored in the variable out_node.
            gate_type, args = right.strip().split("(") #The right part is stripped of leading and trailing whitespace and then split at the first "(" character. The part before the "(" gives the gate type, which is stored in the variable gate_type, and the part after the "(" contains the input nodes, which is stored in the variable args.

            gate_type = gate_type.strip().lower() #The gate type is stripped of leading and trailing whitespace and converted to lowercase for consistency.
            in_nodes = args.replace(")", "").split(",") #The input nodes are extracted by removing the closing ")" from args and then splitting the remaining string at commas. This gives a list of input node names, which is stored in the variable in_nodes.
            in_nodes = [x.strip() for x in in_nodes] #Each input node name in the in_nodes list is stripped of leading and trailing whitespace to ensure clean node names.

            gates[out_node] = (gate_type, in_nodes) #circuit graph

print("\nCircuit Loaded Successfully") #print a success message after loading the circuit
print("Inputs :", inputs) #print the list of input nodes
print("Outputs:", outputs) #print the list of output nodes
print("Total Gates:", len(gates)) #print the total number of gates in the circuit

# ------------------------------------------------------------
# STEP 3: Initialize Input Probabilities
# ------------------------------------------------------------

prob = {} #dictionary to store probabilities for each node: {node: {"P1": p1, "P0": p0}}

for node in inputs: #initialize probabilities for input nodes to 0.5 for both P(1) and P(0), indicating equal likelihood of being 1 or 0.
    prob[node] = {"P1": 0.5, "P0": 0.5} #This means that for each input node, the probability of it being 1 (P1) is set to 0.5, and the probability of it being 0 (P0) is also set to 0.5. This is a common assumption when no specific information about the input probabilities is available, indicating that the inputs are equally likely to be 0 or 1.

# ------------------------------------------------------------
# STEP 4: Gate Probability Evaluation
# ------------------------------------------------------------

def evaluate_gate(gate, in_nodes): #function to evaluate the output probabilities of a gate based on its type and the probabilities of its input nodes

    p_inputs = [prob[n]["P1"] for n in in_nodes] #For each input node in in_nodes, the function retrieves the probability of that node being 1 (P1) from the prob dictionary and creates a list of these probabilities called p_inputs.

    if gate == "nand": #For a NAND gate, the output is 0 only if all inputs are 1. Therefore, the probability of the output being 1 (P1) is calculated as 1 minus the probability that all inputs are 1. The probability that all inputs are 1 is found by multiplying the probabilities of each input being 1 together (p_and). Thus, p1 is calculated as 1 - p_and.
        p_and = 1 #Initialize p_and to 1, which will be used to calculate the probability that all inputs are 1 by multiplying the probabilities of each input being 1 together.
        for p in p_inputs: #Iterate through each probability p in the p_inputs list, which contains the probabilities of each input being 1. For each p, multiply it with p_and to update p_and to reflect the combined probability that all inputs are 1.
            p_and *= p #After the loop, p_and will contain the probability that all inputs are 1. The probability of the NAND gate output being 1 (P1) is then calculated as 1 - p_and, since the NAND gate outputs 0 only when all inputs are 1.
        p1 = 1 - p_and #The probability of the NAND gate output being 1 (P1) is calculated as 1 minus the probability that all inputs are 1 (p_and). This is because a NAND gate outputs 0 only when all inputs are 1, so the probability of it outputting 1 is the complement of the probability that all inputs are 1.

    elif gate == "and": #For an AND gate, the output is 1 only if all inputs are 1. Therefore, the probability of the output being 1 (P1) is calculated by multiplying the probabilities of each input being 1 together. This is done by initializing p1 to 1 and then iterating through each probability p in the p_inputs list, multiplying p1 by p for each input.
        p1 = 1 #Initialize p1 to 1, which will be used to calculate the probability that all inputs are 1 by multiplying the probabilities of each input being 1 together.
        for p in p_inputs: #Iterate through each probability p in the p_inputs list, which contains the probabilities of each input being 1. For each p, multiply it with p1 to update p1 to reflect the combined probability that all inputs are 1.
            p1 *= p #After the loop, p1 will contain the probability that all inputs are 1, which is also the probability of the AND gate output being 1 (P1).

    elif gate == "or": #For an OR gate, the output is 0 only if all inputs are 0. Therefore, the probability of the output being 1 (P1) is calculated as 1 minus the probability that all inputs are 0. The probability that all inputs are 0 is found by multiplying the probabilities of each input being 0 together (p0). Thus, p1 is calculated as 1 - p0.
        p0 = 1 #Initialize p0 to 1, which will be used to calculate the probability that all inputs are 0 by multiplying the probabilities of each input being 0 together.
        for p in p_inputs: #Iterate through each probability p in the p_inputs list, which contains the probabilities of each input being 1. To calculate the probability of each input being 0, we take (1 - p) for each input, since the probability of an input being 0 is the complement of it being 1. For each p, multiply p0 by (1 - p) to update p0 to reflect the combined probability that all inputs are 0.
            p0 *= (1 - p) #After the loop, p0 will contain the probability that all inputs are 0. The probability of the OR gate output being 1 (P1) is then calculated as 1 - p0, since the OR gate outputs 0 only when all inputs are 0, so the probability of it outputting 1 is the complement of the probability that all inputs are 0.
        p1 = 1 - p0 #The probability of the OR gate output being 1 (P1) is calculated as 1 minus the probability that all inputs are 0 (p0). This is because an OR gate outputs 0 only when all inputs are 0, so the probability of it outputting 1 is the complement of the probability that all inputs are 0.

    elif gate == "not": #For a NOT gate, the output is simply the complement of the input. Therefore, the probability of the output being 1 (P1) is calculated as 1 minus the probability of the input being 1. Since a NOT gate has only one input, we take the first element of p_inputs to get the probability of that input being 1 and calculate p1 as 1 - p_inputs[0].
        p1 = 1 - p_inputs[0] #The probability of the NOT gate output being 1 (P1) is calculated as 1 minus the probability of the input being 1 (p_inputs[0]). This is because a NOT gate outputs 1 when its input is 0, and outputs 0 when its input is 1, so the probability of it outputting 1 is the complement of the probability that its input is 1.

    elif gate == "xor": #For an XOR gate with two inputs, the output is 1 if exactly one of the inputs is 1. Therefore, the probability of the output being 1 (P1) can be calculated using the formula: P1 = a*(1-b) + (1-a)*b, where a and b are the probabilities of the two inputs being 1. This formula accounts for both cases where one input is 1 and the other is 0.
        a, b = p_inputs #Assuming the XOR gate has exactly two inputs, we can unpack the probabilities of the two inputs being 1 into variables a and b from the p_inputs list.
        p1 = a*(1-b) + (1-a)*b #The probability of the XOR gate output being 1 (P1) is calculated using the formula: P1 = a*(1-b) + (1-a)*b. This formula accounts for both cases where one input is 1 and the other is 0. The first term, a*(1-b), represents the case where the first input is 1 (with probability a) and the second input is 0 (with probability 1-b). The second term, (1-a)*b, represents the case where the first input is 0 (with probability 1-a) and the second input is 1 (with probability b). By summing these two terms, we get the total probability that exactly one of the inputs is 1, which is when an XOR gate outputs 1.

    else: #For any unsupported gate types, we can assign a default probability of 0.5 for both P(1) and P(0), indicating that the output is equally likely to be 1 or 0. This is a fallback mechanism to handle any gate types that are not explicitly defined in the function.
        p1 = 0.5 #Assign a default probability of 0.5 for P(1) for unsupported gate types, indicating that the output is equally likely to be 1 or 0.

    return {"P1": p1, "P0": 1 - p1} #The function returns a dictionary containing the calculated probabilities for the gate output being 1 (P1) and being 0 (P0). P0 is calculated as the complement of P1, since the output can only be either 1 or 0, so P0 is simply 1 minus P1.

# Propagate probabilities
for node in gates: #Iterate through each node in the gates dictionary, which contains the internal nodes of the circuit. For each node, we retrieve the gate type and its input nodes from the gates dictionary, and then call the evaluate_gate function to calculate the probabilities for that node based on its gate type and input probabilities. The resulting probabilities are stored in the prob dictionary for that node.
    gate_type, in_nodes = gates[node] #For each node in the gates dictionary, we unpack the gate type and its input nodes into the variables gate_type and in_nodes. The gate_type variable will contain the type of gate (e.g., "and", "or", "not"), and the in_nodes variable will contain a list of input node names for that gate.
    prob[node] = evaluate_gate(gate_type, in_nodes) #We call the evaluate_gate function with the gate type and input nodes to calculate the probabilities for that node. The resulting probabilities are stored in the prob dictionary under the key corresponding to that node. This allows us to propagate the probabilities through the circuit, starting from the input nodes (which were initialized to 0.5) and calculating the probabilities for each internal node based on its gate type and input probabilities.

# ------------------------------------------------------------
# STEP 5: Print All Probabilities
# ------------------------------------------------------------

print("\nAll Node Probabilities") # print a header for the section that will display the probabilities of all nodes in the circuit
print("-" * 60) # print a separator line consisting of 60 dashes for better readability

for node in prob: # Iterate through each node in the prob dictionary, which contains the probabilities for all nodes in the circuit. For each node, we print its name along with the calculated probabilities of it being 1 (P1) and being 0 (P0). The probabilities are formatted to four decimal places for better readability.
    print(f"{node:>6}  P(1) = {prob[node]['P1']:.4f}   "
          f"P(0) = {prob[node]['P0']:.4f}") #The print statement uses an f-string to format the output. The node name is right-aligned in a field of width 6 characters, followed by the probabilities P(1) and P(0) for that node, each formatted to four decimal places. This will produce a neatly aligned list of nodes and their corresponding probabilities.

# ------------------------------------------------------------
# STEP 6: Compute Rare Occurrence Values
# ------------------------------------------------------------

internal_nodes = list(gates.keys()) #We create a list of internal nodes by taking the keys from the gates dictionary, which contains the internal nodes of the circuit. This list will be used to compute the rare occurrence values for each internal node based on their probabilities.
rare_occurrences = [
    min(prob[n]["P1"], prob[n]["P0"]) for n in internal_nodes
] #We compute the rare occurrence values for each internal node by taking the minimum of the probabilities of that node being 1 (P1) and being 0 (P0). This is done using a list comprehension that iterates through each internal node n in the internal_nodes list, retrieves its probabilities from the prob dictionary, and calculates the minimum of P(1) and P(0) for that node. The resulting list rare_occurrences will contain the rare occurrence values for all internal nodes, which can be used to suggest threshold values for detecting rare nodes in the circuit.

# ------------------------------------------------------------
# STEP 7: Suggest Theta
# ------------------------------------------------------------

percentile_25 = round(np.percentile(rare_occurrences, 25), 3) #We calculate the 25th percentile of the rare occurrence values using the np.percentile function from the NumPy library. This function takes the list of rare occurrence values and the desired percentile (25 in this case) as arguments, and returns the value below which 25% of the data falls. We round this value to three decimal places for better readability and store it in the variable percentile_25. This value can be suggested as a threshold (theta) for detecting rare nodes in the circuit, as it represents a point where a significant portion of the nodes have rare occurrence values below it.
median_val = round(np.median(rare_occurrences), 3) #We calculate the median of the rare occurrence values using the np.median function from the NumPy library. This function takes the list of rare occurrence values as an argument and returns the median value, which is the middle value when the data is sorted. We round this value to three decimal places for better readability and store it in the variable median_val. The median can also be suggested as a threshold (theta) for detecting rare nodes in the circuit, as it represents a point where half of the nodes have rare occurrence values below it and half have values above it.

print("\nSuggested Threshold Values") #We print a header for the section that will display the suggested threshold values for detecting rare nodes in the circuit.
print("-" * 60) #We print a separator line consisting of 60 dashes for better readability.
print("25th Percentile =", percentile_25)#We print the calculated 25th percentile value for the rare occurrence values. This value can be used as a suggested threshold (theta) for detecting rare nodes in the circuit. The 25th percentile represents a more conservative threshold, as it indicates that only 25% of the nodes have rare occurrence values below this threshold. Users can choose to use this value if they want to focus on detecting only the most rare nodes in the circuit.
print("Median          =", median_val)#We print the calculated 25th percentile and median values for the rare occurrence values. These values can be used as suggested thresholds (theta) for detecting rare nodes in the circuit. The 25th percentile represents a more conservative threshold, while the median represents a more balanced threshold. Users can choose either of these values or input their own threshold based on their specific requirements for rare node detection.

# Ask for theta
while True: #We enter a loop to ask the user for a threshold value (theta) for detecting rare nodes in the circuit. The loop will continue until the user provides a valid input or chooses to use the suggested 25th percentile value by pressing Enter.
    theta_input = input(
        "\nEnter theta (press Enter to use 25th percentile): "
    )#We prompt the user to enter a threshold value (theta) for detecting rare nodes. The prompt also informs the user that they can press Enter without typing anything to use the suggested 25th percentile value as the threshold.

    if theta_input.strip() == "": #If the user presses Enter without typing anything (i.e., the input is an empty string after stripping whitespace), we set theta to the previously calculated 25th percentile value. This allows users to easily use the suggested threshold without having to type it in manually.
        theta = percentile_25
        break

    try:
        theta = float(theta_input) #If the user provides an input, we attempt to convert it to a floating-point number. If the conversion is successful, we set theta to this value and break out of the loop. This allows users to specify their own threshold value for detecting rare nodes if they do not want to use the suggested 25th percentile.
        break
    except ValueError: #If the user input cannot be converted to a float (e.g., if they enter a non-numeric value), a ValueError will be raised. In this case, we catch the exception and print an error message informing the user that the input is invalid and that they should enter a numeric value. The loop will then continue, allowing the user to try entering a valid threshold value again.
        print("Invalid input. Enter a numeric value.")

print("Using Theta =", theta) #After successfully obtaining a valid threshold value (theta) from the user, we print the value that will be used for detecting rare nodes in the circuit. This confirms to the user which threshold value has been set for the subsequent analysis of rare nodes.

# ------------------------------------------------------------
# STEP 8: Ask for N
# ------------------------------------------------------------

while True: #We enter a loop to ask the user for the required activation count (N) for the MERO calculations. The loop will continue until the user provides a valid integer input for N.
    N_input = input("\nEnter required activation count N: ")

    try: #We attempt to convert the user input for N into an integer. If the conversion is successful, we set N to this integer value and break out of the loop. This allows users to specify the required activation count for the MERO calculations, which will be used in determining the individual and simultaneous activation requirements for the detected rare nodes.
        N = int(N_input)
        break
    except ValueError: #If the user input cannot be converted to an integer (e.g., if they enter a non-numeric value or a decimal), a ValueError will be raised. In this case, we catch the exception and print an error message informing the user that the input is invalid and that they should enter an integer value. The loop will then continue, allowing the user to try entering a valid integer for N again.
        print("Invalid input. Enter an integer value.")

print("Using N =", N) #After successfully obtaining a valid integer input for N from the user, we print the value that will be used as the required activation count for the MERO calculations. This confirms to the user which value of N has been set for the subsequent analysis of rare nodes and the calculation of individual and simultaneous activation requirements.

# ------------------------------------------------------------
# STEP 9: Detect Rare Nodes
# ------------------------------------------------------------

rare_nodes = {} #We initialize an empty dictionary called rare_nodes to store the nodes that are detected as rare based on the specified threshold (theta). The keys of this dictionary will be the names of the rare nodes, and the values will be their corresponding rare probabilities (the minimum of P(1) and P(0) for those nodes). This dictionary will be populated in the following loop where we check each internal node against the threshold to determine if it is considered rare.

print("\nRare Nodes Detected") #We print a header for the section that will display the nodes that are detected as rare based on the specified threshold (theta). This section will list the rare nodes along with their rare values and probabilities, providing insight into which nodes in the circuit are considered rare according to the defined criteria.
print("-" * 60) #We print a separator line consisting of 60 dashes for better readability, separating the header from the list of detected rare nodes that will be printed in the following loop.

for node in internal_nodes: #We iterate through each internal node in the internal_nodes list, which contains the names of all internal nodes in the circuit. For each node, we retrieve its probabilities of being 1 (P1) and being 0 (P0) from the prob dictionary. We then check if either P1 or P0 is less than or equal to the specified threshold (theta). If either probability is below the threshold, it indicates that the node is considered rare, and we proceed to calculate its rare probability and rare value.

    p1 = prob[node]["P1"] #We retrieve the probability of the current node being 1 (P1) from the prob dictionary. This value will be used to determine if the node is considered rare based on the specified threshold (theta). If P1 is less than or equal to theta, it indicates that the node has a low probability of being 1, which contributes to it being classified as a rare node.
    p0 = prob[node]["P0"] #We retrieve the probability of the current node being 0 (P0) from the prob dictionary. This value will also be used to determine if the node is considered rare based on the specified threshold (theta). If P0 is less than or equal to theta, it indicates that the node has a low probability of being 0, which also contributes to it being classified as a rare node.

    if p1 <= theta or p0 <= theta: #We check if either P1 or P0 for the current node is less than or equal to the specified threshold (theta). If this condition is true, it means that the node has a low probability of being either 1 or 0, which classifies it as a rare node. If the node is considered rare based on this condition, we proceed to calculate its rare probability and rare value.

        rare_probability = min(p1, p0) #We calculate the rare probability for the current node by taking the minimum of P1 and P0. This represents the probability of the node being in its less likely state (either 1 or 0), which is what defines it as a rare node. The rare probability will be used later in the MERO calculations to determine the activation requirements for this node.
        rare_value = 1 if p1 < p0 else 0 #We determine the rare value for the current node based on whether P1 is less than P0. If P1 is less than P0, it means that the node is more likely to be 0, so we set the rare value to 1 (indicating that the rare state is when the node is 1). Conversely, if P0 is less than or equal to P1, it means that the node is more likely to be 1, so we set the rare value to 0 (indicating that the rare state is when the node is 0). This rare value will be used in conjunction with the rare probability to understand the conditions under which this node is considered rare.

        rare_nodes[node] = rare_probability #We add the current node to the rare_nodes dictionary, using the node name as the key and its corresponding rare probability as the value. This allows us to keep track of all the nodes that are detected as rare based on the specified threshold (theta), along with their associated probabilities of being in their rare state.

        print(f"{node:>6}  Rare Value = {rare_value}   "
              f"Probability = {rare_probability:.6f}") #We print the current node's name, its rare value, and its rare probability in a formatted manner. The node name is right-aligned in a field of width 6 characters, followed by the rare value (indicating whether the rare state is when the node is 1 or 0) and the rare probability formatted to six decimal places. This output provides a clear and concise summary of each detected rare node, its associated rare value, and the probability of it being in that rare state.

if not rare_nodes: #After iterating through all internal nodes and checking for rare nodes based on the specified threshold (theta), we check if the rare_nodes dictionary is empty. If it is empty, it means that no nodes were detected as rare according to the criteria defined by theta. In this case, we print a message indicating that no rare nodes were detected and exit the program, as there would be no further analysis to perform without any rare nodes.
    print("No rare nodes detected.")
    exit()

# ------------------------------------------------------------
# STEP 10: Trojan Trigger Construction
# ------------------------------------------------------------

trigger_probability = 1 #We initialize a variable called trigger_probability to 1. This variable will be used to calculate the joint probability of all the detected rare nodes being in their rare states simultaneously, which is essential for constructing the Trojan trigger. We will multiply this variable by the rare probabilities of each detected rare node in the following loop to get the overall trigger probability.

for p_i in rare_nodes.values(): #We iterate through the values of the rare_nodes dictionary, which represent the rare probabilities of each detected rare node. For each rare probability p_i, we multiply it with the trigger_probability variable to update the overall trigger probability. This process effectively calculates the joint probability of all the detected rare nodes being in their rare states simultaneously, which is crucial for understanding the likelihood of the Trojan trigger being activated based on these rare conditions.
    trigger_probability *= p_i

print("\nTrojan Trigger Construction")
print("-" * 60) #We print a header for the section that will display the results of the Trojan trigger construction, including the estimated joint trigger probability based on the detected rare nodes. This section will summarize the likelihood of the Trojan trigger being activated given the probabilities of the rare nodes that were identified in the previous steps.
print("Estimated Joint Trigger Probability =", 
      round(trigger_probability, 6))

# ------------------------------------------------------------
# STEP 11: MERO Calculations
# ------------------------------------------------------------

print("\nIndividual Activation Requirement") #We print a header for the section that will display the individual activation requirements for each detected rare node based on the specified required activation count (N) and their respective rare probabilities. This section will calculate and show how many activations (T) are needed for each rare node to achieve the required activation count, as well as the overall requirements for simultaneous activation of all rare nodes.
print("-" * 60)

T_values = [] #We initialize an empty list called T_values to store the calculated activation requirements (T) for each detected rare node. This list will be populated in the following loop where we calculate the individual activation requirement for each rare node based on its rare probability and the specified required activation count (N). We will also use this list to determine the maximum individual activation requirement, which will be important for understanding the overall requirements for simultaneous activation of all rare nodes.

for node, p_i in rare_nodes.items(): #We iterate through the items of the rare_nodes dictionary, which contains the detected rare nodes and their corresponding rare probabilities. For each node and its associated rare probability p_i, we calculate the individual activation requirement (T) needed for that node to achieve the specified required activation count (N). This is done using the formula T >= N / p_i, which indicates that the number of activations (T) must be at least equal to N divided by the rare probability p_i for that node. We then append this calculated T value to the T_values list for later analysis.

    T_node = math.ceil(N / p_i) #We calculate the individual activation requirement (T) for the current node using the formula T >= N / p_i, where N is the required activation count specified by the user and p_i is the rare probability of the current node. We use math.ceil to round up the result to the nearest whole number, since the number of activations must be an integer. This calculated T value represents the minimum number of activations needed for this specific rare node to achieve the required activation count N based on its rare probability.
    T_values.append(T_node) #We append the calculated individual activation requirement (T_node) for the current node to the T_values list. This list will be used later to determine the maximum individual activation requirement among all detected rare nodes, which is important for understanding the overall requirements for simultaneous activation of all rare nodes in the circuit.

    print(f"{node:>6}  p = {p_i:.6f}  -->  T >= {T_node}") #We print the current node's name, its rare probability (p_i), and the calculated individual activation requirement (T_node) in a formatted manner. The node name is right-aligned in a field of width 6 characters, followed by the rare probability formatted to six decimal places, and then the calculated T value indicating the minimum number of activations needed for that node to achieve the required activation count N based on its rare probability. This output provides a clear summary of the individual activation requirements for each detected rare node.

T_individual = max(T_values) #After calculating the individual activation requirements (T) for all detected rare nodes and storing them in the T_values list, we determine the maximum individual activation requirement by using the max function on the T_values list. This maximum value, stored in T_individual, represents the highest number of activations needed among all detected rare nodes to achieve the required activation count N based on their respective rare probabilities. This value is important for understanding the overall requirements for simultaneous activation of all rare nodes, as it indicates the minimum number of activations needed to ensure that even the rarest node is activated enough times to meet the required count.
T_simultaneous = math.ceil(N / trigger_probability) #We calculate the simultaneous activation requirement (T_simultaneous) for all detected rare nodes using the formula T >= N / trigger_probability, where N is the required activation count specified by the user and trigger_probability is the estimated joint probability of all detected rare nodes being in their rare states simultaneously. We use math.ceil to round up the result to the nearest whole number, since the number of activations must be an integer. This calculated T_simultaneous value represents the minimum number of activations needed for all detected rare nodes to be activated simultaneously enough times to achieve the required activation count N based on their joint probability.

print("\nRequired T (Individual Guarantee) >=", T_individual) #We print the required number of activations (T) for the individual guarantee, which is the maximum individual activation requirement among all detected rare nodes. This value indicates the minimum number of activations needed to ensure that even the rarest node is activated enough times to meet the required activation count N based on its rare probability.

print("\nSimultaneous Activation Requirement")
print("-" * 60)
print("T >=", T_simultaneous) #We print the required number of activations (T) for the simultaneous activation requirement, which is calculated based on the joint probability of all detected rare nodes being in their rare states simultaneously. This value indicates the minimum number of activations needed for all detected rare nodes to be activated simultaneously enough times to achieve the required activation count N based on their joint probability.

expected_activations = trigger_probability * T_simultaneous #We calculate the expected number of activations for the Trojan trigger by multiplying the estimated joint trigger probability (trigger_probability) by the simultaneous activation requirement (T_simultaneous). This gives us an estimate of how many times we can expect the Trojan trigger to be activated based on the calculated probabilities of the rare nodes and the required activation count N.

print("Expected Trigger Activations at T =", 
      round(expected_activations, 2)) #We print the expected number of activations for the Trojan trigger at the calculated simultaneous activation requirement (T_simultaneous). This value is rounded to two decimal places for better readability. It provides insight into how many times we can expect the Trojan trigger to be activated based on the joint probability of the detected rare nodes and the required activation count N, giving users an understanding of the likelihood of trigger activation under the specified conditions.

print("\nProgram Completed Successfully.")
