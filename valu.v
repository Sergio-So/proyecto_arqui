module valu (
	rd1, rd2, rd3, rd4, rd5, rd6, rd7, rd8, rd9, rd10, ALUControl, VALUResultA, VALUResultB, VALUResultC, VALUResultD, VALUResultE, vector_op, Op
);
	//input [31:0] VSrcA [0:4];
	input wire [31:0] rd1;
	input wire [31:0] rd2;
	input wire [31:0] rd3;
	input wire [31:0] rd4;
	input wire [31:0] rd5;
	//input [31:0] VSrcB [0:4];
	input wire [31:0] rd6;
	input wire [31:0] rd7;
	input wire [31:0] rd8;
	input wire [31:0] rd9;
	input wire [31:0] rd10;

	input [2:0] ALUControl;
	input wire vector_op;
	input wire [1:0] Op;
	output reg [31:0] VALUResultA;
	output reg [31:0] VALUResultB;
	output reg [31:0] VALUResultC;
	output reg [31:0] VALUResultD;
	output reg [31:0] VALUResultE;

	wire [31:0] ov1, ov2, ov3, ov4, ov5;
	wire [31:0] condinvb[0:4];
	wire [32:0] sum [0:4];
	reg [31:0] vector_result [0:4];

	assign condinvb[0] = ALUControl[0] ? ~rd6 : rd6;
	assign condinvb[1] = ALUControl[0] ? ~rd7 : rd7;
	assign condinvb[2] = ALUControl[0] ? ~rd8 : rd8;
	assign condinvb[3] = ALUControl[0] ? ~rd9 : rd9;
	assign condinvb[4] = ALUControl[0] ? ~rd10 : rd10;
	assign sum[0] = rd1 + condinvb[0] + ALUControl[0];
	assign sum[1] = rd2 + condinvb[1] + ALUControl[0];
	assign sum[2] = rd3 + condinvb[2] + ALUControl[0];
	assign sum[3] = rd4 + condinvb[3] + ALUControl[0];
	assign sum[4] = rd5 + condinvb[4] + ALUControl[0];
	
	wire [31:0] mul1res, mul2res, mul3res, mul4res, mul5res;
    
    mult mul1(.a(rd1), .b(rd6), .result(mul1res), .overflow(ov1));
    mult mul2(.a(rd2), .b(rd7), .result(mul2res), .overflow(ov2));
    mult mul3(.a(rd3), .b(rd8), .result(mul3res), .overflow(ov3));
    mult mul4(.a(rd4), .b(rd9), .result(mul4res), .overflow(ov4));
    mult mul5(.a(rd5), .b(rd10), .result(mul5res), .overflow(ov5));
    
	always @(*) begin
		if (vector_op) begin
			begin
				case (ALUControl)
					3'b000:  // VADD
					begin 
						VALUResultA = sum[0];
						VALUResultB = sum[1];
						VALUResultC = sum[2];
						VALUResultD = sum[3];
						VALUResultE = sum[4];
					end
					3'b001: // VSUB
					begin
						VALUResultA = sum[0];
						VALUResultB = sum[1];
						VALUResultC = sum[2];
						VALUResultD = sum[3];
						VALUResultE = sum[4];
					end
					3'b010: // VAND
					begin
						VALUResultA = rd1 & rd6;
						VALUResultB = rd2 & rd7;
						VALUResultC = rd3 & rd8;
						VALUResultD = rd4 & rd9;
						VALUResultE = rd5 & rd10;
					end
					3'b011: // VOR
					begin
						VALUResultA = rd1 | rd6;
						VALUResultB = rd2 | rd7;
						VALUResultC = rd3 | rd8;
						VALUResultD = rd4 | rd9;
						VALUResultE = rd5 | rd10;
					end
					3'b100: // VXOR
					begin
						VALUResultA = rd1 ^ rd6;
						VALUResultB = rd2 ^ rd7;
						VALUResultC = rd3 ^ rd8;
						VALUResultD = rd4 ^ rd9;
						VALUResultE = rd5 ^ rd10;
					end
					3'b110: // VMUL
                   			 begin
						VALUResultA = mul1res;
						VALUResultB = mul2res;
						VALUResultC = mul3res;
						VALUResultD = mul4res;
						VALUResultE = mul5res;
                    			end

				endcase
			end 
		end
		else
                begin
                VALUResultA = 32'bx;
                VALUResultB = 32'bx;
                VALUResultC = 32'bx;
                VALUResultD = 32'bx;
                VALUResultE = 32'bx;
                end
        
	end
endmodule

