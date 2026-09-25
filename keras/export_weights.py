import os
import numpy as np
import keras
model=keras.models.load_model('artifacts/mnist.keras')
os.makedirs('artifacts/weights',exist_ok=True)
for layer in model.layers:
    if not hasattr(layer,'kernel'): continue
    w,b=layer.get_weights()
    np.save(f'artifacts/weights/{layer.name}_W.npy',w)
    np.save(f'artifacts/weights/{layer.name}_b.npy',b)
    print(layer.name,w.shape,w.min(),w.max())
