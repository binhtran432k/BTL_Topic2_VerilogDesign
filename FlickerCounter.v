/** Flicker Effect Clock
 * 
 * Input: clk, reset
 * Output: ClkFlick
 * 
 * Dependence: none
 * 
 * Function: create clock for flicker effect of project
 * 
 * Description Input, Output:
 * 
 * - ClkFlick: the clock equal 1/10 second for flicker effect
 * - clk: the main clock for flip-flop
 * - reset: to reset the project
 */
module FlickerCounter(ClkFlick, clk, reset);
	input clk, reset;
	output reg ClkFlick;
	
	reg [31:0] count;
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			ClkFlick <= 0;
			count <= 0;
		end
		else begin
			ClkFlick <= count == 9_999_999? ClkFlick + 1'b1: ClkFlick;
			count <= count == 9_999_999? 32'd0: count + 32'd1;
		end
	end
endmodule
