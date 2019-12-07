/** Reset Manager
 * 
 * Input: KeyEdit, clk
 * Output: reset
 * 
 * Dependence: none
 * 
 * Function: Manage reset of project
 * 
 * Description Input, Output:
 * 
 * - reset: to reset the project
 * - KeyEdit: switch between Edit Mode and Normal Mode
 * - clk: the main clock for flip-flop
 */
module ResetSignal(reset, KeyEdit, clk);
	output reset;
	input KeyEdit, clk;
	
	reg [31:0] count;
	reg [2:0] count2;
	reg reset = 0;
	
	always @(posedge clk) begin
		if (~KeyEdit) begin
			if (reset == 0) begin
				count <= 0;
				count2 <= 3;
			end
			else begin
				count <= 49_999_999? 0: count + 1;
				count2 <= (count < 49_999_999 || count2 == 3)? count2: count2 + 3'd1;
			end
		end
		else begin
			count <= 0;
			count2 <= 0;
			reset <= count2 == 3? reset + 1'b1: reset;
		end
	end
	
endmodule
