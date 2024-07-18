module dmem (
	clk,
	we,
	a,
	wd,
	rd
);
	input wire clk;
	input wire we;
	input wire [31:0] a;
	input wire [31:0] wd;
	output wire [31:0] rd;
	reg [31:0] RAM [0:63];
	assign rd = RAM[a[31:2]];
	
	initial begin
	   RAM[30] = 32'H3FC00000;
	   RAM[31] = 32'H3F400000;
	   RAM[32] = 32'H00003A00;
	   RAM[33] = 32'H00003E00;
	   end
	
	always @(posedge clk)
		if (we)
			RAM[a[31:2]] <= wd;
endmodule