module floating_point_multiplier (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire selector,
    output reg [31:0] product
);

wire [15:0] a_six = a[15:0];
wire [15:0] b_six = b[15:0];

wire sign_a_six = a_six[15];
wire [4:0] exponent_a_six = a_six[14:10];
wire [9:0] mantissa_a_six = a_six[9:0];

wire sign_b_six = b_six[15];
wire [4:0] exponent_b_six = b_six[14:10];
wire [9:0] mantissa_b_six = b_six[9:0];

wire [10:0] mantissa_a_norm_six = {1'b1, mantissa_a_six};
wire [10:0] mantissa_b_norm_six = {1'b1, mantissa_b_six};

wire [21:0] mantissa_product_six = mantissa_a_norm_six * mantissa_b_norm_six;

wire [5:0] exponent_sum_six = exponent_a_six + exponent_b_six - 15; // Ajustar por el bias

wire sign_product_six = sign_a_six ^ sign_b_six;

reg [9:0] mantissa_normalized_six;
reg [4:0] exponent_normalized_six;
reg overflow_six;

wire sign_a = a[31];
wire [7:0] exponent_a = a[30:23];
wire [22:0] mantissa_a = a[22:0];

wire sign_b = b[31];
wire [7:0] exponent_b = b[30:23];
wire [22:0] mantissa_b = b[22:0];

wire [23:0] mantissa_a_norm = {1'b1, mantissa_a};
wire [23:0] mantissa_b_norm = {1'b1, mantissa_b};

wire [47:0] mantissa_product = mantissa_a_norm * mantissa_b_norm;

wire [8:0] exponent_sum = exponent_a + exponent_b - 127; // Ajustar por el bias

wire sign_product = sign_a ^ sign_b;

reg [22:0] mantissa_normalized;
reg [7:0] exponent_normalized;
reg overflow;

always @(*) begin
    if (mantissa_product_six[21] == 1) begin
        mantissa_normalized_six = mantissa_product_six[20:11];
        exponent_normalized_six = exponent_sum_six + 1;
    end else begin
        mantissa_normalized_six = mantissa_product_six[19:10];
        exponent_normalized_six = exponent_sum_six;
    end
    overflow_six = (exponent_normalized_six > 5'h1E) || (exponent_sum_six[5] == 1);
end

always @(*) begin
    if (mantissa_product[47] == 1) begin
        mantissa_normalized = mantissa_product[46:24];
        exponent_normalized = exponent_sum + 1;
    end else begin
        mantissa_normalized = mantissa_product[45:23];
        exponent_normalized = exponent_sum;
    end
    overflow = (exponent_normalized > 8'hFE) || (exponent_sum[8] == 1);
end

wire [15:0] prueba2 = {sign_product_six, exponent_normalized_six, mantissa_normalized_six};

always @(*) begin
    if(selector) begin
        if (overflow_six) begin
            product = {sign_product_six, 5'h1F, 10'h0};
        end else begin
            product = {16'b0,sign_product_six, exponent_normalized_six, mantissa_normalized_six};
        end
    end
    else begin
        if (overflow) begin
            product = {sign_product, 8'hFF, 23'h0};
        end else begin
            product = {sign_product, exponent_normalized, mantissa_normalized};
        end
    end
end

endmodule