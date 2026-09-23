import numpy as np

def gemm_int8(a: np.ndarray, b: np.ndarray) -> np.ndarray:
    """Signed INT8 GEMM with INT32 accumulation."""
    a=np.asarray(a,dtype=np.int8); b=np.asarray(b,dtype=np.int8)
    if a.shape!=(4,4) or b.shape!=(4,4): raise ValueError("Expected two 4x4 matrices.")
    return a.astype(np.int32) @ b.astype(np.int32)

if __name__=="__main__":
    A=np.array([[1,2,3,4],[5,6,7,8],[9,10,11,12],[13,14,15,16]],dtype=np.int8)
    B=np.array([[1,0,2,1],[2,1,0,2],[0,3,1,1],[1,2,2,0]],dtype=np.int8)
    print("C=\n",gemm_int8(A,B))
