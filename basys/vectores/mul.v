module mult(
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] result,
    output wire [31:0] overflow
);
    wire [63:0] rs;
    assign rs = a * b; // Multiplicación
    assign result = rs[31:0];
    assign overflow = rs[63:32];
endmodule