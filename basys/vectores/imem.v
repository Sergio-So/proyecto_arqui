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
	   RAM[1] = 32'hF0813032;
	   RAM[2] = 32'hF0423021;
	   RAM[3] = 32'hF0013012;
	   RAM[4] = 32'hF1813042;
	   RAM[5] = 32'hF0213052;
	   RAM[6] = 32'hF1E13052;
	   RAM[7] = 32'hF0835034;
	   //RAM[8] = 32'hEC214002;
	   //RAM[9] = 32'hEC18A009;
	   //RAM[10] = 32'hEC38B009;
	end
endmodule