# 4x4 INT8 True Systolic MNIST NPU Architecture

## Numerical format
- Activation/input: signed INT8, -128..127
- Weight: signed INT8, -128..127
- Product: signed 16-bit
- Accumulator/logit path: signed INT32

A dot product is `acc = bias + sum(input[i] * weight[i])`.

## Array mapping
The 4x4 array represents four parallel input streams and four output-class columns for one class group. Activations move left to right and weights move top to bottom. Each PE registers both streams and performs `acc_next = acc + signed(A_in) * signed(W_in)`.

## MNIST dimensions
A flattened MNIST image contains 784 pixels. A 10-class linear output layer has 7,840 INT8 weights and 10 INT32 biases. Classes can be scheduled as groups 0..3, 4..7, and 8..9.

## Scheduling note
A production systolic implementation normally uses temporal skewing so intended activation/weight pairs meet at the correct PE in the correct cycle. This repository is a modular starter and does not yet provide an optimized end-to-end 784-feature scheduler.

## Bias and argmax
After accumulation, signed INT32 bias is added. Classification uses argmax over the ten logits; softmax is not required for the predicted class.

## Verification status
The RTL, Python arithmetic model, simulation scaffold, and Vivado script are intentionally separated. The current testbench is not a trained-MNIST accuracy test. End-to-end verification remains development work.
