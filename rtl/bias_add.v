module bias_add(input wire signed [31:0] logit_in,input wire signed [31:0] bias,output wire signed [31:0] logit_out); assign logit_out=logit_in+bias; endmodule
