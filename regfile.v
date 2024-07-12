module regfile (
	clk,
	we3,
	ra1,
	ra2,
	wa3,
	wd3,
	r15,
	vector_op,
	rd1,
	rd2,
	VsrcA,
	VsrcB,
	index
);
	input wire clk;
	input wire we3;
	input wire [3:0] ra1;
	input wire [3:0] ra2;
	input wire [3:0] wa3;
	input wire [31:0] wd3;
	input wire [31:0] r15;
	input wire [3:0] index;
	input wire vector_op; // Señal para operaciones vectoriales
	output wire [31:0] rd1;
	output wire [31:0] rd2;
	output wire [31:0] VsrcA [0:4];
	output wire [31:0] VsrcB [0:4];
	reg [31:0] rf [14:0]; // Arreglo de registros

	always @(posedge clk)
		if (we3) begin
			rf[wa3] <= wd3; // Escritura en el registro indicado por wa3
		end

	assign rd1 = (vector_op == 1'b0) ? (ra1 == 4'b1111 ? r15 : rf[ra1]) : 'bx;
	assign rd2 = (vector_op == 1'b0) ? (ra2 == 4'b1111 ? r15 : rf[ra2]) : 'bx;

	// Asignación de VsrcA y VsrcB para operaciones vectoriales
	integer i;
	always @(*) begin
		if (vector_op) begin
			for (i = 0; i < index; i = i + 1) begin
				VsrcA[i] = rf[ra1 + i];
				VsrcB[i] = rf[ra2 + i];
			end
		end else begin
			for (i = 0; i < index; i = i + 1) begin
				VsrcA[i] = 32'bx;
				VsrcB[i] = 32'bx;
			end
		end
	end
endmodule
