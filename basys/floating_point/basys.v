module basys(
    input clk,input reset,output[12:0] showbasys
);
    wire [31:0] WriteData;
	wire [31:0] Adr;
	wire MemWrite;
    wire nclk;
	clk_divider ck(clk,reset,nclk);
    top(nclk,reset,WriteData,Adr,MemWrite,showbasys);



endmodule