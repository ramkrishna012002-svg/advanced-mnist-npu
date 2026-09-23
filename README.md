# Advanced MNIST Integer NPU FPGA

Complete project target: **784 -> 128 -> 128 -> 10**.

## Current measured results

- PyTorch FP32 reference accuracy: **96.48%**
- Full 3-layer Integer NPU model accuracy: **93.70%**
- Difference: **2.78 percentage points**
- Quantization: signed INT8 activations/weights, INT32 accumulators/biases
- Compute core: 4x4 true systolic array = 16 PEs
- Profile set: 1,000 samples

Reported software/profile latency:

- Input preparation: 98.216 ms
- Layer 1 GEMM: 18.428 ms
- Layer 2 GEMM: 27.780 ms
- Layer 3 GEMM: 2.453 ms
- L1 activation/scale: 1.621 ms
- L2 activation/scale: 1.000 ms
- Argmax: 0.198 ms

**These latency values are software/profile measurements, not FPGA timing.**

## End-to-end datapath

MNIST 784 INT8 -> Layer 1 784x128 -> INT32 bias -> requantize/ReLU -> 128 INT8 -> Layer 2 128x128 -> INT32 bias -> requantize/ReLU -> 128 INT8 -> Layer 3 128x10 -> 10 INT32 logits -> argmax.

## MAC workload

- Layer 1: 100,352 MACs/image
- Layer 2: 16,384 MACs/image
- Layer 3: 1,280 MACs/image
- Total: **118,016 MACs/image**
- Total parameters including biases: **118,282**

## Hardware architecture

The reusable 4x4 systolic core has 16 registered PEs. Activations move left-to-right, weights move top-to-bottom, and each PE performs signed INT8 multiplication with INT32 accumulation. `mnist_npu_top.v` is a correctness-first sequential 3-layer RTL reference that uses the same INT8/INT32 arithmetic; the 4x4 core is the optimized compute fabric to be scheduled/tiled into the final implementation.

## Repository

- `rtl/`: Verilog-2001 hardware modules
- `sim/`: RTL testbench
- `python/`: training, INT8 calibration, integer reference, profiling and memory export
- `docs/`: architecture and performance documentation
- `vivado/`: Vivado project Tcl

## Important verification rule

Python integer reference, RTL simulation and final FPGA output must use identical quantization scales, rounding, saturation, bias representation and ReLU behavior.

The repository does not fabricate trained weight files. Export the actual trained/quantized checkpoint before running end-to-end RTL classification.

## FPGA results still to measure

After Vivado synthesis/implementation measure: cycles/image, latency, throughput, LUT, FF, DSP, BRAM, Fmax, timing slack and power.

Use `python/quantize_checkpoint.py` after training to create `quantized_mnist.npz`, then `python/export_mem.py` to create Verilog memory files. See `docs/ARCHITECTURE.md` and `docs/PERFORMANCE.md`.
