/** Basic Signal Manager
 * 
 * Input: Mode12t24, SwiReverse, KeyPlus, KeyMinus, KeyEdit, KeySwi, clk, reset
 * Output: EditMode, screen, EditPos
 * 
 * Dependence: none
 * 
 * Function: Manage basic signals of project
 * 
 * Description Input, Output:
 * 
 * - EditMode: perform Edit Mode which is high or low
 * - screen: perform the current screen
 * - EditPos: the current position of hex. This is opposite with hex which is 0 in the leftmost while it is 7
 * - KeyPlus, KeyMinus: plus, minus 1 unit of current position when in Edit Mode
 * - KeyEdit: switch between Edit Mode and Normal Mode
 * - KeySwi: switch to next position (from left to
 *           right) when user is in Edit Mode
 * - Mode24t12: perform he clock which is 12h or 24h, 12h when high
 * - SwiReverse: perform switch is reversed, reverse when high
 * - clk: the main clock for flip-flop
 * - reset: to reset the project
 */
module KeysManage(EditMode, screen, EditPos, KeyPlus, KeyMinus, KeyEdit, KeySwi, Mode12t24, SwiReverse, clk, reset);
	output reg EditMode;
	output reg[1:0] screen;
	output reg [2:0] EditPos;
	input Mode12t24, SwiReverse, KeyPlus, KeyMinus, KeyEdit, KeySwi, clk, reset;
	
	reg [3:0] mode;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			screen <= 0;
			EditMode <= 0;
			EditPos <= 0;
			mode <= 0;
		end
		else if(~KeyEdit) begin
			mode <= 7;
		end
		else if(~KeySwi) begin
			if (EditMode == 1 && screen == 0) begin
				if (Mode12t24 == 0) begin
					if (SwiReverse == 0) mode <= 1;
					else mode <= 2;
				end
				else begin
					if (SwiReverse == 0) mode <= 3;
					else mode <= 4;
				end
			end
			else if (EditMode == 1 && screen == 1) begin
				if (SwiReverse == 0) mode <= 8;
				else mode <= 9;
			end
			else if (EditMode == 1 && screen == 2) begin
				if (SwiReverse == 0) mode <= 10;
				else mode <= 11;
			end
			else mode <= 0;
			
		end
		else if(~KeyPlus) begin
			if (EditMode == 0) mode <= 5;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (EditMode == 0) mode <= 6;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			case(mode)
			1: EditPos <= EditPos == 5? 3'd0: EditPos + 3'd1;
			2: EditPos <= EditPos == 0? 3'd5: EditPos - 3'd1;
			3: EditPos <= (EditPos == 5 || EditPos == 0)? EditPos + 3'd2: EditPos + 3'd1;
			4: EditPos <= (EditPos == 7 || EditPos == 2)? EditPos - 3'd2: EditPos - 3'd1;
			5: screen <= screen + 2'd1;
			6: screen <= screen - 2'd1;
			7: EditMode <= EditMode + 1'b1;
			8: EditPos <= EditPos == 2? 3'd4: EditPos + 3'd1;
			9: EditPos <= EditPos == 4? 3'd2: EditPos - 3'd1;
			10: EditPos <= EditPos == 5? 3'd0: (EditPos == 0 || EditPos == 2)? EditPos + 3'd2: EditPos + 3'd1;
			11: EditPos <= EditPos == 0? 3'd5: (EditPos == 2 || EditPos == 4)? EditPos - 3'd2: EditPos - 3'd1;
			default: EditPos <= EditPos;
			endcase
		end
	end
	
endmodule
