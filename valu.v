module valu (
	VSrcA, VSrcB, ALUControl, VALUResult, ALUFlags, vector_op, Op, Funct, index
);
	input [31:0] VSrcA [0:4];
	input [31:0] VSrcB [0:4];
	input [2:0] ALUControl;
	input wire [2:0] index;
	input wire vector_op;
	input wire [1:0] Op;
	input wire [5:0] Funct;
	output reg [31:0] VALUResult[0:4];
	output wire [3:0] ALUFlags;

	wire neg, zero, carry, overflow;
	wire [31:0] condinvb[0:4];
	wire [32:0] sum [0:4];
	reg [31:0] vector_result [0:4];

	assign condinvb[0] = ALUControl[0] ? ~VSrcB[0] : VSrcB[0];
	assign condinvb[1] = ALUControl[0] ? ~VSrcB[1] : VSrcB[1];
	assign condinvb[2] = ALUControl[0] ? ~VSrcB[2] : VSrcB[2];
	assign condinvb[3] = ALUControl[0] ? ~VSrcB[3] : VSrcB[3];
	assign condinvb[4] = ALUControl[0] ? ~VSrcB[4] : VSrcB[4];
	assign sum[0] = VSrcA[0] + condinvb[0] + ALUControl[0];
	assign sum[1] = VSrcA[1] + condinvb[1] + ALUControl[0];
	assign sum[2] = VSrcA[2] + condinvb[2] + ALUControl[0];
	assign sum[3] = VSrcA[3] + condinvb[3] + ALUControl[0];
	assign sum[4] = VSrcA[4] + condinvb[4] + ALUControl[0];

    integer i;
	always @(*) begin
		if (vector_op) begin
			for (i = 0; i < index; i = i + 1) begin
				case (ALUControl)
					3'b000: VALUResult[i] = sum[i]; // VADD
					3'b001: VALUResult[i] = sum[i]; // VSUB
					3'b010: VALUResult[i] = VSrcA[i] & VSrcB[i]; // VAND
					3'b011: VALUResult[i] = VSrcA[i] | VSrcB[i]; // VOR
					3'b100: VALUResult[i] = VSrcA[i] ^ VSrcB[i]; // VXOR
					3'b110: mult(VSrcA[i], VSrcB[i], vector_result[i]); // VMUL
					default: VALUResult[i] = 32'b0;
				endcase
			end 
		end
		else begin
			case (ALUControl)
				3'b000: VALUResult = 32'bx;
				3'b001: VALUResult = 32'bx;
				3'b010: VALUResult = 32'bx;
				3'b011: VALUResult = 32'bx;
				default: VALUResult = 32'bx;
			endcase
		end
	end

	//assign neg = ALUResult[31];
	//assign zero = (ALUResult == 32'b0);
	//assign carry = ~ALUControl[1] & sum[32];
	//assign overflow = ~ALUControl[1] & ~(VSrcA[0][31] ^ VSrcB[0][31] ^ ALUControl[0]) & (VSrcA[0][31] ^ sum[31][0]);
	//assign ALUFlags = {neg, zero, carry, overflow};
endmodule
