module FlickerCounter(clkFlick, Clk);
	input Clk;
	output reg clkFlick = 0;
	
	reg [25:0] count = 0;
	/*initial begin
		clkFlick <= 0;
		count <= 0;
	end*/
	always @(posedge Clk) begin
		clkFlick <= count == 4? clkFlick + 1: clkFlick; // Real count: 8_999_999
		count <= count == 4? 0: count + 1; // Real count: 8_999_999
	end
endmodule
