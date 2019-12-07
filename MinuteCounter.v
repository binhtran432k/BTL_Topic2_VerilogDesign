/** Minutes Manager
 * 
 * Input: EditPos, reset, screen, EditMode,
 *        ClkMinute, clk, KeyPlus, KeyMinus,
 *        TZMinutes
 * Output: minutes, ClkHour, HourOverPlus, HourOverMinus
 * 
 * Dependence: none
 * 
 * Function: Manage minutes of project
 * 
 * Description Input, Output:
 * 
 * - minutes: perform minutes of project
 * - ClkHour: the clock for hours counter
 * - HourOverPlus, HourOverMinus: the signal to plus, minus hour when in Time Zone Mode
 * - ClkMinute: the clock for minutes counter
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - TZMinutes: perform the minutes of time zone
 */
module MinuteCounter(minutes, ClkHour, HourOverPlus, HourOverMinus,
							ClkMinute, clk, KeyPlus, KeyMinus, reset,
							EditPos, EditMode, screen,
							TZMinutes);
	output reg[6:0] minutes;
	output ClkHour, HourOverMinus, HourOverPlus;
	input [2:0] EditPos;
	input EditMode, clk, ClkMinute, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	input [6:0] TZMinutes;
	
	reg [2:0] mode, mode2;
	
	assign ClkHour = EditMode == 1? ClkHour: minutes == 59? 1'b1: 1'b0;
	assign HourOverPlus = ((mode2 == 1 && minutes == 59 && TZMinutes % 10 != 9) ||
									(mode2 == 2 && minutes > 50 && TZMinutes % 10 == 0) ||
									(mode2 == 3 && minutes >= 50 && TZMinutes < 50) ||
									(mode2 == 4 && minutes >= 10 && TZMinutes < 10))? 1'b1: 1'b0;
	assign HourOverMinus = ((mode2 == 1 && minutes < 9 && TZMinutes % 10 == 9) ||
									(mode2 == 2 && minutes == 0 && TZMinutes % 10 != 0) ||
									(mode2 == 3 && minutes < 50 && TZMinutes >= 50) ||
									(mode2 == 4 && minutes < 10 && TZMinutes >= 10))? 1'b1: 1'b0;
	
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			minutes <= 0;
			mode <= 0;
			mode2 <= 0;
		end
		else if(ClkMinute && EditMode == 0) begin
			mode2 <= 0;
			mode <= 5;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 0 && (EditPos == 2 || EditPos == 3)) begin
			mode2 <= 0;
			if (EditPos == 3) mode <= 1;
			else if (EditPos == 2) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 2 && (EditPos == 4 || EditPos == 5)) begin
			mode <= 0;
			if (EditPos == 5) mode2 <= 1;
			else if (EditPos == 4) mode2 <= 3;
			else mode2 <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 0 && (EditPos == 2 || EditPos == 3)) begin
			mode2 <= 0;
			if (EditPos == 3) mode <= 2;
			else if (EditPos == 2) mode <= 4;
			else mode <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 2 && (EditPos == 4 || EditPos == 5)) begin
			mode <= 0;
			if (EditPos == 5) mode2 <= 2;
			else if (EditPos == 4) mode2 <= 4;
			else mode2 <= 0;
		end
		else begin
			mode <= 0;
			mode2 <= 0;
			minutes <= mode == 5? (minutes == 59? 7'd0: minutes + 7'd1):
						mode == 1? (minutes % 10 == 9? minutes - 7'd9: minutes + 7'd1):
						mode == 2? (minutes % 10 == 0? minutes + 7'd9: minutes - 7'd1):
						mode == 3? (minutes >= 50? minutes - 7'd50: minutes + 7'd10):
						mode == 4? (minutes < 10? minutes + 7'd50: minutes - 7'd10):
						mode2 == 1? (TZMinutes % 10 == 9? (minutes < 9? minutes + 7'd51: minutes - 7'd9): (minutes == 59? 7'd0: minutes + 7'd1)):
						mode2 == 2? (TZMinutes % 10 == 0? (minutes > 50? minutes - 7'd51: minutes + 7'd9): (minutes == 0? 7'd59: minutes - 7'd1)):
						mode2 == 3? (TZMinutes >= 50? (minutes < 50? minutes + 7'd10: minutes - 7'd50): (minutes >= 50? minutes - 7'd50: minutes + 7'd10)):
						mode2 == 4? (TZMinutes < 10? (minutes >= 10? minutes - 7'd10: minutes + 7'd50): (minutes < 10? minutes + 7'd50: minutes - 7'd10)):
						minutes;
		end
	end
	
endmodule
