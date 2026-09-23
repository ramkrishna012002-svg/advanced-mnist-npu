# 4x4 INT8 GEMM Accelerator

This directory adds a small, synthesizable GEMM building block to the **advanced-mnist-npu** project.

## Operation

**C = A x B**

- A: 4x4 signed INT8
- B: 4x4 signed INT8
- C: 4x4 signed INT32
- 16 independent MAC accumulators
- 4 MAC cycles after the input matrices are captured
- No floating-point arithmetic in RTL
- Verilog-2001 style `.v` source

## Files

- `gemm_4x4.v` — synthesizable RTL
- `gemm_4x4_tb.v` — self-checking Verilog testbench
- `../python/gemm_reference.py` — NumPy reference model
- `../vivado/add_gemm.tcl` — adds the GEMM sources to an existing Vivado project

## Verification vector

The testbench uses:

A =
```
 1  2  3  4
 5  6  7  8
 9 10 11 12
13 14 15 16
```

B =
```
1 0 2 1
2 1 0 2
0 3 1 1
1 2 2 0
```

Expected C =
```
 9 19 13  8
25 43 33 24
41 67 53 40
57 91 73 56
```

The Verilog testbench checks all 16 outputs. The Python reference uses NumPy INT32 arithmetic for the same calculation.

## MNIST connection

A dense neural-network layer is a GEMM:

`Y = X x W + b`

For the 784 -> 128 -> 128 -> 10 network:

`(batch x 784) x (784 x 128)`

`(batch x 128) x (128 x 128)`

`(batch x 128) x (128 x 10)`

This 4x4 block is a compact verified tile/reference building block for larger tiled GEMM operations.
