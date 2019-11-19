module Clk24toClk12(hours12, dayNight, hours24);
	output [5:0] hours12, dayNight;
	input [5:0] hours24;
	
	assign dayNight = (hours24 < 12)? 10: 11;
	assign hours12 = (hours24 > 12)? hours24 - 12:
						(hours24 == 0)? 12: hours24;
	
endmodule
