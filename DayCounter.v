module DayCounter(days, ClkMonth, ClkDay, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[5:0] days;
	output ClkMonth;
	input [2:0] EditPos;
	input EditMode, clk, ClkDay, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	reg [2:0] mode;
	
	assign ClkMonth = EditMode == 1? ClkDay: days == 29? 1: 0;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			days <= 25;
			mode <= 0;
		end
		else if(ClkDay) begin
			if(EditMode == 0) mode <= 5;
			else mode <= 0;
		end
		else if(~KeyPlus) begin
			if (EditPos == 1 && screen == 1 && EditMode == 1) mode <= 1;
			else if (EditPos == 0 && screen == 1 && EditMode == 1) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (EditPos == 1 && screen == 1 && EditMode == 1) mode <= 2;
			else if (EditPos == 0 && screen == 1 && EditMode == 1) mode <= 4;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			days <= mode == 5? (days == 29? 0: days + 1):
						mode == 1? (days % 10 == 9? days - 9: days + 1):
						mode == 2? (days % 10 == 0? days + 9: days - 1):
						mode == 3? (days >= 20? days - 20: days + 10):
						mode == 4? (days < 10? days + 20: days - 10):
						days;
		end
	end
	
endmodule
