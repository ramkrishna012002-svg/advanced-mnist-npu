module systolic_pe (
    input wire clk,
    input wire rst,
    input wire en,
    input wire signed [7:0] a_in,
    input wire signed [7:0] w_in,
    output reg signed [7:0] a_out,
    output reg signed [7:0] w_out,
    output reg signed [31:0] acc_out
);

reg signed [7:0] a_reg;
reg signed [7:0] w_reg;
reg signed [31:0] acc_reg;
wire signed [15:0] product;
wire signed [31:0] product_ext;

assign product = a_reg * w_reg;
assign product_ext = {{16{product[15]}}, product};

always @(posedge clk) begin
    if (rst) begin
        a_reg   <= 8'sd0;
        w_reg   <= 8'sd0;
        acc_reg <= 32'sd0;
        a_out   <= 8'sd0;
        w_out   <= 8'sd0;
        acc_out <= 32'sd0;
    end else if (en) begin
        a_reg   <= a_in;
        w_reg   <= w_in;
        a_out   <= a_reg;
        w_out   <= w_reg;
        acc_reg <= acc_reg + product_ext;
        acc_out <= acc_reg + product_ext;
    end
end
endmodule
