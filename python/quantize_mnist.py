import numpy as np
def quantize_symmetric(values,scale=None):
    values=np.asarray(values,dtype=np.float32); max_abs=float(np.max(np.abs(values))); scale=(max_abs/127.0 if max_abs else 1.0) if scale is None else float(scale); q=np.clip(np.round(values/scale),-128,127).astype(np.int8); return q,scale
def dequantize(q,scale): return np.asarray(q,dtype=np.int8).astype(np.float32)*float(scale)
def quantize_bias(bias,input_scale,weight_scale):
    bias=np.asarray(bias,dtype=np.float32); scale=float(input_scale)*float(weight_scale)
    if scale==0: raise ValueError('Quantization scale cannot be zero')
    q=np.round(bias/scale)
    if np.any(q<-(2**31)) or np.any(q>2**31-1): raise OverflowError('Bias does not fit INT32')
    return q.astype(np.int32)
if __name__=='__main__':
    q,s=quantize_symmetric(np.array([-1.,-.25,0.,.5,1.])); print('scale =',s); print('quantized =',q.tolist()); print('dequantized =',dequantize(q,s).tolist())
