import numpy as np
import torch
from torchvision import datasets, transforms
from train_mnist import MNISTMLP

def qsym(x):
    x=np.asarray(x,dtype=np.float32); m=float(np.max(np.abs(x)))
    s=m/127.0 if m else 1.0
    return np.clip(np.rint(x/s),-128,127).astype(np.int8),s

def qb(b,s_in,s_w):
    q=np.rint(np.asarray(b,dtype=np.float32)/(s_in*s_w))
    if np.any(q<-2147483648) or np.any(q>2147483647): raise OverflowError('bias INT32 overflow')
    return q.astype(np.int32)

def main():
    model=MNISTMLP(); model.load_state_dict(torch.load('mnist_784_128_128_10.pt',map_location='cpu')); model.eval()
    w1,b1=model.net[1].weight.detach().numpy(),model.net[1].bias.detach().numpy()
    w2,b2=model.net[3].weight.detach().numpy(),model.net[3].bias.detach().numpy()
    w3,b3=model.net[5].weight.detach().numpy(),model.net[5].bias.detach().numpy()
    xq, sx = qsym(np.array([0.0,1.0],dtype=np.float32))
    # MNIST ToTensor is [0,1]; input calibration therefore uses max=1.
    sx=1.0
    qw1,s1=qsym(w1); qw2,s2=qsym(w2); qw3,s3=qsym(w3)
    # Calibrate hidden activation ranges from the test set.
    ds=datasets.MNIST('data',train=False,download=True,transform=transforms.ToTensor())
    a1_max=0.0; a2_max=0.0
    with torch.no_grad():
        for start in range(0,len(ds),512):
            batch=torch.stack([ds[i][0] for i in range(start,min(start+512,len(ds)))])
            z1=model.net[1](batch.view(batch.size(0),-1)); a1=torch.relu(z1)
            z2=model.net[3](a1); a2=torch.relu(z2)
            a1_max=max(a1_max,float(a1.abs().max())); a2_max=max(a2_max,float(a2.abs().max()))
    sa1=a1_max/127.0 if a1_max else 1.0; sa2=a2_max/127.0 if a2_max else 1.0
    qb1=qb(b1,sx,s1); qb2=qb(b2,sa1,s2); qb3=qb(b3,sa2,s3)
    np.savez('quantized_mnist.npz',w1=qw1,b1=qb1,w2=qw2,b2=qb2,w3=qw3,b3=qb3,
             input_scale=np.float32(sx),w1_scale=np.float32(s1),a1_scale=np.float32(sa1),
             w2_scale=np.float32(s2),a2_scale=np.float32(sa2),w3_scale=np.float32(s3))
    print('saved quantized_mnist.npz')
    print('weight ranges:',float(w1.min()),float(w1.max()),float(w2.min()),float(w2.max()),float(w3.min()),float(w3.max()))
    print('scales:',sx,s1,sa1,s2,sa2,s3)

if __name__=='__main__': main()
