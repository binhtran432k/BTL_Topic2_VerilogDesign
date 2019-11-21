module MinuteCounter(minutes, ClkHour, ClkMinute, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[5:0] minutes;
	output ClkHour;
	input [2:0] EditPos;
	input EditMode, clk, ClkMinute, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	reg [2:0] mode;
	
	assign ClkHour = EditMode == 1? ClkHour: minutes == 59? 1: 0;
	
	always @(posedge clk, posedge ClkMinute, negedge KeyPlus, negedge KeyMinus, negedge reset) begin
		if(~reset) begin
			minutes <= 0;
			mode <= 0;
		end
		else if(ClkMinute) begin
			if(EditMode == 0) mode <= 5;
			else mode <= 0;
		end
		else if(~KeyPlus) begin
			if (EditPos == 3 && screen == 0 && EditMode == 1) mode <= 1;
			else if (EditPos == 2 && screen == 0 && EditMode == 1) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (EditPos == 3 && screen == 0 && EditMode == 1) mode <= 2;
			else if (EditPos == 2 && screen == 0 && EditMode == 1) mode <= 4;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			minutes <= mode == 5? (minutes == 59? 0: minutes + 1):
						mode == 1? (minutes % 10 == 9? minutes - 9: minutes + 1):
						mode == 2? (minutes % 10 == 0? minutes + 9: minutes - 1):
						mode == 3? (minutes >= 50? minutes - 50: minutes + 10):
						mode == 4? (minutes < 10? minutes + 50: minutes - 10):
						minutes;
		end
	end
	
endmodule
