/** Hours Manager
 * 
 * Input: EditPos, reset, screen, HourOverPlus, HourOverMinus, Mode24t12
 *        ClkHour, clk, KeyPlus, KeyMinus,
 *        TZPlusMinus, TZHours
 * Output: hours, ClkDay, DayOverPlus, DayOverMinus
 * 
 * Dependence: none
 * 
 * Function: Manage hours of project
 * 
 * Description Input, Output:
 * 
 * - hours: perform hours of project
 * - ClkDay: the clock for days counter
 * - DayOverPlus, DayOverMinus: the signal to plus, minus day when in Time Zone Mode
 * - ClkHour: the clock for hours counter
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - Mode24t12: perform the digital clock are in 12h or 24h, it is high when in 12h
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - HourOverPlus, HourOverMinus: the signal to plus, minus hour when in Time Zone Mode
 * - TZPlusMinus: perform the plus or minus of time zone
 * - TZHours: perform the hours of time zone
 */
module HourCounter(hours, ClkDay, DayOverPlus, DayOverMinus,
						ClkHour, clk, KeyPlus, KeyMinus, reset,
						Mode24t12, EditPos, EditMode, screen, HourOverPlus, HourOverMinus,
						TZPlusMinus, TZHours);
	output reg[6:0] hours;
	output ClkDay, DayOverPlus, DayOverMinus;
	input [2:0] EditPos;
	input [6:0] TZHours;
	input clk, ClkHour,
			KeyPlus, KeyMinus, reset,
			EditMode, Mode24t12, HourOverPlus, HourOverMinus,
			TZPlusMinus;
	input [1:0] screen;
	
	reg [3:0] mode, mode2;
	
	assign ClkDay = EditMode == 1? ClkDay:  hours == 23? 1'b1: 1'b0;
	assign DayOverPlus = ((mode2 == 1 && hours == 23 && TZHours != 12) ||
									(mode2 == 2 && hours >= 12 && TZHours == 0) ||
									(mode2 == 3 && hours == 23 && TZHours != 12) ||
									(mode2 == 4 && hours >= 13 && TZHours == 1) ||
									(mode2 == 5 && hours >= 24 - TZHours * 2 && TZPlusMinus == 0) ||
									(mode2 == 6 && hours == 23))? 1'b1: 1'b0;
	assign DayOverMinus = ((mode2 == 1 && hours < 12 && TZHours == 12) ||
									(mode2 == 2 && hours == 0 && TZHours != 0) ||
									(mode2 == 3 && hours < 11 && TZHours == 12) ||
									(mode2 == 4 && hours == 0 && TZHours != 1) ||
									(mode2 == 5 && hours < TZHours * 2 && TZPlusMinus == 1) ||
									(mode2 == 7 && hours == 0))? 1'b1: 1'b0;

	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			hours <= 0;
			mode <= 0;
			mode2 <= 0;
		end
		else if(ClkHour && EditMode == 0) begin
			mode2 <= 0;
			mode <= 12;
		end
		else if(HourOverPlus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 6;
		end
		else if(HourOverMinus && EditMode == 1) begin
			mode <= 0;
			mode2 <= 7;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 2 && EditPos == 2) begin
			mode <= 0;
			if (TZPlusMinus == 1) mode2 <= 1;
			else mode2 <= 3;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 2 && EditPos == 2) begin
			mode <= 0;
			if (TZPlusMinus == 1) mode2 <= 2;
			else mode2 <= 4;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 2 && EditPos == 0) begin
			mode <= 0;
			mode2 <= 5;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 2 && EditPos == 0) begin
			mode <= 0;
			mode2 <= 5;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 0 && (EditPos == 0 || EditPos == 1 || EditPos == 7)) begin
			mode2 <= 0;
			if(EditPos == 0) begin
				if (Mode24t12 == 0) mode <= 5;
				else if (Mode24t12 == 1 && hours < 12) mode <= 8;
				else if (Mode24t12 == 1 && hours >= 12) mode <= 10;	
				else mode <= 0;
			end
			else if(EditPos == 1) begin
				if (Mode24t12 == 0 && hours < 20) mode <= 1;
				else if (Mode24t12 == 0 && hours >= 20) mode <= 3;
				else mode <= 0;
			end
			else if(EditPos == 7) begin
				if (Mode24t12 == 1) mode <= 7;
				else mode <= 0;
			end
			else mode <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 0 && (EditPos == 0 || EditPos == 1 || EditPos == 7)) begin
			mode2 <= 0;
			if(EditPos == 0) begin
				if (Mode24t12 == 0) mode <= 6;
				else if (Mode24t12 == 1 && hours < 12) mode <= 9;
				else if (Mode24t12 == 1 && hours >= 12) mode <= 11;	
				else mode <= 0;
			end
			else if(EditPos == 1) begin
				if (Mode24t12 == 0 && hours < 20) mode <= 2;
				else if (Mode24t12 == 0 && hours >= 20) mode <= 4;
				else mode <= 0;
			end
			else if(EditPos == 7) begin
				if (Mode24t12 == 1) mode <= 7;
				else mode <= 0;
			end
			else mode <= 0;
		end
		else begin
			mode <= 0;
			mode2 <= 0;
			hours <= mode == 12? (hours > 23? 7'd23: hours == 23? 7'd0: hours + 7'd1):
						mode == 1? (hours % 10 == 9? hours - 7'd9: hours + 7'd1):
						mode == 2? (hours % 10 == 0? hours + 7'd9: hours - 7'd1):
						mode == 3? (hours % 10 == 3? hours - 7'd3: hours + 7'd1):
						mode == 4? (hours % 10 == 0? hours + 7'd3: hours - 7'd1):
						mode == 5? (hours >= 20? hours - 7'd20: hours + 7'd10):
						mode == 6? (hours < 10? hours + 7'd20: hours - 7'd10):
						mode == 7? (hours < 12? hours + 7'd12: hours - 7'd12):
						mode == 8? (hours == 11? hours - 7'd11: hours + 7'd1):
						mode == 9? (hours == 0? hours + 7'd11: hours - 7'd1):
						mode == 10? (hours == 23? hours - 7'd11: hours + 7'd1):
						mode == 11? (hours == 12? hours + 7'd11: hours - 7'd1):
						mode2 == 1? (TZHours == 12? (hours < 12? hours + 7'd12: hours - 7'd12): (hours == 23? 7'd0: hours + 7'd1)):
						mode2 == 2? (TZHours == 0? (hours >= 12? hours - 7'd12: hours + 7'd12): (hours == 0? 7'd23: hours - 7'd1)):
						mode2 == 3? (TZHours == 12? (hours < 11? hours + 7'd13: hours - 7'd11): (hours == 23? 7'd0: hours + 7'd1)):
						mode2 == 4? (TZHours == 1? (hours >= 13? hours - 7'd13: hours + 7'd11): (hours == 0? 7'd23: hours - 7'd1)):
						mode2 == 5? (TZPlusMinus == 0? (hours >= (7'd24 - TZHours * 7'd2)? (hours + TZHours * 7'd2 - 7'd24): hours + TZHours * 7'd2):
										(hours < TZHours * 2? (hours + 7'd24 - TZHours * 7'd2): (hours - TZHours * 7'd2))):
						mode2 == 6? hours == 23? 7'd0: hours + 7'd1:
						mode2 == 7? hours == 0? 7'd23: hours - 7'd1:
						(hours > 23 && EditMode == 0)? 7'd23: hours;
		end
		
	end
	
endmodule
