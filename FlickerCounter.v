module FlickerCounter(clkFlick, Clk, reset);
	input Clk, reset;
	output reg clkFlick;
	
	reg [25:0] count;
	always @(posedge Clk, negedge reset) begin
		if(~reset) begin
			clkFlick <= 0;
			count <= 0;
		end
		else begin
			clkFlick <= count == 9_999_999? clkFlick + 1: clkFlick; // Real count: 9_999_999
			count <= count == 9_999_999? 0: count + 1; // Real count: 9_999_999
		end
	end
endmodule
