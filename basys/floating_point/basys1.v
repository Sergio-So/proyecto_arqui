module basys1(
    input iclk,input reset,input clk_reset,output[14:0] showbasys,output nclk);
    wire [31:0] WriteData;
	wire [31:0] Adr;
	wire MemWrite;
	wire nclk_wire;
	wire [15:0] showbasys_wire;
	clk_divider ck(iclk,clk_reset,nclk_wire);
    top t1(nclk_wire,reset,WriteData,Adr,MemWrite,showbasys_wire);
    assign nclk = nclk_wire;
    assign showbasys = showbasys_wire[14:0];
//output [6:0] seg,output [3:0] an

    //display d1(
    //    .clk(clk),
    //    .reset(reset),
    //    .data(showbasys),
    //    .seg(seg),
    //    .an(an)
    //);

endmodule