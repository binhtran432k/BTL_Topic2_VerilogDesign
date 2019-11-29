module HourCounter(hours, ClkDay, ClkHour, clk, KeyPlus, KeyMinus, reset, Mode24t12, EditPos, EditMode, screen);
	output reg[4:0] hours;
	output ClkDay;
	input [2:0] EditPos;
	input EditMode, clk, ClkHour, KeyPlus, KeyMinus, reset, Mode24t12;
	input [1:0] screen;
	
	reg [3:0] mode;
	
	assign ClkDay = EditMode == 1? ClkDay:  hours == 23? 1: 0;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			hours <= 0;
			mode <= 0;
		end
		else if(ClkHour) begin
			if(EditMode == 0) mode <= 12;
			else mode <= 0;
		end
		else if(~KeyPlus) begin
			if (Mode24t12 == 0 && hours < 20 && EditPos == 1 && screen == 0 && EditMode == 1) mode <= 1;
			else if (Mode24t12 == 0 && hours >= 20 && EditPos == 1 && screen == 0 && EditMode == 1) mode <= 3;
			else if (Mode24t12 == 0 && EditPos == 0 && screen == 0 && EditMode == 1) mode <= 5;
			else if (Mode24t12 == 1 && EditPos == 7 && screen == 0 && EditMode == 1) mode <= 7;
			else if (Mode24t12 == 1 && hours < 12 && EditPos == 0 && screen == 0 && EditMode == 1) mode <= 8;
			else if (Mode24t12 == 1 && hours >= 12 && EditPos == 0 && screen == 0 && EditMode == 1) mode <= 10;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (Mode24t12 == 0 && hours < 20 && EditPos == 1 && screen == 0 && EditMode == 1) mode <= 2;
			else if (Mode24t12 == 0 && hours >= 20 && EditPos == 1 && screen == 0 && EditMode == 1) mode <= 4;
			else if (Mode24t12 == 0 && EditPos == 0 && screen == 0 && EditMode == 1) mode <= 6;
			else if (Mode24t12 == 1 && EditPos == 7 && screen == 0 && EditMode == 1) mode <= 7;
			else if (Mode24t12 == 1 && hours < 12 && EditPos == 0 && screen == 0 && EditMode == 1) mode <= 9;
			else if (Mode24t12 == 1 && hours >= 12 && EditPos == 0 && screen == 0 && EditMode == 1) mode <= 11;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			hours <= mode == 12? (hours > 23? 23: hours == 23? 0: hours + 1):
						mode == 1? (hours % 10 == 9? hours - 9: hours + 1):
						mode == 2? (hours % 10 == 0? hours + 9: hours - 1):
						mode == 3? (hours % 10 == 3? hours - 3: hours + 1):
						mode == 4? (hours % 10 == 0? hours + 3: hours - 1):
						mode == 5? (hours >= 20? hours - 20: hours + 10):
						mode == 6? (hours < 10? hours + 20: hours - 10):
						mode == 7? (hours < 12? hours + 12: hours - 12):
						mode == 8? (hours == 11? hours - 11: hours + 1):
						mode == 9? (hours == 0? hours + 11: hours - 1):
						mode == 10? (hours == 23? hours - 11: hours + 1):
						mode == 11? (hours == 12? hours + 11: hours - 1):
						(hours > 23 && EditMode == 0)? 23: hours;
		end
		
	end
	
endmodule
