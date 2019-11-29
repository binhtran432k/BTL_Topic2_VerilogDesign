module MonthCounter(months, ClkYear, ClkMonth, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[5:0] months;
	output ClkYear;
	input [2:0] EditPos;
	input EditMode, clk, ClkMonth, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	reg [2:0] mode;
	
	assign ClkYear = EditMode == 1? ClkMonth: months == 19? 1: 0;
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			months <= 11;
			mode <= 0;
		end
		else if(ClkMonth) begin
			if(EditMode == 0) mode <= 5;
			else mode <= 0;
		end
		else if(~KeyPlus) begin
			if (EditPos == 3 && screen == 1 && EditMode == 1) mode <= 1;
			else if (EditPos == 2 && screen == 1 && EditMode == 1) mode <= 3;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (EditPos == 3 && screen == 1 && EditMode == 1) mode <= 2;
			else if (EditPos == 2 && screen == 1 && EditMode == 1) mode <= 4;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			months <= mode == 5? (months == 19? 0: months + 1):
						mode == 1? (months % 10 == 9? months - 9: months + 1):
						mode == 2? (months % 10 == 0? months + 9: months - 1):
						mode == 3? (months >= 10? months - 10: months + 10):
						mode == 4? (months < 10? months + 10: months - 10):
						months;
		end
	end
	
endmodule
