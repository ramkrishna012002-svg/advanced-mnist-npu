# Advanced MNIST NPU FPGA

Development/starter architecture for an **INT8 MNIST neural-network accelerator** targeting FPGA implementation in plain Verilog.

> **Status:** Development / starter architecture. The RTL modules are organized around a 4×4 true systolic array, but this repository does **not** claim production-ready MNIST inference. The included testbench is an architectural/RTL sanity test and does not verify end-to-end classification accuracy on the MNIST dataset.

## Architecture

- MNIST input: 28×28 = 784 values
- Classes: 10 digits (0–9)
- Numeric format: signed INT8 activations and weights
- MAC accumulation: signed INT32
- Compute core: 4×4 true systolic array
- Activation movement: left → right
- Weight movement: top → bottom
- PE operation: `acc <= acc + A_in × W_in`
- Class processing: 10 classes can be handled as three 4-column groups (4 + 4 + 2)
- Bias: 10 signed INT32 values
- Final decision: argmax over 10 logits
- HDL: Verilog-2001 style `.v` only; no SystemVerilog `.sv` sources

## Repository layout

```text
advanced-mnist-npu/
├── README.md
├── .gitignore
├── docs/
│   └── ARCHITECTURE.md
├── rtl/
│   ├── systolic_pe.v
│   ├── systolic_array_4x4.v
│   ├── input_buffer.v
│   ├── weight_buffer.v
│   ├── bias_add.v
│   ├── argmax.v
│   ├── npu_controller.v
│   └── mnist_npu_top.v
├── sim/
│   └── mnist_npu_tb.v
├── python/
│   ├── golden_model.py
│   └── quantize_mnist.py
└── vivado/
    └── create_project.tcl
```

## Important scope

This project is intended to make the hardware/software mapping explicit before optimizing for a particular Xilinx FPGA. The current RTL is a modular starter design. It should be treated as a development baseline for subsequent integration, timing closure, BRAM inference, quantization calibration, and end-to-end MNIST verification.

The Python model is the reference for signed INT8 × INT8 → INT32 arithmetic and argmax. The FPGA testbench does not prove that a trained MNIST model produces correct digits.

## Data path

```text
784 INT8 pixels
      |
      v
 Input Buffer
      |
      v
4x4 True Systolic Array  <--- Weight Buffer
      |
      v
 INT32 partial logits
      |
      v
 Bias Add
      |
      v
 10 logits
      |
      v
 Argmax
      |
      v
 digit 0..9
```

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the detailed mapping.

## Vivado

The Tcl script is a starting point for creating a Vivado project. Edit the FPGA part in `vivado/create_project.tcl` for the device/board you actually use.

## Python

`python/golden_model.py` demonstrates the integer arithmetic used by the hardware.

`python/quantize_mnist.py` provides a simple, explicit INT8 quantization utility. Real model deployment should use calibration scales derived from the trained model rather than assuming an arbitrary fixed scale.

## Next development steps

1. Connect the 784-element feature schedule to the systolic array with the required skewing.
2. Load trained 10×784 weights and 10 biases from a reproducible quantization flow.
3. Complete class-group scheduling for 4 + 4 + 2 output classes.
4. Add end-to-end MNIST vectors to the testbench.
5. Compare every FPGA logit against the Python golden model.
6. Infer BRAMs for input/weight storage and add a DMA/host interface as needed.
7. Synthesize and measure LUT, DSP, BRAM, Fmax, latency and power.

## License

Add the license you want to use before distributing the project publicly.
