module systolic_array_4x4(
    input wire clk, input wire rst, input wire en,
    input wire signed [7:0] a0_in, a1_in, a2_in, a3_in,
    input wire signed [7:0] w0_in, w1_in, w2_in, w3_in,
    output wire signed [31:0] acc00, acc01, acc02, acc03,
    output wire signed [31:0] acc10, acc11, acc12, acc13,
    output wire signed [31:0] acc20, acc21, acc22, acc23,
    output wire signed [31:0] acc30, acc31, acc32, acc33
);

wire signed [7:0] a00_o,a01_o,a02_o,a03_o;
wire signed [7:0] a10_o,a11_o,a12_o,a13_o;
wire signed [7:0] a20_o,a21_o,a22_o,a23_o;
wire signed [7:0] a30_o,a31_o,a32_o,a33_o;
wire signed [7:0] w00_o,w01_o,w02_o,w03_o;
wire signed [7:0] w10_o,w11_o,w12_o,w13_o;
wire signed [7:0] w20_o,w21_o,w22_o,w23_o;
wire signed [7:0] w30_o,w31_o,w32_o,w33_o;

systolic_pe p00(.clk(clk),.rst(rst),.en(en),.a_in(a0_in),.w_in(w0_in),.a_out(a00_o),.w_out(w00_o),.acc_out(acc00));
systolic_pe p01(.clk(clk),.rst(rst),.en(en),.a_in(a00_o),.w_in(w1_in),.a_out(a01_o),.w_out(w01_o),.acc_out(acc01));
systolic_pe p02(.clk(clk),.rst(rst),.en(en),.a_in(a01_o),.w_in(w2_in),.a_out(a02_o),.w_out(w02_o),.acc_out(acc02));
systolic_pe p03(.clk(clk),.rst(rst),.en(en),.a_in(a02_o),.w_in(w3_in),.a_out(a03_o),.w_out(w03_o),.acc_out(acc03));

systolic_pe p10(.clk(clk),.rst(rst),.en(en),.a_in(a1_in),.w_in(w00_o),.a_out(a10_o),.w_out(w10_o),.acc_out(acc10));
systolic_pe p11(.clk(clk),.rst(rst),.en(en),.a_in(a10_o),.w_in(w01_o),.a_out(a11_o),.w_out(w11_o),.acc_out(acc11));
systolic_pe p12(.clk(clk),.rst(rst),.en(en),.a_in(a11_o),.w_in(w02_o),.a_out(a12_o),.w_out(w12_o),.acc_out(acc12));
systolic_pe p13(.clk(clk),.rst(rst),.en(en),.a_in(a12_o),.w_in(w03_o),.a_out(a13_o),.w_out(w13_o),.acc_out(acc13));

systolic_pe p20(.clk(clk),.rst(rst),.en(en),.a_in(a2_in),.w_in(w10_o),.a_out(a20_o),.w_out(w20_o),.acc_out(acc20));
systolic_pe p21(.clk(clk),.rst(rst),.en(en),.a_in(a20_o),.w_in(w11_o),.a_out(a21_o),.w_out(w21_o),.acc_out(acc21));
systolic_pe p22(.clk(clk),.rst(rst),.en(en),.a_in(a21_o),.w_in(w12_o),.a_out(a22_o),.w_out(w22_o),.acc_out(acc22));
systolic_pe p23(.clk(clk),.rst(rst),.en(en),.a_in(a22_o),.w_in(w13_o),.a_out(a23_o),.w_out(w23_o),.acc_out(acc23));

systolic_pe p30(.clk(clk),.rst(rst),.en(en),.a_in(a3_in),.w_in(w20_o),.a_out(a30_o),.w_out(w30_o),.acc_out(acc30));
systolic_pe p31(.clk(clk),.rst(rst),.en(en),.a_in(a30_o),.w_in(w21_o),.a_out(a31_o),.w_out(w31_o),.acc_out(acc31));
systolic_pe p32(.clk(clk),.rst(rst),.en(en),.a_in(a31_o),.w_in(w22_o),.a_out(a32_o),.w_out(w32_o),.acc_out(acc32));
systolic_pe p33(.clk(clk),.rst(rst),.en(en),.a_in(a32_o),.w_in(w23_o),.a_out(a33_o),.w_out(w33_o),.acc_out(acc33));
endmodule
