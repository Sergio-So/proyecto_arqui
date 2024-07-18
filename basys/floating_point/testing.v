module testing(a,b,c,d,op,result);
    input a,b,c,d,op;
    output wire [15:0] result;
    
    wire [31:0] a1;
    wire [31:0] b1;
    wire [31:0] c1;
    wire [31:0] d1;
    wire [31:0] r1;
    wire [31:0] r2;
    wire [31:0] r4;
    wire [31:0] r5;
    reg [31:0] r3;
    
    assign a1 = 32'H3FC00000; //1.5
    assign b1 = 32'H3F400000; //0.75
    assign c1 = 32'H3FA66666; //1.3
    assign d1 = 32'H40880000; //4.25
    
    floating_point_adder f1 (.a(a1), .b(b1), .selector(op), .sum(r1));
    floating_point_adder f2 (.a(c1), .b(d1), .selector(op), .sum(r2));
    floating_point_multiplier m1(.a(a1),.b(b1),.selector(1'b0),.product(r4));
    floating_point_multiplier m2(.a(c1),.b(d1),.selector(1'b0),.product(r5));
     
    
    always @(*) begin
    if (op) begin
        if (a & b) begin
            r3 = r4;
        end
        else if (c & d)begin
            r3 = r5;
        end
        else begin
            r3 = 32'b0;
        end    
    end
    else begin
        if (a & b) begin
            r3 = r1;
        end
        else if(c & d)begin
            r3 = r2;
        end
        else begin
            r3 = 32'b0;
        end
     end   
end

assign result = r3[31:16];
endmodule
