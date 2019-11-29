/**
 * 
 */
module MiniProjectTopic2(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, CLOCK_50, KEY, SW);
	input CLOCK_50; // 1 Clock frequency 50_000_000 Hz
	input [17:0] SW; // 3 Switch to perform special function
	input [3:0] KEY; // 4 Push buttons to control the clock
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7; // Real 7-Segment
	output [2:0] LEDR; // 3 Leds to perform View Mode
	
	MainManager main(HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDR, CLOCK_50,
						KEY[0], KEY[1], KEY[2], KEY[3],
						SW[17], SW[16], SW[15], SW[14], SW[13], SW[12], SW[1], SW[0]);
endmodule
