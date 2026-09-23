// Correctness-first 3-layer RTL reference.
// The optimized 4x4 systolic fabric is provided separately in systolic_array_4x4.v.
module mnist_npu_top #(
    parameter integer L1_MULTIPLIER=1, parameter integer L1_SHIFT=0,
    parameter integer L2_MULTIPLIER=1, parameter integer L2_SHIFT=0
)(
    input wire clk, input wire rst, input wire start,
    input wire signed [7:0] pixel_in, input wire pixel_we, input wire [9:0] pixel_addr,
    output reg busy, output reg done, output reg [3:0] predicted_digit
);
reg signed [7:0] x[0:783], a1[0:127], a2[0:127];
reg signed [7:0] w1[0:100351], w2[0:16383], w3[0:1279];
reg signed [31:0] b1[0:127], b2[0:127], b3[0:9], logits[0:9];
integer i;
initial begin
    $readmemh("weights_l1.mem",w1); $readmemh("weights_l2.mem",w2); $readmemh("weights_l3.mem",w3);
    $readmemh("bias_l1.mem",b1); $readmemh("bias_l2.mem",b2); $readmemh("bias_l3.mem",b3);
end
localparam IDLE=3'd0,L1=3'd1,Q1=3'd2,L2=3'd3,Q2=3'd4,L3=3'd5,DONE=3'd6;
reg [2:0] state; reg [9:0] k; reg [7:0] n;
reg signed [31:0] acc; reg signed [63:0] scaled,shifted; reg signed [31:0] best;
integer j;
function signed [7:0] relu8;
    input signed [63:0] v;
    begin if(v<0) relu8=8'sd0; else if(v>127) relu8=8'sd127; else relu8=v[7:0]; end
endfunction
always @(posedge clk) begin
    if(rst) begin
        busy<=0; done<=0; predicted_digit<=0; state<=IDLE; k<=0; n<=0; acc<=0;
        for(i=0;i<128;i=i+1) begin a1[i]<=0; a2[i]<=0; end
        for(i=0;i<10;i=i+1) logits[i]<=0;
    end else begin
        done<=0;
        if(pixel_we && !busy && pixel_addr<784) x[pixel_addr]<=pixel_in;
        case(state)
        IDLE: if(start) begin busy<=1; n<=0; k<=0; acc<=b1[0]; state<=L1; end
        L1: begin
            acc<=acc + x[k]*w1[n*784+k];
            if(k==783) state<=Q1; else k<=k+1'b1;
        end
        Q1: begin
            scaled=acc*L1_MULTIPLIER; if(L1_SHIFT>0) shifted=scaled>>>L1_SHIFT; else shifted=scaled;
            a1[n]<=relu8(shifted); k<=0;
            if(n==127) begin n<=0; acc<=b2[0]; state<=L2; end
            else begin n<=n+1'b1; acc<=b1[n+1'b1]; state<=L1; end
        end
        L2: begin
            acc<=acc + a1[k]*w2[n*128+k];
            if(k==127) state<=Q2; else k<=k+1'b1;
        end
        Q2: begin
            scaled=acc*L2_MULTIPLIER; if(L2_SHIFT>0) shifted=scaled>>>L2_SHIFT; else shifted=scaled;
            a2[n]<=relu8(shifted); k<=0;
            if(n==127) begin n<=0; acc<=b3[0]; state<=L3; end
            else begin n<=n+1'b1; acc<=b2[n+1'b1]; state<=L2; end
        end
        L3: begin
            acc<=acc + a2[k]*w3[n*128+k];
            if(k==127) begin
                logits[n]<=acc + a2[k]*w3[n*128+k]; k<=0;
                if(n==9) state<=DONE; else begin n<=n+1'b1; acc<=b3[n+1'b1]; end
            end else k<=k+1'b1;
        end
        DONE: begin
            best=logits[0]; predicted_digit<=0;
            for(j=1;j<10;j=j+1) if(logits[j]>best) begin best=logits[j]; predicted_digit<=j[3:0]; end
            busy<=0; done<=1; state<=IDLE;
        end
        default: state<=IDLE;
        endcase
    end
end
endmodule
