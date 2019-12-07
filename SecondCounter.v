/** Seconds Manager
 * 
 * Input: EditPos, reset, screen,
 *        clk, KeyPlus, KeyMinus,
 *        DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears
 * Output: seconds, ClkMinute
 * 
 * Dependence: none
 * 
 * Function: Manage seconds of project
 * 
 * Description Input, Output:
 * 
 * - seconds: perform seconds of project
 * - ClkMinute: the clock for minutes counter
 * - clk: the main clock for flip-flop
 * - DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears: use for debug time working
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 */
module SecondCounter(seconds, ClkMinute, clk,
							DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears,
							KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[6:0] seconds;
	output ClkMinute;
	input [2:0] EditPos;
	input DebugMinutes, DebugHours, DebugDays, DebugMonths, DebugYears,
			clk, EditMode, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	assign ClkMinute = EditMode == 1? ClkMinute: seconds == 59? 1'b1: 1'b0;
	
	reg[31:0] count;
	reg[2:0] mode;
	
	localparam [31:0] RealTime = 32'd49_999_999,
							DebugTimeMinutes = 32'd833_333,
							DebugTimeHours = 32'd13_888,
							DebugTimeDays = 32'd578,
							DebugTimeMonths = 32'd19,
							DebugTimeYears = 32'd1;
	
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			count <= 0;
			seconds <= 0;
			mode <= 0;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 0 && (EditPos == 4 || EditPos == 5)) begin
			if(EditPos == 5) mode <= 1;
			else if(EditPos == 4 && screen == 0 && EditMode == 1) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 0 && (EditPos == 4 || EditPos == 5)) begin
			if(EditPos == 5) mode <= 2;
			else if(EditPos == 4) mode <= 4;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			if (EditMode == 0) begin
				if(DebugYears == 1) begin
					seconds <= count == DebugTimeYears? (seconds == 59? 7'd0: seconds + 7'd1): seconds;
					count <= count >= DebugTimeYears? 0: count + 1;
				end
				else if(DebugMonths == 1) begin
					seconds <= count == DebugTimeMonths? (seconds == 59? 7'd0: seconds + 7'd1): seconds;
					count <= count >= DebugTimeMonths? 0: count + 1;
				end
				else if(DebugDays == 1) begin
					seconds <= count == DebugTimeDays? (seconds == 59? 7'd0: seconds + 7'd1): seconds;
					count <= count >= DebugTimeDays? 0: count + 1;
				end
				else if(DebugHours == 1) begin
					seconds <= count == DebugTimeHours? (seconds == 59? 7'd0: seconds + 7'd1): seconds;
					count <= count >= DebugTimeHours? 0: count + 1;
				end
				else if(DebugMinutes == 1) begin
					seconds <= count == DebugTimeMinutes? (seconds == 59? 7'd0: seconds + 7'd1): seconds;
					count <= count >= DebugTimeMinutes? 0: count + 1;
				end
				else begin
					seconds <= count == RealTime? (seconds == 59? 7'd0: seconds + 7'd1): seconds;
					count <= count >= RealTime? 0: count + 1;
				end
			end
			else begin
				count <= 0;
				seconds <= mode == 1? (seconds % 10 == 9? seconds - 7'd9: seconds + 7'd1):
							mode == 2? (seconds % 10 == 0? seconds + 7'd9: seconds - 7'd1):
							mode == 3? (seconds >= 50? seconds - 7'd50: seconds + 7'd10):
							mode == 4? (seconds < 10? seconds + 7'd50: seconds - 7'd10):
							seconds;
			end
		end
		
	end
		
endmodule
