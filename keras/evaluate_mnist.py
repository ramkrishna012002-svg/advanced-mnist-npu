import keras
import numpy as np
model=keras.models.load_model('artifacts/mnist.keras')
(_, _),(x_test,y_test)=keras.datasets.mnist.load_data()
x=x_test.reshape(-1,784).astype('float32')/255.0
logits=model.predict(x,batch_size=256,verbose=0)
pred=np.argmax(logits,axis=1)
print('FP32 accuracy:',float(np.mean(pred==y_test)))
print('first 20 predictions:',pred[:20].tolist())
