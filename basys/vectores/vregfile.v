module vregfile (
    input wire clk,
    input wire vector_op,
    input wire [2:0] vector_size,
    input wire [3:0] ra1,
    input wire [3:0] ra2,
    input wire [3:0] wa3,
    input wire [31:0] wd1,
    input wire [31:0] wd2,
    input wire [31:0] wd3,
    input wire [31:0] wd4,
    input wire [31:0] wd5,
    output wire [31:0] rd1,
    output wire [31:0] rd2,
    output wire [31:0] rd3,
    output wire [31:0] rd4,
    output wire [31:0] rd5,
    output wire [31:0] rd6,
    output wire [31:0] rd7,
    output wire [31:0] rd8,
    output wire [31:0] rd9,
    output wire [31:0] rd10
);
    reg [31:0] rf [0:14][0:4];

    
    always @(posedge clk) begin
        if (vector_op) begin
            if (vector_size >= 1) rf[wa3][0] <= wd1;
            if (vector_size >= 2) rf[wa3][1] <= wd2;
            if (vector_size >= 3) rf[wa3][2] <= wd3;
            if (vector_size >= 4) rf[wa3][3] <= wd4;
            if (vector_size >= 5) rf[wa3][4] <= wd5;
        end
    end
    initial begin
    // vector registers .-.
    rf[1][0] = 32'H00000002;
    rf[1][1] = 32'H00000002;
    rf[1][2] = 32'H00000002;
    rf[1][3] = 32'H00000002;
    rf[1][4] = 32'H00000002;
    rf[2][0] = 32'H00000003;
    rf[2][1] = 32'H00000004;
    rf[2][2] = 32'H00000005;
    rf[2][3] = 32'H00000006;
    rf[2][4] = 32'H00000007;
    rf[4][0] = 32'H00000002;
    rf[4][1] = 32'H00000002;
    rf[4][2] = 32'H00000002;
    rf[4][3] = 32'H00000002;
    rf[4][4] = 32'H00000002;
    //floating vector registers .-.
    rf[6][0] = 32'H3f400000;
    rf[6][1] = 32'H3fb33333;
    rf[6][2] = 32'H3ff00000;
    rf[6][3] = 32'H3e02de01;
    rf[6][4] = 32'H3e800000;
    rf[7][0] = 32'H3ff00000;
    rf[7][1] = 32'H3ff00000;
    rf[7][2] = 32'H3fb33333;
    rf[7][3] = 32'H3e800000;
    rf[7][4] = 32'H3fb33333;
    rf[8][0] = 32'H3f400000;
    rf[8][1] = 32'H3ff00000;
    rf[8][2] = 32'H3e02de01;
    rf[8][3] = 32'H3f400000;
    rf[8][4] = 32'H3e800000;
        
    end
    
    
    assign rd1 = (vector_op & vector_size >= 1) ? rf[ra1][0] : 32'bx;
    assign rd2 = (vector_op & vector_size >= 2) ? rf[ra1][1] : 32'bx;
    assign rd3 = (vector_op & vector_size >= 3) ? rf[ra1][2] : 32'bx;
    assign rd4 = (vector_op & vector_size >= 4) ? rf[ra1][3] : 32'bx;
    assign rd5 = (vector_op & vector_size >= 5) ? rf[ra1][4] : 32'bx;
    assign rd6 = (vector_op & vector_size >= 1) ? rf[ra2][0] : 32'bx;
    assign rd7 = (vector_op & vector_size >= 2) ? rf[ra2][1] : 32'bx;
    assign rd8 = (vector_op & vector_size >= 3) ? rf[ra2][2] : 32'bx;
    assign rd9 = (vector_op & vector_size >= 4) ? rf[ra2][3] : 32'bx;
    assign rd10 = (vector_op & vector_size >= 5) ? rf[ra2][4] : 32'bx;

endmodule
