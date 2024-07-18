module alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags,Op,Funct);
  input [31:0] SrcA;
  input [31:0] SrcB;
  input [2:0] ALUControl;
  input wire [1:0] Op;
  input wire [5:0] Funct;
    
  output reg [31:0] ALUResult;
  output wire [3:0] ALUFlags;

  wire neg, zero, carry, overflow;
  wire [31:0] condinvb;
  wire [32:0] sum;
  
  wire [31:0] fadd;
  wire [31:0] fmul;
    
  assign condinvb = ALUControl[0]? ~SrcB : SrcB;
  assign sum = SrcA + condinvb + ALUControl[0];
  
  floating_point_adder f1(.a(SrcA),.b(SrcB),.selector(Funct[0]),.sum(fadd));
  floating_point_multiplier m1(.a(SrcA),.b(SrcB),.selector(Funct[0]),.product(fmul));
  
  always @(*)
      begin
        if(Op == 2'b11)
            begin
                if(Funct[4:1] == 4'b0000)begin
                    ALUResult = fadd;
                end
                else begin
                    ALUResult = fmul;
                end
            end
        else begin
          case(ALUControl[2:0])
              3'b000: ALUResult =  sum;  
              3'b001: ALUResult =  sum;  
              3'b010: ALUResult = SrcA & SrcB;
              3'b011: ALUResult = SrcA | SrcB;
              3'b100: ALUResult = SrcA * SrcB;
              endcase        
      end
  end
   

  assign neg = ALUResult[31];
  assign zero = (ALUResult == 32'b0);
  assign carry = ~ALUControl[1] & sum[32];
  assign overflow = ~ALUControl[1] & ~(SrcA[31] ^ SrcB[31] ^ ALUControl[0]) & (SrcA[31] ^ sum[31]);
 
  assign ALUFlags = {neg, zero, carry, overflow};
endmodule