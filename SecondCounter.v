module SecondCounter(seconds, ClkMinute, clk, DebugMinutes, DebugHours, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[5:0] seconds;
	output ClkMinute;
	input [2:0] EditPos;
	input DebugMinutes, DebugHours, clk, EditMode, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	//wire ClkSecond;
	assign ClkMinute = EditMode == 1? ClkMinute: seconds == 59? 1: 0;
	
	reg[27:0] count; // For counter count to 67_108_864
	reg[2:0] mode;
	
	localparam [27:0] RealTime = 1, DebugTimeMinutes = 833_333, DebugTimeHours = 13_888; // Real Value: 49_999_999 - 833_333 - 13_888

	/*assign ClkSecond = EditMode == 1? ClkSecond:
								DebugHours == 1? (count == DebugTimeHours? 1: 0):
								DebugMinutes == 1? (count == DebugTimeMinutes? 1: 0):
								count == RealTime? 1: 0;*/
	
	always @(posedge clk, negedge KeyPlus, negedge KeyMinus, negedge reset) begin
		if(~reset) begin
			count <= 0;
			seconds <= 0;
			mode <= 0;
		end
		else if(~KeyPlus) begin
			if(EditPos == 5 && screen == 0 && EditMode == 1) mode <= 1;
			else if(EditPos == 4 && screen == 0 && EditMode == 1) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if(EditPos == 5 && screen == 0 && EditMode == 1) mode <= 2;
			else if(EditPos == 4 && screen == 0 && EditMode == 1) mode <= 4;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			if (EditMode == 0) begin
				if(DebugHours == 1) begin
					seconds <= count == DebugTimeHours? (seconds == 59? 0: seconds + 1): seconds;
					count <= count >= DebugTimeHours? 0: count + 1;
				end
				else if(DebugMinutes == 1) begin
					seconds <= count == DebugTimeMinutes? (seconds == 59? 0: seconds + 1): seconds;
					count <= count >= DebugTimeMinutes? 0: count + 1;
				end
				else begin
					seconds <= count == RealTime? (seconds == 59? 0: seconds + 1): seconds;
					count <= count >= RealTime? 0: count + 1;
				end
			end
			else begin
				count <= 0;
				seconds <= mode == 1? (seconds % 10 == 9? seconds - 9: seconds + 1):
							mode == 2? (seconds % 10 == 0? seconds + 9: seconds - 1):
							mode == 3? (seconds >= 50? seconds - 50: seconds + 10):
							mode == 4? (seconds < 10? seconds + 50: seconds - 10):
							seconds;
			end
		end
		
	end
		
endmodule
