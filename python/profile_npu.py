REPORTED_MS = {
    'input_preparation': 98.216,
    'layer1_gemm': 18.428,
    'layer1_activation_scale': 1.621,
    'layer2_gemm': 27.780,
    'layer2_activation_scale': 1.000,
    'layer3_gemm': 2.453,
    'argmax': 0.198,
}

def main():
    total = sum(REPORTED_MS.values())
    print('=== Integer NPU profile: 1,000 samples ===')
    for k, v in REPORTED_MS.items(): print(f'{k:28s}: {v:8.3f} ms')
    print(f'total reported stages      : {total:8.3f} ms')
    print(f'average per sample         : {total/1000.0:8.6f} ms')
    print('NOTE: software/profile measurements, not FPGA timing.')

if __name__ == '__main__': main()
