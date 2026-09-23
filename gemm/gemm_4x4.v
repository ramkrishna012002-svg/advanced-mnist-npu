// 4x4 INT8 GEMM accelerator.
// Computes C = A x B for signed 8-bit matrices.
// Each output element has an independent INT32 accumulator.
// K=4, so one matrix multiplication takes 4 MAC cycles after start.

module gemm_4x4 (
    input wire clk, input wire rst, input wire start,
    input wire signed [7:0] a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33,
    input wire signed [7:0] b00,b01,b02,b03,b10,b11,b12,b13,b20,b21,b22,b23,b30,b31,b32,b33,
    output reg busy, output reg done,
    output reg signed [31:0] c00,c01,c02,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33
);
    reg signed [7:0] ar [0:3][0:3];
    reg signed [7:0] br [0:3][0:3];
    reg signed [31:0] acc [0:3][0:3];
    reg [2:0] k;
    integer i,j;

    always @(posedge clk) begin
        if (rst) begin
            busy <= 0; done <= 0; k <= 0;
            c00<=0;c01<=0;c02<=0;c03<=0;c10<=0;c11<=0;c12<=0;c13<=0;
            c20<=0;c21<=0;c22<=0;c23<=0;c30<=0;c31<=0;c32<=0;c33<=0;
            for(i=0;i<4;i=i+1) for(j=0;j<4;j=j+1) acc[i][j] <= 0;
        end else begin
            done <= 0;
            if (start && !busy) begin
                ar[0][0]<=a00; ar[0][1]<=a01; ar[0][2]<=a02; ar[0][3]<=a03;
                ar[1][0]<=a10; ar[1][1]<=a11; ar[1][2]<=a12; ar[1][3]<=a13;
                ar[2][0]<=a20; ar[2][1]<=a21; ar[2][2]<=a22; ar[2][3]<=a23;
                ar[3][0]<=a30; ar[3][1]<=a31; ar[3][2]<=a32; ar[3][3]<=a33;
                br[0][0]<=b00; br[0][1]<=b01; br[0][2]<=b02; br[0][3]<=b03;
                br[1][0]<=b10; br[1][1]<=b11; br[1][2]<=b12; br[1][3]<=b13;
                br[2][0]<=b20; br[2][1]<=b21; br[2][2]<=b22; br[2][3]<=b23;
                br[3][0]<=b30; br[3][1]<=b31; br[3][2]<=b32; br[3][3]<=b33;
                for(i=0;i<4;i=i+1) for(j=0;j<4;j=j+1) acc[i][j] <= 0;
                k <= 0; busy <= 1;
            end else if (busy) begin
                for(i=0;i<4;i=i+1)
                    for(j=0;j<4;j=j+1)
                        acc[i][j] <= acc[i][j] + ar[i][k] * br[k][j];
                if(k==3) begin
                    c00<=acc[0][0]+ar[0][3]*br[3][0]; c01<=acc[0][1]+ar[0][3]*br[3][1];
                    c02<=acc[0][2]+ar[0][3]*br[3][2]; c03<=acc[0][3]+ar[0][3]*br[3][3];
                    c10<=acc[1][0]+ar[1][3]*br[3][0]; c11<=acc[1][1]+ar[1][3]*br[3][1];
                    c12<=acc[1][2]+ar[1][3]*br[3][2]; c13<=acc[1][3]+ar[1][3]*br[3][3];
                    c20<=acc[2][0]+ar[2][3]*br[3][0]; c21<=acc[2][1]+ar[2][3]*br[3][1];
                    c22<=acc[2][2]+ar[2][3]*br[3][2]; c23<=acc[2][3]+ar[2][3]*br[3][3];
                    c30<=acc[3][0]+ar[3][3]*br[3][0]; c31<=acc[3][1]+ar[3][3]*br[3][1];
                    c32<=acc[3][2]+ar[3][3]*br[3][2]; c33<=acc[3][3]+ar[3][3]*br[3][3];
                    busy <= 0; done <= 1;
                end else k <= k + 1'b1;
            end
        end
    end
endmodule
