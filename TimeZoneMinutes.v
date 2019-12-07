/** Time Zone Minutes Manager
 * 
 * Input: clk, KeyPlus, KeyMinus,
 *        reset, EditPos, EditMode, screen
 * Output: TZMinutes
 * 
 * Dependence: none
 * 
 * Function: Manage minutes of time zone
 * 
 * Description Input, Output:
 * 
 * - TZMinutes: perform minutes of time zone
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 */
module TimeZoneMinutes(TZMinutes, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[6:0] TZMinutes;
	input [2:0] EditPos;
	input EditMode, clk, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	reg [2:0] mode;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			TZMinutes <= 0;
			mode <= 0;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 2 && (EditPos == 4 || EditPos == 5)) begin
			if (EditPos == 5) mode <= 1;
			else if (EditPos == 4) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 2 && (EditPos == 4 || EditPos == 5)) begin
			if (EditPos == 5) mode <= 2;
			else if (EditPos == 4) mode <= 4;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			TZMinutes <= mode == 1? (TZMinutes % 10 == 9? TZMinutes - 7'd9: TZMinutes + 7'd1):
						mode == 2? (TZMinutes % 10 == 0? TZMinutes + 7'd9: TZMinutes - 7'd1):
						mode == 3? (TZMinutes >= 50? TZMinutes - 7'd50: TZMinutes + 7'd10):
						mode == 4? (TZMinutes < 10? TZMinutes + 7'd50: TZMinutes - 7'd10):
						TZMinutes;
		end
	end
	
endmodule
