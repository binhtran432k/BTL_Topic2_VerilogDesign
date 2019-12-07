/** Years Manager
 * 
 * Input: EditPos, reset, screen, YearOverPlus, YearOverMinus,
 *        ClkYear, clk, KeyPlus, KeyMinus
 * Output: years, ClkLeap
 * 
 * Dependence: none
 * 
 * Function: Manage years of project
 * 
 * Description Input, Output:
 * 
 * - years: perform years of project
 * - ClkLeap: the clock perform the year is leap or not, it is leap when high
 * - ClkYear: the clock for years counter
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - YearOverPlus, YearOverMinus: the signal to plus, minus year when in Time Zone Mode
 */
module YearCounter(years, ClkLeap,
						ClkYear, clk, KeyPlus, KeyMinus, reset,
						EditPos, EditMode, screen, YearOverPlus, YearOverMinus);
	output reg[14:0] years;
	output ClkLeap;
	input [2:0] EditPos;
	input clk, ClkYear,
			KeyPlus, KeyMinus, reset,
			EditMode, YearOverPlus, YearOverMinus;
	input [1:0] screen;
	
	reg [3:0] mode, mode2;
	
	assign ClkLeap = ((years % 4 == 0 && years % 100 != 0) || years % 400 == 0)? 1'b1: 1'b0; // Detech Leap Year
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			years <= 2019;
			mode <= 0;
			mode2 <= 0;
		end
		else if(ClkYear && EditMode == 0) begin
			mode2 <= 0;
			mode <= 9;
		end
		else if(YearOverPlus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 1;
		end
		else if(YearOverMinus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 2;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 1 && (EditPos == 4 || EditPos == 5 || EditPos == 6 || EditPos == 7)) begin
			mode2 <= 0;
			if (EditPos == 7) mode <= 1;
			else if (EditPos == 6) mode <= 3;
			else if (EditPos == 5) mode <= 5;
			else if (EditPos == 4) mode <= 7;
			else mode <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 1 && (EditPos == 4 || EditPos == 5 || EditPos == 6 || EditPos == 7)) begin
			mode2 <= 0;
			if (EditPos == 7) mode <= 2;
			else if (EditPos == 6) mode <= 4;
			else if (EditPos == 5) mode <= 6;
			else if (EditPos == 4) mode <= 8;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			mode2 <= 0;
			years <= mode == 9? (years == 9999? 15'd0: years + 15'd1):
						mode == 1? (years % 10 == 9? years - 15'd9: years + 15'd1):
						mode == 2? (years % 10 == 0? years + 15'd9: years - 15'd1):
						mode == 3? ((years / 10) % 10 == 9? years - 15'd90: years + 15'd10):
						mode == 4? ((years / 10) % 10 == 0? years + 15'd90: years - 15'd10):
						mode == 5? ((years / 100) % 10 == 9? years - 15'd900: years + 15'd100):
						mode == 6? ((years / 100) % 10 == 0? years + 15'd900: years - 15'd100):
						mode == 7? ((years / 1000) % 10 == 9? years - 15'd9000: years + 15'd1000):
						mode == 8? ((years / 1000) % 10 == 0? years + 15'd9000: years - 15'd1000):
						mode2 == 1? (years == 9999? 15'd0: years + 15'd1):
						mode2 == 2? (years == 0? 15'd9999: years - 15'd1):
						years;
		end
	end
	
endmodule
