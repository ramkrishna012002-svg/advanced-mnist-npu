module systolic_array_4x4(input wire clk,input wire rst,input wire en,input wire signed [7:0] a0_in,a1_in,a2_in,a3_in,input wire signed [7:0] w0_in,w1_in,w2_in,w3_in,output wire signed [31:0] acc00,acc01,acc02,acc03,acc10,acc11,acc12,acc13,acc20,acc21,acc22,acc23,acc30,acc31,acc32,acc33);
wire signed [7:0] a01,a02,a11,a12,a21,a22,a31,a32; wire signed [7:0] w10,w20,w30,w11,w21,w31,w12,w22,w32,w13,w23,w33; wire signed [7:0] x0,x1,x2,x3,y0,y1,y2,y3;
systolic_pe p00(clk,rst,en,a0_in,w0_in,x0,y0,acc00); systolic_pe p01(clk,rst,en,x0,w1_in,a01,y1,acc01); systolic_pe p02(clk,rst,en,a01,w2_in,a02,y2,acc02); systolic_pe p03(clk,rst,en,a02,w3_in,x1,y3,acc03);
systolic_pe p10(clk,rst,en,a1_in,y0,x2,w10,acc10); systolic_pe p11(clk,rst,en,x2,w11,a11,w11,acc11); systolic_pe p12(clk,rst,en,a11,w12,a12,w12,acc12); systolic_pe p13(clk,rst,en,a12,w13,x3,w13,acc13);
systolic_pe p20(clk,rst,en,a2_in,w10,x2,w20,acc20); systolic_pe p21(clk,rst,en,x2,w20,a21,w21,acc21); systolic_pe p22(clk,rst,en,a21,w22,a22,w22,acc22); systolic_pe p23(clk,rst,en,a22,w23,x3,w23,acc23);
systolic_pe p30(clk,rst,en,a3_in,w20,x2,w30,acc30); systolic_pe p31(clk,rst,en,x2,w30,a31,w31,acc31); systolic_pe p32(clk,rst,en,a31,w32,a32,w32,acc32); systolic_pe p33(clk,rst,en,a32,w33,x3,w33,acc33);
endmodule
