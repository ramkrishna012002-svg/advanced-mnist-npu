# MNIST Integer NPU Architecture

Network: 784 -> 128 -> 128 -> 10.

Data path:

INT8 activation x INT8 weight -> INT16 product -> INT32 accumulator -> INT32 bias -> requantization -> INT8 -> ReLU.

INT8 is signed (-128..127). Biases are stored in the accumulator domain.

## 4x4 systolic core

The core contains 16 PEs. Activations move left-to-right, weights move top-to-bottom, and each PE performs:

acc_next = acc + signed(A) * signed(W)

The same core is reused for all three GEMM layers. A complete optimized scheduler must skew streams so matching activation/weight pairs meet at the intended PE.

## Workload

- L1: 784*128 = 100,352 MACs/image
- L2: 128*128 = 16,384 MACs/image
- L3: 128*10 = 1,280 MACs/image
- Total: 118,016 MACs/image
- Parameters including biases: 118,282

## Storage

- INT8 weights: 118,016 bytes
- INT32 biases: 266*4 = 1,064 bytes
- weights + biases: 119,080 bytes

## Verification

Python integer reference == Verilog RTL == FPGA result.

Compare product, accumulator, bias result, requantized activation, ReLU output, logits and final argmax.
