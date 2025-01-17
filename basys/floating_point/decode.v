module decode (
	Op,
	Funct,
	Rd,
	FlagW,
	mov,
	PCS,
	RegW,
	MemW,
	MemtoReg,
	ALUSrc,
	ImmSrc,
	RegSrc,
	ALUControl
);
	input wire [1:0] Op;
	input wire [5:0] Funct;
	input wire [3:0] Rd;
	output reg [1:0] FlagW;
	output reg mov;
	output wire PCS;
	output wire RegW;
	output wire MemW;
	output wire MemtoReg;
	output wire ALUSrc;
	output wire [1:0] ImmSrc;
	output wire [1:0] RegSrc;
	output reg [2:0] ALUControl;
	reg [9:0] controls;
	wire Branch;
	wire ALUOp;
	
	always @(*)
		casex (Op)
			2'b00:
				if (Funct[5])
					controls = 10'b0000101001;
				else
					controls = 10'b0000001001;
			2'b01:
				if (Funct[0])
					controls = 10'b0001111000;
				else
					controls = 10'b1001110100;
			2'b10: controls = 10'b0110100010;
			2'b11: controls = 10'b0000001001;
			default: controls = 10'bxxxxxxxxxx;
		endcase
	assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp} = controls;
	always @(*)
		if (ALUOp) begin
		  if(Funct[5:4] == 2'b00 & Funct[3:1] == 3'b00)begin
		      ALUControl = 3'b100;
		      mov = 0;
		      end
		else      
			case (Funct[4:1])
				4'b0100:begin
				    ALUControl = 3'b000;
				    mov = 0;
				    end
				4'b0010:begin
				ALUControl = 3'b001;
				mov = 0;
				end
				4'b0000:begin
				ALUControl = 3'b010;
				mov = 0;
				end
				4'b1100:begin 
				ALUControl = 3'b011;
				mov = 0;
				end
				4'b1101:begin
				ALUControl = 3'b000;
				mov = 1;
				end
				default: ALUControl = 3'bxxx;
			endcase
			FlagW[1] = Funct[0];
			FlagW[0] = Funct[0] & ((ALUControl == 3'b000) | (ALUControl == 3'b001));
		end
		else begin
			ALUControl = 3'b000;
			FlagW = 2'b00;
		end
	assign PCS = ((Rd == 4'b1111) & RegW) | Branch;
endmodule