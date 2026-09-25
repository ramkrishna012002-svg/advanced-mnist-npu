# Advanced MNIST Integer NPU FPGA

Complete project target: **784 -> 128 -> 128 -> 10**.

## Keras + NPU flow

Keras is now included as the training/reference front end. The intended flow is:

MNIST -> Keras FP32 training -> saved checkpoint -> INT8 quantization -> Python integer golden model -> Verilog RTL -> Vivado simulation/synthesis -> FPGA.

Keras model:
- Input: 784 flattened pixels
- Dense1: 128 + ReLU
- Dense2: 128 + ReLU
- Dense3: 10 logits
- Argmax: digit 0-9

Run:
1. `python keras/train_mnist.py`
2. `python keras/evaluate_mnist.py`
3. `python keras/export_weights.py`
4. `python python/quantize_mnist.py`
5. `python python/golden_model.py`

The Keras scripts use MNIST's 60,000 training and 10,000 test images and normalize pixels from 0-255 to 0-1.

## Current hardware/reference architecture

- Quantization: signed INT8 activations/weights, INT32 accumulators/biases
- Compute core: 4x4 true systolic array = 16 PEs
- Layer 1: 100,352 MACs/image
- Layer 2: 16,384 MACs/image
- Layer 3: 1,280 MACs/image
- Total: **118,016 MACs/image**
- Total parameters including biases: **118,282**

The reusable 4x4 systolic core has registered PEs. Activations move left-to-right, weights move top-to-bottom, and each PE performs signed INT8 multiplication with INT32 accumulation.

## Repository

- `keras/`: Keras model, training, evaluation and weight export
- `python/`: quantization and integer golden model
- `rtl/`: Verilog hardware modules
- `sim/` or `tb/`: RTL simulation
- `docs/`: architecture/performance documentation
- `vivado/`: Vivado project Tcl

## Verification rule

Python integer reference, RTL simulation and FPGA output must use identical quantization scales, rounding, saturation, bias representation and ReLU behavior.

Trained weight files are generated artifacts; they should be produced from the actual Keras checkpoint rather than fabricated constants.

## FPGA measurements

After Vivado synthesis/implementation measure cycles/image, latency, throughput, LUT, FF, DSP, BRAM, Fmax, timing slack and power.

Keras documentation:
https://keras.io/guides/sequential_model/
https://keras.io/api/datasets/mnist/

AMD Vivado project Tcl documentation:
https://docs.amd.com/r/2023.2-English/ug895-vivado-system-level-design-entry/Creating-a-Project-Using-a-Tcl-Script
