/** Months Manager
 * 
 * Input: EditPos, reset, screen, MonthOverPlus, MonthOverMinus,
 *        ClkMonth, clk, KeyPlus, KeyMinus
 * Output: months, ClkYear, YearOverPlus, YearOverMinus
 * 
 * Dependence: none
 * 
 * Function: Manage months of project
 * 
 * Description Input, Output:
 * 
 * - months: perform months of project
 * - ClkYear: the clock for years counter
 * - YearOverPlus, YearOverMinus: the signal to plus, minus year when in Time Zone Mode
 * - ClkMonth: the clock for months counter
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - MonthOverPlus, MonthOverMinus: the signal to plus, minus month when in Time Zone Mode
 */
module MonthCounter(months, ClkYear, YearOverPlus, YearOverMinus,
						ClkMonth, clk, KeyPlus, KeyMinus, reset,
						EditPos, EditMode, screen, MonthOverPlus, MonthOverMinus);
	output reg[6:0] months;
	output ClkYear, YearOverPlus, YearOverMinus;
	input [2:0] EditPos;
	input clk, ClkMonth,
			KeyPlus, KeyMinus, reset,
			EditMode, MonthOverPlus, MonthOverMinus;
	input [1:0] screen;
	
	reg [2:0] mode, mode2;
	
	assign ClkYear = EditMode == 1? ClkYear: months == 12? 1'b1: 1'b0;
	assign YearOverPlus = (mode2 == 2 && months == 12)? 1'b1: 1'b0;
	assign YearOverMinus = (mode2 == 2 && months == 1)? 1'b1: 1'b0;

	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			months <= 11;
			mode <= 0;
			mode2 <= 0;
		end
		else if(ClkMonth && EditMode == 0) begin
			mode2 <= 0;
			mode <= 5;
		end
		else if(MonthOverPlus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 1;
		end
		else if(MonthOverMinus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 2;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 1 && EditPos == 2) begin
			mode <= 1;
			mode2 <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 1 && EditPos == 2) begin
			mode <= 2;
			mode2 <= 0;
		end
		else begin
			mode <= 0;
			mode2 <= 0;
			months <= mode == 5? (months == 12? 7'd1: months + 7'd1):
						mode == 1? (months == 12? 7'd1: months + 7'd1):
						mode == 2? (months == 1? 7'd12: months - 7'd1):
						mode2 == 1? (months == 12? 7'd1: months + 7'd1):
						mode2 == 2? (months == 1? 7'd12: months - 7'd1):
						(months > 12 && EditMode == 0)? 7'd12: months;
		end
	end
	
endmodule
