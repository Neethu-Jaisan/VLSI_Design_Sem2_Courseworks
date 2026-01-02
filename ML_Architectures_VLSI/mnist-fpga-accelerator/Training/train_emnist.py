# ============================================================
# EMNIST Letters Training Script
# Neural Network for FPGA Inference Accelerator
# ============================================================

import torch
import torch.nn as nn
import torch.optim as optim
from torchvision import datasets, transforms
import numpy as np

# ------------------------------------------------------------
# Dataset Preparation
# ------------------------------------------------------------
transform = transforms.Compose([
    transforms.ToTensor(),
    transforms.Normalize((0.5,), (0.5,))
])

train_dataset = datasets.EMNIST(
    root='./data',
    split='letters',
    train=True,
    download=True,
    transform=transform
)

test_dataset = datasets.EMNIST(
    root='./data',
    split='letters',
    train=False,
    download=True,
    transform=transform
)

train_loader = torch.utils.data.DataLoader(
    train_dataset, batch_size=64, shuffle=True
)

test_loader = torch.utils.data.DataLoader(
    test_dataset, batch_size=64, shuffle=False
)

# ------------------------------------------------------------
# Neural Network Definition
# ------------------------------------------------------------
class SimpleNN(nn.Module):
    def __init__(self):
        super(SimpleNN, self).__init__()
        self.fc1 = nn.Linear(784, 128)
        self.relu = nn.ReLU()
        self.fc2 = nn.Linear(128, 26)

    def forward(self, x):
        x = x.view(-1, 784)
        x = self.fc1(x)
        x = self.relu(x)
        x = self.fc2(x)
        return x

model = SimpleNN()

# ------------------------------------------------------------
# Training Setup
# ------------------------------------------------------------
criterion = nn.CrossEntropyLoss()
optimizer = optim.Adam(model.parameters(), lr=0.001)

# ------------------------------------------------------------
# Training Loop
# ------------------------------------------------------------
epochs = 5

for epoch in range(epochs):
    model.train()
    running_loss = 0.0

    for images, labels in train_loader:
        # EMNIST Letters labels range from 1–26, convert to 0–25
        labels = labels - 1

        optimizer.zero_grad()
        outputs = model(images)
        loss = criterion(outputs, labels)
        loss.backward()
        optimizer.step()

        running_loss += loss.item()

    print(f"Epoch [{epoch+1}/{epochs}], Loss: {running_loss:.4f}")

# ------------------------------------------------------------
# Model Evaluation
# ------------------------------------------------------------
model.eval()
correct = 0
total = 0

with torch.no_grad():
    for images, labels in test_loader:
        labels = labels - 1
        outputs = model(images)
        _, predicted = torch.max(outputs, 1)

        total += labels.size(0)
        correct += (predicted == labels).sum().item()

accuracy = 100 * correct / total
print(f"Test Accuracy: {accuracy:.2f}%")

# ------------------------------------------------------------
# Export Weights for FPGA / Vivado HLS
# ------------------------------------------------------------
np.savetxt("fc1_weights.txt", model.fc1.weight.detach().numpy())
np.savetxt("fc1_bias.txt",    model.fc1.bias.detach().numpy())

np.savetxt("fc2_weights.txt", model.fc2.weight.detach().numpy())
np.savetxt("fc2_bias.txt",    model.fc2.bias.detach().numpy())

print("Weights exported successfully for FPGA inference.")
