/** Days Manager
 * 
 * Input: EditPos, reset, screen, HourOverPlus, HourOverMinus,
 *        ClkDay, clk, KeyPlus, KeyMinus,
 *        month
 * Output: days, ClkMonth, MonthOverPlus, MonthOverMinus
 * 
 * Dependence: none
 * 
 * Function: Manage days of project
 * 
 * Description Input, Output:
 * 
 * - days: perform days of project
 * - ClkLeap: the clock perform the year is leap or not, it is leap when high
 * - MonthOverPlus, MonthOverMinus: the signal to plus, minus month when in Time Zone Mode
 * - ClkMonth: the clock for months counter
 * - ClkDay: the clock for days counter
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - DayOverPlus, DayOverMinus: the signal to plus, minus day when in Time Zone Mode
 * - months: perform months of project
 */
module DayCounter(days, ClkLeap, MonthOverPlus, MonthOverMinus,
						ClkMonth, ClkDay, clk, KeyPlus, KeyMinus, reset,
						EditPos, EditMode, screen, DayOverPlus, DayOverMinus,
						months);
	output reg[6:0] days;
	output ClkMonth, MonthOverPlus, MonthOverMinus;
	input [6:0] months;
	input [2:0] EditPos;
	input clk, ClkDay, ClkLeap,
			KeyPlus, KeyMinus, reset,
			EditMode, DayOverPlus, DayOverMinus;
	input [1:0] screen;
	
	reg [3:0] mode, mode2;
	
	assign ClkMonth = EditMode == 1? ClkMonth:
				(months == 2? (ClkLeap == 1? (days == 29? 1'b1: 1'b0): (days == 28? 1'b1: 1'b0)):
				((months == 4 || months == 6 || months == 9 || months == 11)? (days == 30? 1'b1: 1'b0):
				(days == 31? 1'b1: 1'b0)));
	assign MonthOverPlus = ((mode2 == 1 && months == 2 && ClkLeap == 1 && days == 29) ||
									(mode2 == 1 && months == 2 && ClkLeap == 0 && days == 28) ||
									(mode2 == 1 && (months == 4 || months == 6 || months == 9 || months == 11) && days == 30) ||
									(mode2 == 1 && (months == 1 || months == 3 || months == 5 || months == 7 ||
														months == 8 || months == 10 || months == 12) && days == 31))? 1'b1: 1'b0;
	assign MonthOverMinus = (mode2 == 2 && days == 1)? 1'b1: 1'b0;
	
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			days <= 25;
			mode <= 0;
			mode2 <= 0;
		end
		else if(ClkDay && EditMode == 0) begin
			mode2 <= 0;
			mode <= 5;
		end
		else if(DayOverPlus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 1;
		end
		else if(DayOverMinus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 2;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 1 && (EditPos == 0 || EditPos == 1)) begin
			mode2 <= 0;
			if(EditPos == 0) begin
				if (months == 2) mode <= 3;
				else mode <= 9;
			end
			else if(EditPos == 1) begin
				if (days < 10) mode <= 11;
				else if (days < 30) mode <= 1;
				else if (months == 4 || months == 6 || months == 9 || months == 11) mode <= 6;
				else mode <= 7;
			end
			else mode <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 1 && (EditPos == 0 || EditPos == 1)) begin
			mode2 <= 0;
			if(EditPos == 0) begin
				if (months == 2) mode <= 4;
				else mode <= 10;
			end
			else if(EditPos == 1) begin
				if (days < 10) mode <= 12;
				else if (days < 30) mode <= 2;
				else if (months == 4 || months == 6 || months == 9 || months == 11) mode <= 6;
				else mode <= 8;
			end
			else mode <= 0;
		end
		else begin
			mode <= 0;
			mode2 <= 0;
			days <= mode == 5? (months == 2? (ClkLeap == 1? (days == 29? 7'd1: days + 7'd1): (days == 28? 7'd1: days + 7'd1)):
									((months == 4 || months == 6 || months == 9 || months == 11)? (days == 30? 7'd1: days + 7'd1):
									(days == 31? 7'd1: days + 7'd1))):
						mode == 1? (days % 10 == 9? days - 7'd9: days + 7'd1):
						mode == 2? (days % 10 == 0? days + 7'd9: days - 7'd1):
						mode == 3? (days >= 20? days - 7'd20: days + 7'd10):
						mode == 4? (days < 10? days + 7'd20: days - 7'd10):
						mode == 6? 7'd30:
						mode == 7? (days % 10 == 1? days - 7'd1: days + 7'd1):
						mode == 8? (days % 10 == 1? days + 7'd1: days - 7'd1):
						mode == 9? (days >= 30? days - 7'd30: days + 7'd10):
						mode == 10? (days < 10? days + 7'd30: days - 7'd10):
						mode == 11? (days == 9? 7'd1: days + 7'd1):
						mode == 12? (days == 1? 7'd9: days - 7'd1):
						mode2 == 1? (months == 2? (ClkLeap == 1? (days == 29? 7'd1: days + 7'd1): (days == 28? 7'd1: days + 7'd1)):
									((months == 4 || months == 6 || months == 9 || months == 11)? (days == 30? 7'd1: days + 7'd1):
									(days == 31? 7'd1: days + 7'd1))):
						mode2 == 2? (months == 3? (ClkLeap == 1? (days == 1? 7'd29: days - 7'd1): (days == 1? 7'd28: days - 7'd1)):
									((months == 5 || months == 7 || months == 10 || months == 12)? (days == 1? 7'd30: days - 7'd1):
									(days == 1? 7'd31: days - 7'd1))):
						(EditMode == 0)? (days == 0? 7'd1:
									(months == 2? (ClkLeap == 1? (days > 29? 7'd29: days): (days > 28? 7'd28: days)):
									((months == 4 || months == 6 || months == 9 || months == 11)? (days > 30? 7'd30: days):
									(days > 31? 7'd31: days)))):
									days;
		end
	end
	
endmodule
