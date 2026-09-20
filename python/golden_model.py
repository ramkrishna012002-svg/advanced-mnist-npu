import numpy as np
INPUT_SIZE=784
NUM_CLASSES=10
def dot_int8_int32(x_int8,w_int8,bias=0):
    x=np.asarray(x_int8,dtype=np.int8); w=np.asarray(w_int8,dtype=np.int8)
    if x.size!=INPUT_SIZE or w.size!=INPUT_SIZE: raise ValueError('Expected 784 input and weight values')
    acc=np.int64(bias)
    for i in range(INPUT_SIZE): acc += int(x[i])*int(w[i])
    if acc<-(2**31) or acc>2**31-1: raise OverflowError('INT32 accumulator overflow')
    return np.int32(acc)
def mnist_linear_logits(x_int8,weights_int8,bias_int32):
    x=np.asarray(x_int8,dtype=np.int8); w=np.asarray(weights_int8,dtype=np.int8); b=np.asarray(bias_int32,dtype=np.int32)
    if x.shape!=(INPUT_SIZE,) or w.shape!=(NUM_CLASSES,INPUT_SIZE) or b.shape!=(NUM_CLASSES,): raise ValueError('Invalid MNIST tensor shapes')
    return np.array([dot_int8_int32(x,w[c],int(b[c])) for c in range(NUM_CLASSES)],dtype=np.int32)
def predict_digit(logits): return int(np.argmax(np.asarray(logits,dtype=np.int32)))
if __name__=='__main__':
    x=np.zeros(INPUT_SIZE,dtype=np.int8); w=np.zeros((NUM_CLASSES,INPUT_SIZE),dtype=np.int8); b=np.arange(NUM_CLASSES,dtype=np.int32); logits=mnist_linear_logits(x,w,b); print('Logits:',logits.tolist()); print('Predicted digit:',predict_digit(logits))
