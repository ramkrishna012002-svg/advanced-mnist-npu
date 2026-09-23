module requant_relu #(
    parameter integer MULTIPLIER = 1,
    parameter integer SHIFT = 0
)(
    input wire signed [31:0] acc_in,
    output reg signed [7:0] out
);
reg signed [63:0] scaled;
reg signed [63:0] shifted;
always @* begin
    scaled = acc_in * MULTIPLIER;
    if (SHIFT > 0) shifted = scaled >>> SHIFT; else shifted = scaled;
    if (shifted < 0) out = 8'sd0;
    else if (shifted > 127) out = 8'sd127;
    else out = shifted[7:0];
end
endmodule
