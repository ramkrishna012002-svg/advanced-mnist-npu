import numpy as np

def dense_int8(x,w,b):
    x=np.asarray(x,dtype=np.int8); w=np.asarray(w,dtype=np.int8); b=np.asarray(b,dtype=np.int32)
    if w.shape != (b.size,x.size): raise ValueError('shape mismatch')
    acc=w.astype(np.int64) @ x.astype(np.int64) + b.astype(np.int64)
    if np.any(acc < -2147483648) or np.any(acc > 2147483647): raise OverflowError('INT32 overflow')
    return acc.astype(np.int32)

def requant(acc,acc_scale,out_scale):
    q=np.rint(np.asarray(acc,dtype=np.int64)*float(acc_scale)/float(out_scale))
    return np.clip(q,-128,127).astype(np.int8)

def infer(x,p):
    z1=dense_int8(x,p['w1'],p['b1'])
    a1=np.maximum(requant(z1,p['input_scale']*p['w1_scale'],p['a1_scale']),0).astype(np.int8)
    z2=dense_int8(a1,p['w2'],p['b2'])
    a2=np.maximum(requant(z2,p['a1_scale']*p['w2_scale'],p['a2_scale']),0).astype(np.int8)
    return dense_int8(a2,p['w3'],p['b3'])

def predict(x,p): return int(np.argmax(infer(x,p)))

if __name__=='__main__':
    x=np.zeros(784,dtype=np.int8)
    p={'w1':np.zeros((128,784),np.int8),'b1':np.arange(128,dtype=np.int32),
       'w2':np.zeros((128,128),np.int8),'b2':np.arange(128,dtype=np.int32),
       'w3':np.zeros((10,128),np.int8),'b3':np.arange(10,dtype=np.int32),
       'input_scale':1.0,'w1_scale':1.0,'a1_scale':1.0,'w2_scale':1.0,'a2_scale':1.0,'w3_scale':1.0}
    print('predicted digit:',predict(x,p))
