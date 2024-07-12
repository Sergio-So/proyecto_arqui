module floating_point_adder (
    input wire [31:0] a,  
    input wire [31:0] b,
    input wire selector, 
    output reg [31:0] sum 
);

wire [15:0] asix = a[15:0];
wire [15:0] bsix = b[15:0];

wire sign_asix = asix[15];
wire [4:0] exponent_asix = asix[14:10];
wire [9:0] mantissa_asix = asix[9:0];

wire sign_bsix = bsix[15];
wire [4:0] exponent_bsix = bsix[14:10];
wire [9:0] mantissa_bsix = bsix[9:0];

wire [10:0] mantissa_a_norm_six = {1'b1, mantissa_asix};
wire [10:0] mantissa_b_norm_six = {1'b1, mantissa_bsix};

wire [4:0] exp_diff_six;
wire [10:0] mantissa_larger_six, mantissa_smaller_six;
wire [4:0] exponent_larger_six;
wire sign_larger_six, sign_smaller_six;

wire sign_a = a[31];
wire [7:0] exponent_a = a[30:23];
wire [22:0] mantissa_a = a[22:0];

wire sign_b = b[31];
wire [7:0] exponent_b = b[30:23];
wire [22:0] mantissa_b = b[22:0];

wire [23:0] mantissa_a_norm = {1'b1, mantissa_a};
wire [23:0] mantissa_b_norm = {1'b1, mantissa_b};

wire [7:0] exp_diff;
wire [23:0] mantissa_larger, mantissa_smaller;
wire [7:0] exponent_larger;
wire sign_larger, sign_smaller;

assign exp_diff_six = (exponent_asix > exponent_bsix) ? (exponent_asix - exponent_bsix) : (exponent_bsix - exponent_asix);
assign mantissa_larger_six = (exponent_asix > exponent_bsix) ? mantissa_a_norm_six : mantissa_b_norm_six;
assign mantissa_smaller_six = (exponent_asix > exponent_bsix) ? mantissa_b_norm_six : mantissa_a_norm_six;
assign exponent_larger_six = (exponent_asix > exponent_bsix) ? exponent_asix : exponent_bsix;
assign sign_larger_six = (exponent_asix > exponent_bsix) ? sign_asix : sign_bsix;
assign sign_smaller_six = (exponent_asix > exponent_bsix) ? sign_bsix : sign_asix;

wire [10:0] mantissa_smaller_aligned_six = mantissa_smaller_six >> exp_diff_six;

assign exp_diff = (exponent_a > exponent_b) ? (exponent_a - exponent_b) : (exponent_b - exponent_a);
assign mantissa_larger = (exponent_a > exponent_b) ? mantissa_a_norm : mantissa_b_norm;
assign mantissa_smaller = (exponent_a > exponent_b) ? mantissa_b_norm : mantissa_a_norm;
assign exponent_larger = (exponent_a > exponent_b) ? exponent_a : exponent_b;
assign sign_larger = (exponent_a > exponent_b) ? sign_a : sign_b;
assign sign_smaller = (exponent_a > exponent_b) ? sign_b : sign_a;

wire [23:0] mantissa_smaller_aligned = mantissa_smaller >> exp_diff;

wire [11:0] mantissa_sum_six;
assign mantissa_sum_six = (sign_larger_six == sign_smaller_six) ? (mantissa_larger_six + mantissa_smaller_aligned_six) : (mantissa_larger_six - mantissa_smaller_aligned_six);

reg [10:0] mantissa_normalized_six;
reg [4:0] exponent_normalized_six;
reg [11:0] mantissa_temp_six;
integer i_six;
reg loop_exit_flag_six;

wire [24:0] mantissa_sum;
assign mantissa_sum = (sign_larger == sign_smaller) ? (mantissa_larger + mantissa_smaller_aligned) : (mantissa_larger - mantissa_smaller_aligned);

reg [23:0] mantissa_normalized;
reg [7:0] exponent_normalized;
reg [24:0] mantissa_temp;
integer i;
reg loop_exit_flag;

always @(*) begin
    mantissa_temp_six = mantissa_sum_six;
    exponent_normalized_six = exponent_larger_six;
    loop_exit_flag_six = 0;

    if (mantissa_temp_six[11] == 1) begin
        mantissa_normalized_six = mantissa_temp_six[11:1];
        exponent_normalized_six = exponent_normalized_six + 1;
    end else begin

        for (i_six = 0; i_six < 10; i_six = i_six + 1) begin
            if (mantissa_temp_six[10] == 1 || loop_exit_flag_six) begin
                mantissa_normalized_six = mantissa_temp_six[10:0];
                loop_exit_flag_six = 1;
            end else begin
                mantissa_temp_six = mantissa_temp_six << 1;
                exponent_normalized_six = exponent_normalized_six - 1;
            end
        end
        if (!loop_exit_flag_six) begin
            mantissa_normalized_six = mantissa_temp_six[10:0];
        end
    end
end

always @(*) begin
    mantissa_temp = mantissa_sum;
    exponent_normalized = exponent_larger;
    loop_exit_flag = 0;

    if (mantissa_temp[24] == 1) begin
        mantissa_normalized = mantissa_temp[24:1];
        exponent_normalized = exponent_normalized + 1;
    end else begin

        for (i = 0; i < 23; i = i + 1) begin
            if (mantissa_temp[23] == 1 || loop_exit_flag) begin
                mantissa_normalized = mantissa_temp[23:0];
                loop_exit_flag = 1;
            end else begin
                mantissa_temp = mantissa_temp << 1;
                exponent_normalized = exponent_normalized - 1;
            end
        end
        if (!loop_exit_flag) begin
            mantissa_normalized = mantissa_temp[23:0];
        end
    end
end


wire [15:0] prueba = {sign_larger_six, exponent_normalized_six, mantissa_normalized_six[9:0]}; 

always @(*) begin
        if(selector)
            sum = {16'b0,sign_larger_six, exponent_normalized_six, mantissa_normalized_six[9:0]};
        else
            sum = {sign_larger, exponent_normalized, mantissa_normalized[22:0]};    
end

endmodule