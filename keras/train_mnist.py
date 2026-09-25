import os
import keras
from model import build_model

os.makedirs('artifacts', exist_ok=True)
(x_train,y_train),(x_test,y_test)=keras.datasets.mnist.load_data()
x_train=x_train.reshape(-1,784).astype('float32')/255.0
x_test=x_test.reshape(-1,784).astype('float32')/255.0
model=build_model()
model.compile(optimizer=keras.optimizers.Adam(),loss=keras.losses.SparseCategoricalCrossentropy(from_logits=True),metrics=['accuracy'])
model.summary()
model.fit(x_train,y_train,epochs=10,batch_size=128,validation_split=0.1)
_,acc=model.evaluate(x_test,y_test,verbose=1)
print('FP32 test accuracy:',float(acc))
model.save('artifacts/mnist.keras')
