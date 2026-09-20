module systolic_array_4x4(
    input wire clk,input wire rst,input wire en,
    input wire signed [7:0] a0_in,a1_in,a2_in,a3_in,
    input wire signed [7:0] w0_in,w1_in,w2_in,w3_in,
    output wire signed [31:0] acc00,acc01,acc02,acc03,
    output wire signed [31:0] acc10,acc11,acc12,acc13,
    output wire signed [31:0] acc20,acc21,acc22,acc23,
    output wire signed [31:0] acc30,acc31,acc32,acc33
);
wire signed [7:0] a00_o,a01_o,a02_o,a10_o,a11_o,a12_o,a20_o,a21_o,a22_o,a30_o,a31_o,a32_o;
wire signed [7:0] w00_o,w01_o,w02_o,w03_o,w10_o,w11_o,w12_o,w13_o,w20_o,w21_o,w22_o,w23_o,w30_o,w31_o,w32_o,w33_o;
systolic_pe p00(clk,rst,en,a0_in,w0_in,a00_o,w00_o,acc00);
systolic_pe p01(clk,rst,en,a00_o,w1_in,a01_o,w01_o,acc01);
systolic_pe p02(clk,rst,en,a01_o,w2_in,a02_o,w02_o,acc02);
systolic_pe p03(clk,rst,en,a02_o,w3_in,a03_o,w03_o,acc03);
systolic_pe p10(clk,rst,en,a1_in,w00_o,a10_o,w10_o,acc10);
systolic_pe p11(clk,rst,en,a10_o,w01_o,a11_o,w11_o,acc11);
systolic_pe p12(clk,rst,en,a11_o,w02_o,a12_o,w12_o,acc12);
systolic_pe p13(clk,rst,en,a12_o,w03_o,a13_o,w13_o,acc13);
systolic_pe p20(clk,rst,en,a2_in,w10_o,a20_o,w20_o,acc20);
systolic_pe p21(clk,rst,en,a20_o,w11_o,a21_o,w21_o,acc21);
systolic_pe p22(clk,rst,en,a21_o,w12_o,a22_o,w22_o,acc22);
systolic_pe p23(clk,rst,en,a22_o,w13_o,a23_o,w23_o,acc23);
systolic_pe p30(clk,rst,en,a3_in,w20_o,a30_o,w30_o,acc30);
systolic_pe p31(clk,rst,en,a30_o,w21_o,a31_o,w31_o,acc31);
systolic_pe p32(clk,rst,en,a31_o,w22_o,a32_o,w32_o,acc32);
systolic_pe p33(clk,rst,en,a32_o,w23_o,a33_o,w33_o,acc33);
endmodule
