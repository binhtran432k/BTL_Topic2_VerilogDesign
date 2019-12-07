/** Clock 12 Converter
 * 
 * Input: hours
 * Output: hours12, DayNight
 * 
 * Dependence: none
 * 
 * Function: Convert from Clock 24h to Clock 12h
 * 
 * Description Input, Output:
 * 
 * - hours12: perform hours of clock 12h of project
 * - DayNight: perform the time is AM or PM
 * - hours: perform hours of project
 */
module Clk24toClk12(hours12, DayNight, hours);
	output [6:0] hours12, DayNight;
	input [6:0] hours;
	
	assign DayNight = (hours < 12)? 7'd10: 7'd11;
	assign hours12 = (hours > 12)? hours - 7'd12:
						(hours == 0)? 7'd12: hours;
	
endmodule
