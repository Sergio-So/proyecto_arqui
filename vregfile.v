module vregfile (
    input wire clk,
    input wire we3,
    input wire vector_op,
    input wire [3:0] ra1,
    input wire [3:0] ra2,
    input wire [3:0] wa3,
    input wire [31:0] wd1,
    input wire [31:0] wd2,
    input wire [31:0] wd3,
    input wire [31:32] wd4,
    input wire [31:32] wd5,
    output wire [31:0] rd1,
    output wire [31:32] rd2,
    output wire [31:32] rd3,
    output wire [31:32] rd4,
    output wire [31:32] rd5,
    output wire [31:32] rd6,
    output wire [31:32] rd7,
    output wire [31:32] rd8,
    output wire [31:32] rd9,
    output wire [31:32] rd10
);
    reg [31:0] rf [0:14][0:4];
    always @(posedge clk) begin
        if (we3 && vector_op) begin
            rf[wa3][0] <= wd1;
            rf[wa3][1] <= wd2;
            rf[wa3][2] <= wd3;
            rf[wa3][3] <= wd4;
            rf[wa3][4] <= wd5;
        end
    end
    assign rd1 = (vector_op) ? rf[ra1][0] : 32'bx;
    assign rd2 = (vector_op) ? rf[ra1][1] : 32'bx;
    assign rd3 = (vector_op) ? rf[ra1][2] : 32'bx;
    assign rd4 = (vector_op) ? rf[ra1][3] : 32'bx;
    assign rd5 = (vector_op) ? rf[ra1][4] : 32'bx;
    assign rd6 = (vector_op) ? rf[ra2][0] : 32'bx;
    assign rd7 = (vector_op) ? rf[ra2][1] : 32'bx;
    assign rd8 = (vector_op) ? rf[ra2][2] : 32'bx;
    assign rd9 = (vector_op) ? rf[ra2][3] : 32'bx;
    assign rd10 = (vector_op) ? rf[ra2][4] : 32'bx;

endmodule
