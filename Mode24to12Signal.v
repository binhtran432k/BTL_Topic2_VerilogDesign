/** Mode 12h or 24h Manager
 * 
 * Input: clk, screen, EditMode, reset,
 *       KeyPlus, KeyMinus
 * Output: Mode24t12
 * 
 * Dependence: none
 * 
 * Function: Manage the clock which is 12h or 24h
 * 
 * Description Input, Output:
 * 
 * - Mode24t12: perform he clock which is 12h or 24h, 12h when high
 * - clk: the main clock for flip-flop
 * - screen: perform the current screen
 * - EditMode: perform Edit Mode which is high or low
 * - reset: to reset the project
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 */
module Mode24to12Signal(Mode24t12,
						clk, screen, EditMode, reset,
						KeyPlus, KeyMinus);
	output reg Mode24t12;
	input [1:0] screen;
	input EditMode, reset, clk,
			KeyPlus, KeyMinus;
	
	reg [2:0] mode;
	
	always @(posedge clk, negedge reset) begin
		if (~reset) begin
			Mode24t12 <= 0;
			mode <= 0;
		end
		else if(~KeyPlus && EditMode == 1 && screen == 3) begin
			mode <= 1;
		end
		else if(~KeyMinus && EditMode == 1 && screen == 3) begin
			mode <= 1;
		end
		else begin
			mode <= 0;
			Mode24t12 <= mode == 1? Mode24t12 + 1'b1: Mode24t12;
		end
	end
	
endmodule
