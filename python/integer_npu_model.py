import numpy as np

def qsym(x, scale=None):
    x = np.asarray(x, dtype=np.float32)
    m = float(np.max(np.abs(x)))
    scale = (m / 127.0 if m else 1.0) if scale is None else float(scale)
    if scale <= 0: raise ValueError('scale must be positive')
    return np.clip(np.rint(x / scale), -128, 127).astype(np.int8), scale

def qbias(bias, in_scale, w_scale):
    s = float(in_scale) * float(w_scale)
    if s <= 0: raise ValueError('invalid bias scale')
    q = np.rint(np.asarray(bias, dtype=np.float32) / s)
    if np.any(q < -2147483648) or np.any(q > 2147483647):
        raise OverflowError('bias does not fit INT32')
    return q.astype(np.int32)

def dense_int8(x, w, b):
    x = np.asarray(x, dtype=np.int8)
    w = np.asarray(w, dtype=np.int8)
    b = np.asarray(b, dtype=np.int32)
    if w.shape != (b.size, x.size): raise ValueError('shape mismatch')
    acc = w.astype(np.int64) @ x.astype(np.int64) + b.astype(np.int64)
    if np.any(acc < -2147483648) or np.any(acc > 2147483647):
        raise OverflowError('INT32 accumulator overflow')
    return acc.astype(np.int32)

def requant(acc, acc_scale, out_scale):
    q = np.rint(np.asarray(acc, dtype=np.int64) * float(acc_scale) / float(out_scale))
    return np.clip(q, -128, 127).astype(np.int8)

def inference(x, p):
    z1 = dense_int8(x, p['w1'], p['b1'])
    a1 = np.maximum(requant(z1, p['input_scale'] * p['w1_scale'], p['a1_scale']), 0).astype(np.int8)
    z2 = dense_int8(a1, p['w2'], p['b2'])
    a2 = np.maximum(requant(z2, p['a1_scale'] * p['w2_scale'], p['a2_scale']), 0).astype(np.int8)
    return dense_int8(a2, p['w3'], p['b3'])

def predict(x, p):
    return int(np.argmax(inference(x, p)))

def accuracy(x_set, labels, p):
    labels = np.asarray(labels)
    return 100.0 * sum(predict(x, p) == int(y) for x, y in zip(x_set, labels)) / len(labels)
