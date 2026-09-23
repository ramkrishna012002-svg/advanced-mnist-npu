import argparse
import numpy as np

def write_hex(path, values, bits):
    a=np.asarray(values).reshape(-1)
    mask=(1<<bits)-1
    width=bits//4
    with open(path,'w',encoding='utf-8') as f:
        for v in a: f.write(f'{int(v)&mask:0{width}x}\n')

def main():
    p=argparse.ArgumentParser(); p.add_argument('--input',required=True); p.add_argument('--out',default='mem'); a=p.parse_args()
    d=np.load(a.input)
    for n,b in [('w1',8),('b1',32),('w2',8),('b2',32),('w3',8),('b3',32)]: write_hex(f'{a.out}_{n}.mem',d[n],b)
    print('Exported INT8 weights and INT32 biases.')

if __name__=='__main__': main()
