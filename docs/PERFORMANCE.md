# Performance Benchmark

## Reported software/profile benchmark

Network: 784 -> 128 -> 128 -> 10

| Stage | Time |
|---|---:|
| Input preparation | 98.216 ms |
| Layer 1 GEMM | 18.428 ms |
| Layer 2 GEMM | 27.780 ms |
| Layer 3 GEMM | 2.453 ms |
| L1 activation/scale | 1.621 ms |
| L2 activation/scale | 1.000 ms |
| Argmax | 0.198 ms |

Reported accuracy: FP32 96.48%; full Integer NPU model 93.70%; difference 2.78 percentage points.

Reported stage sum: 149.696 ms / 1,000 samples, or 0.149696 ms/sample.

These are software/profile measurements, not FPGA timing.

## MAC workload

- L1: 100,352 MACs/image
- L2: 16,384 MACs/image
- L3: 1,280 MACs/image
- Total: 118,016 MACs/image

## FPGA measurements still required

- clock frequency and Fmax
- cycles/image and end-to-end latency
- images/second
- LUT, FF, DSP and BRAM
- timing slack
- power
