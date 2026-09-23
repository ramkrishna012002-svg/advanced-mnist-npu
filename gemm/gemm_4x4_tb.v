`timescale 1ns/1ps
module gemm_4x4_tb;
reg clk=0,rst=1,start=0;
reg signed [7:0] a00,a01,a02,a03,a10,a11,a12,a13,a20,a21,a22,a23,a30,a31,a32,a33;
reg signed [7:0] b00,b01,b02,b03,b10,b11,b12,b13,b20,b21,b22,b23,b30,b31,b32,b33;
wire busy,done;
wire signed [31:0] c00,c01,c02,c03,c10,c11,c12,c13,c20,c21,c22,c23,c30,c31,c32,c33;
gemm_4x4 dut(
.clk(clk),.rst(rst),.start(start),
.a00(a00),.a01(a01),.a02(a02),.a03(a03),.a10(a10),.a11(a11),.a12(a12),.a13(a13),
.a20(a20),.a21(a21),.a22(a22),.a23(a23),.a30(a30),.a31(a31),.a32(a32),.a33(a33),
.b00(b00),.b01(b01),.b02(b02),.b03(b03),.b10(b10),.b11(b11),.b12(b12),.b13(b13),
.b20(b20),.b21(b21),.b22(b22),.b23(b23),.b30(b30),.b31(b31),.b32(b32),.b33(b33),
.busy(busy),.done(done),
.c00(c00),.c01(c01),.c02(c02),.c03(c03),.c10(c10),.c11(c11),.c12(c12),.c13(c13),
.c20(c20),.c21(c21),.c22(c22),.c23(c23),.c30(c30),.c31(c31),.c32(c32),.c33(c33));
always #5 clk=~clk;
initial begin
a00=1;a01=2;a02=3;a03=4;a10=5;a11=6;a12=7;a13=8;a20=9;a21=10;a22=11;a23=12;a30=13;a31=14;a32=15;a33=16;
b00=1;b01=0;b02=2;b03=1;b10=2;b11=1;b12=0;b13=2;b20=0;b21=3;b22=1;b23=1;b30=1;b31=2;b32=2;b33=0;
#12 rst=0; #10 start=1; #10 start=0;
wait(done); #1;
$display("C ="); $display("%0d %0d %0d %0d",c00,c01,c02,c03);
$display("%0d %0d %0d %0d",c10,c11,c12,c13);
$display("%0d %0d %0d %0d",c20,c21,c22,c23);
$display("%0d %0d %0d %0d",c30,c31,c32,c33);
if(c00!==9||c01!==19||c02!==13||c03!==8||c10!==25||c11!==43||c12!==33||c13!==24||c20!==41||c21!==67||c22!==53||c23!==40||c30!==57||c31!==91||c32!==73||c33!==56) $fatal(1,"GEMM result mismatch");
$display("PASS: 4x4 INT8 GEMM"); $finish;
end
endmodule
