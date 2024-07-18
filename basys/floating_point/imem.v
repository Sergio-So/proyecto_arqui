module imem (
	a,
	rd
);
	input wire [31:0] a;
	output wire [31:0] rd;
	reg [31:0] RAM [0:63];
	initial $readmemh("memfile.dat", RAM);
	assign rd = RAM[a[31:2]];
	
	initial begin
	   RAM[0] = 32'hE04F000F;
	   RAM[1] = 32'hE2802005;
	   RAM[2] = 32'hE3A04078;
	   RAM[3] = 32'hE5941004;
	   RAM[4] = 32'hE5942000;
	   RAM[5] = 32'hE594800C;
	   RAM[6] = 32'hE5949008;
	   RAM[7] = 32'hEC013002;
	   RAM[8] = 32'hEC214002;
	   RAM[9] = 32'hEC18A009;
	   RAM[10] = 32'hEC38B009;
	end
endmodule