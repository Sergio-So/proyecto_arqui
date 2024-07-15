module mult (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] result,
	output wire [31:0] overflow
);
	wire [64:0] rs;
    assign rs = a * b;
	assign result = rs[31:0];
	assign overlfow = rs[64:32];
endmodule
