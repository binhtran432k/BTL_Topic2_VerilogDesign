/** Time Zone Plus Minus Manager
 * 
 * Input: clk, KeyPlus, KeyMinus,
 *        reset, EditPos, EditMode, screen, TZHours
 * Output: TZPlusMinus
 * 
 * Dependence: none
 * 
 * Function: Manage plus or minus of time zone
 * 
 * Description Input, Output:
 * 
 * - TZPlusMinus: perform plus or minus of time zone, is plus when high
 * - clk: the main clock for flip-flop
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - reset: to reset the project
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - TZHours: perform hours of time zone
 */
module TimeZonePlusMinus(TZPlusMinus, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen, TZHours);
	output reg TZPlusMinus;
	input [2:0] EditPos;
	input EditMode, clk, KeyPlus, KeyMinus, reset;
	input [6:0] TZHours;
	input [1:0] screen;
	
	reg mode;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			TZPlusMinus <= 1;
			mode <= 0;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 2 && EditPos == 0) begin
			mode <= 1;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 2 && EditPos == 0) begin
			mode <= 1;
		end
		else begin
			mode <= 0;
			TZPlusMinus <= (mode == 1 && TZHours != 0)? TZPlusMinus + 1'b1:
								TZPlusMinus;
		end
		
	end
	
endmodule
