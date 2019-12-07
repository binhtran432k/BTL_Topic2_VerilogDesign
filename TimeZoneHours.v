/** Time Zone Hours Manager
 * 
 * Input: clk, KeyPlus, KeyMinus,
 *        reset, EditPos, EditMode, screen, TZPlusMinus
 * Output: TZHours
 * 
 * Dependence: none
 * 
 * Function: Manage hours of time zone
 * 
 * Description Input, Output:
 * 
 * - TZHours: perform hours of time zone
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - TZPlusMinus: perform plus or minus of time zone, is plus when high
 */
module TimeZoneHours(TZHours, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen, TZPlusMinus);
	output reg[6:0] TZHours;
	input [2:0] EditPos;
	input EditMode, clk, KeyPlus, KeyMinus, reset, TZPlusMinus;
	input [1:0] screen;
	
	reg [2:0] mode;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			TZHours <= 7;
			mode <= 0;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 2 && EditPos == 2) begin
			if (TZPlusMinus == 1) mode <= 1;
			else mode <= 3;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 2 && EditPos == 2) begin
			if (TZPlusMinus == 1) mode <= 2;
			else mode <= 4;
		end
		else begin
			mode <= 0;
			TZHours <= mode == 1? (TZHours == 12? 7'd0: TZHours + 7'd1):
						mode == 2? (TZHours == 0? 7'd12: TZHours - 7'd1):
						mode == 3? (TZHours == 12? 7'd1: TZHours + 7'd1):
						mode == 4? (TZHours == 1? 7'd12: TZHours - 7'd1):
						(TZHours > 12 && EditMode == 0)? 7'd12: TZHours;
		end
		
	end
	
endmodule
