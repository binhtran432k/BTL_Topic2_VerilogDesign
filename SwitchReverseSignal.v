/** Switch Reverse Manager
 * 
 * Input: KeySwi, clk, EditMode, reset
 * Output: SwiReverse
 * 
 * Dependence: none
 * 
 * Function: Manage switch reverse signal of project
 * 
 * Description Input, Output:
 * 
 * - SwiReverse: perform switch is reversed, reverse when high
 * - KeySwi: switch to next position (from left to
 *           right) when user is in Edit Mode
 * - clk: the main clock for flip-flop
 * - EditMode: perform Edit Mode which is high or low
 * - reset: to reset the project
 */
module SwitchReverseSignal(SwiReverse, KeySwi, clk, EditMode, reset);
	output reg SwiReverse;
	input KeySwi, clk, EditMode, reset;
	
	reg [31:0] count;
	reg [2:0] count2;
	
	always @(posedge clk, negedge KeySwi, negedge reset) begin
		if (~reset) begin
			count <= 0;
			count2 <= 0;
			SwiReverse <= 0;
		end
		else if (~KeySwi) begin
			if (EditMode == 0) begin
				count <= 0;
				count2 <= 0;
			end
			else begin
				count <= 49_999_999? 0: count + 1;
				count2 <= (count < 49_999_999 || count2 == 2)? count2: count2 + 3'd1;
			end
		end
		else begin
			count <= 0;
			count2 <= 0;
			SwiReverse <= count2 == 2? SwiReverse + 1'b1: SwiReverse;
		end
	end
	
endmodule
