module loadlow ( a, b, rd); 
input wire [31:0] a; 
input wire [31:0] b; 
output reg [31:0] rd; 
wire [1:0] prueba; 

assign prueba = a[1:0]; 
always @(*) begin 
case(a[1:0]) 
2'b00: rd = b[7:0]; 
2'b01: rd = b[15:8]; 
2'b10: rd = b[23:16]; 
2'b11: rd = b[31:24]; 
endcase 
end 
endmodule