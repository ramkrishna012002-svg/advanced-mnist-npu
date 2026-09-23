// 4x4 INT8 GEMM accelerator.
// Computes C = A x B for signed 8-bit matrices.
// Output elements use signed INT32 accumulators.
// Verilog-2001 compatible: one-dimensional memories only.

module gemm_4x4 (
    input wire clk, input wire rst, input wire start,
    input wire signed [7:0] a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33,
    input wire signed [7:0] b00,b01,b02,b03,b10,b11,b12,b13,b20,b21,b22,b23,b30,b31,b32,b33,
    output reg busy, output reg done,
    output reg signed [31:0] c00,c01,c02,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33
);
    reg signed [7:0] ar [0:15];
    reg signed [7:0] br [0:15];
    reg signed [31:0] acc [0:15];
    reg [2:0] k;
    integer i,j,idx;

    always @(posedge clk) begin
        if (rst) begin
            busy<=0; done<=0; k<=0;
            c00<=0;c01<=0;c02<=0;c03<=0;c10<=0;c11<=0;c12<=0;c13<=0;
            c20<=0;c21<=0;c22<=0;c23<=0;c30<=0;c31<=0;c32<=0;c33<=0;
            for(i=0;i<16;i=i+1) begin ar[i]<=0; br[i]<=0; acc[i]<=0; end
        end else begin
            done<=0;
            if(start && !busy) begin
                ar[0]<=a00;ar[1]<=a01;ar[2]<=a02;ar[3]<=a03;
                ar[4]<=a10;ar[5]<=a11;ar[6]<=a12;ar[7]<=a13;
                ar[8]<=a20;ar[9]<=a21;ar[10]<=a22;ar[11]<=a23;
                ar[12]<=a30;ar[13]<=a31;ar[14]<=a32;ar[15]<=a33;
                br[0]<=b00;br[1]<=b01;br[2]<=b02;br[3]<=b03;
                br[4]<=b10;br[5]<=b11;br[6]<=b12;br[7]<=b13;
                br[8]<=b20;br[9]<=b21;br[10]<=b22;br[11]<=b23;
                br[12]<=b30;br[13]<=b31;br[14]<=b32;br[15]<=b33;
                for(i=0;i<16;i=i+1) acc[i]<=0;
                k<=0; busy<=1;
            end else if(busy) begin
                for(i=0;i<4;i=i+1)
                    for(j=0;j<4;j=j+1)
                        acc[i*4+j] <= acc[i*4+j] + ar[i*4+k] * br[k*4+j];

                if(k==3) begin
                    c00<=acc[0]+ar[3]*br[12];  c01<=acc[1]+ar[3]*br[13];  c02<=acc[2]+ar[3]*br[14];  c03<=acc[3]+ar[3]*br[15];
                    c10<=acc[4]+ar[7]*br[12];  c11<=acc[5]+ar[7]*br[13];  c12<=acc[6]+ar[7]*br[14];  c13<=acc[7]+ar[7]*br[15];
                    c20<=acc[8]+ar[11]*br[12]; c21<=acc[9]+ar[11]*br[13]; c22<=acc[10]+ar[11]*br[14]; c23<=acc[11]+ar[11]*br[15];
                    c30<=acc[12]+ar[15]*br[12];c31<=acc[13]+ar[15]*br[13];c32<=acc[14]+ar[15]*br[14];c33<=acc[15]+ar[15]*br[15];
                    busy<=0; done<=1;
                end else k<=k+1'b1;
            end
        end
    end
endmodule
