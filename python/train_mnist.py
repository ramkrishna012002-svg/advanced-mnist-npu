import numpy as np
import torch
import torch.nn as nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms

class MNISTMLP(nn.Module):
    def __init__(self):
        super().__init__()
        self.net = nn.Sequential(
            nn.Flatten(), nn.Linear(784,128), nn.ReLU(),
            nn.Linear(128,128), nn.ReLU(), nn.Linear(128,10))
    def forward(self, x): return self.net(x)

def main():
    torch.manual_seed(0); np.random.seed(0)
    tfm = transforms.ToTensor()
    train = datasets.MNIST('data', train=True, download=True, transform=tfm)
    test = datasets.MNIST('data', train=False, download=True, transform=tfm)
    tr = DataLoader(train, batch_size=128, shuffle=True)
    te = DataLoader(test, batch_size=256, shuffle=False)
    model = MNISTMLP(); opt = torch.optim.Adam(model.parameters(), lr=1e-3)
    loss_fn = nn.CrossEntropyLoss()
    for epoch in range(3):
        model.train()
        for x,y in tr:
            opt.zero_grad(); loss = loss_fn(model(x), y); loss.backward(); opt.step()
        model.eval(); correct=total=0
        with torch.no_grad():
            for x,y in te:
                pred=model(x).argmax(1); correct += int((pred==y).sum()); total += y.numel()
        print(f'epoch {epoch+1}: {100*correct/total:.2f}%')
    torch.save(model.state_dict(), 'mnist_784_128_128_10.pt')

if __name__ == '__main__': main()
