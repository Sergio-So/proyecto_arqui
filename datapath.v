module datapath (
	clk,
	reset,
	RegSrc,
	RegWrite,
	ImmSrc,
	ALUSrc,
	ALUControl,
	MemtoReg,
	PCSrc,
	mov,
	ALUFlags,
	PC,
	Instr,
	ALUResult,
	WriteData,
	ReadData
);
	input wire clk;
	input wire reset;
	input wire [1:0] RegSrc;
	input wire RegWrite;
	input wire [1:0] ImmSrc;
	input wire ALUSrc;
	input wire [2:0] ALUControl;
	input wire MemtoReg;
	input wire PCSrc;
	input wire mov;

	output wire [3:0] ALUFlags;
	output wire [31:0] PC;
	input wire [31:0] Instr;
	output wire [31:0] ALUResult;
	output wire [31:0] WriteData;
	input wire [31:0] ReadData;
	wire [31:0] PCNext;
	wire [31:0] PCPlus4;
	wire [31:0] PCPlus8;
	wire [31:0] ExtImm;
	wire [31:0] SrcA;
	wire [31:0] SrcB;
	wire [31:0] Result;
	wire [3:0] RA1;
	wire [3:0] RA2;
	wire [31:0] toalu;
	wire [1:0] a;
	wire [5:0] b;
	wire vector_op;
	wire vwe3;
	wire vector_size;
	wire [31:0] VALUResultA,VALUResultB, VALUResultC, VALUResultD, VALUResultE;
	wire [31:0] rd1, rd2, rd3, rd4, rd5, rd6, rd7, rd8, rd9, rd10;
	wire [3:0] VALUFlags;

	assign a = Instr[27:26];
	assign b = Instr[25:20];
	assign vector_op = (Instr[31:28] == 4'b1111);
	assign vwe3 = (vector_op & RegWrite);
	assign vector_size = Instr[6:4];
	
	mux2 #(32) pcmux(
		.d0(PCPlus4),
		.d1(Result),
		.s(PCSrc),
		.y(PCNext)
	);
	flopr #(32) pcreg(
		.clk(clk),
		.reset(reset),
		.d(PCNext),
		.q(PC)
	);
	adder #(32) pcadd1(
		.a(PC),
		.b(32'b100),
		.y(PCPlus4)
	);
	adder #(32) pcadd2(
		.a(PCPlus4),
		.b(32'b100),
		.y(PCPlus8)
	);
	mux2 #(4) ra1mux(
		.d0(Instr[19:16]),
		.d1(4'b1111),
		.s(RegSrc[0]),
		.y(RA1)
	);
	mux2 #(4) ra2mux(
		.d0(Instr[3:0]),
		.d1(Instr[15:12]),
		.s(RegSrc[1]),
		.y(RA2)
	);
	regfile rf(
		.clk(clk),
		.we3(RegWrite),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(Instr[15:12]),
		.wd3(Result),
		.r15(PCPlus8),
		.rd1(SrcA),
		.rd2(WriteData)
	);

	vregfile vrf(
		.clk(clk),
		.we3(vwe3),
		.vector_op(vector_op),
		.vector_size(vector_size),
		.ra1(RA1),
		.ra2(RA2),
		.wa3(Instr[15:12]),
		.wd1(VALUResultA),
		.wd2(VALUResultB),
		.wd3(VALUResultC),
		.wd4(VALUResultD),
		.wd5(VALUResultE),
		.rd1(rd1),
		.rd2(rd2),
		.rd3(rd3),
		.rd4(rd4),
		.rd5(rd5),
		.rd6(rd6),
		.rd7(rd7),
		.rd8(rd8),
		.rd9(rd9),
		.rd10(rd10)
	);

	
	extend ext(
		.Instr(Instr[23:0]),
		.ImmSrc(ImmSrc),
		.ExtImm(ExtImm)
	);
	mux2 #(32) srcbmux(
		.d0(WriteData),
		.d1(ExtImm),
		.s(ALUSrc),
		.y(SrcB)
	);
	
	mux2 #(32) move(
	   .d0(SrcA),
	   .d1(32'b0),
	   .s(mov),
	   .y(toalu)
	);
	
	alu alu(
		.SrcA(toalu),
		.SrcB(SrcB),
		.ALUControl(ALUControl),
		.ALUResult(ALUResult),
		.ALUFlags(ALUFlags),
		.Op(a),
		.Funct(b)
	);

	valu valu(
		.RD1(rd1),
		.RD2(rd2),
		.RD3(rd3),
		.RD4(rd4),
		.RD5(rd5),
		.RD6(rd6),
		.RD7(rd7),
		.RD8(rd8),
		.RD9(rd9),
		.RD10(rd10),
		.ALUControl(ALUControl),
		.VALUResultA(VALUResultA),
		.VALUResultB(VALUResultB),
		.VALUResultC(VALUResultC),
		.VALUResultD(VALUResultD),
		.VALUResultE(VALUResultE),
		.ALUFlags(VALUFlags),
		.Op(a)
	);
	
	mux2 #(32) resmux(
		.d0(ALUResult),
		.d1(ReadData),
		.s(MemtoReg),
		.y(Result)
	);
endmodule
