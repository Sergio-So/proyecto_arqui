module testbench;
	reg iclk;
	reg reset;
	reg clk_reset;
	wire [15:0] showbasys;
	//wire [31:0] WriteData;
	//wire [31:0] DataAdr;
	//wire MemWrite;
	//wire [31:0] showbasys;
	//wire payaso;
	
	basys1 test(
		.clk(iclk),
		.reset(reset),
		.clk_reset(clk_reset),
		.showbasys(showbasys)
	);
	initial begin
		reset <= 1;
		#(18)
			;
		reset <= 0;
	end
	always begin
		iclk <= 1;
		#(5)
			;
		iclk <= 0;
		#(5)
			;
	end
	initial begin
	#500
	$finish;
	end
	
endmodule