module extend (
	Instr,
	ImmSrc,
	ExtImm,
	float,
);
	input wire [23:0] Instr;
	input wire [1:0] ImmSrc;
	input wire float;
	output reg [31:0] ExtImm;
	always @(*)
		case (ImmSrc)
			 2'b00: if(float) begin
			         ExtImm = {24'b000000000000000000000000, Instr[7:0]};
			     end    
			     else begin
			         ExtImm = {24'b000000000000000000000000, Instr[7:0]};
			     end
			2'b01: ExtImm = {20'b00000000000000000000, Instr[11:0]};
			2'b10: ExtImm = {{6 {Instr[23]}}, Instr[23:0], 2'b00};
			default: ExtImm = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
		endcase
endmodule