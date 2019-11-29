module YearCounter(years, ClkLeap, ClkYear, clk, KeyPlus, KeyMinus, reset, EditPos, EditMode, screen);
	output reg[14:0] years;
	output ClkLeap;
	input [2:0] EditPos;
	input EditMode, clk, ClkYear, KeyPlus, KeyMinus, reset;
	input [1:0] screen;
	
	reg [3:0] mode;
	
	assign ClkLeap = ((years % 4 == 0 && years % 100 != 0) || years % 400 == 0)? 1: 0; // Detech Leap Year
	
	always @(posedge clk, negedge reset) begin
		if(~reset) begin
			years <= 2019;
			mode <= 0;
		end
		else if(ClkYear) begin
			if(EditMode == 0) mode <= 9;
			else mode <= 0;
		end
		else if(~KeyPlus) begin
			if (EditPos == 7 && screen == 1 && EditMode == 1) mode <= 1;
			else if (EditPos == 6 && screen == 1 && EditMode == 1) mode <= 3;
			else if (EditPos == 5 && screen == 1 && EditMode == 1) mode <= 5;
			else if (EditPos == 4 && screen == 1 && EditMode == 1) mode <= 7;
			else mode <= 0;
		end
		else if(~KeyMinus) begin
			if (EditPos == 7 && screen == 1 && EditMode == 1) mode <= 2;
			else if (EditPos == 6 && screen == 1 && EditMode == 1) mode <= 4;
			else if (EditPos == 5 && screen == 1 && EditMode == 1) mode <= 6;
			else if (EditPos == 4 && screen == 1 && EditMode == 1) mode <= 8;
			else mode <= 0;
		end
		else begin
			mode <= 0;
			years <= mode == 9? (years == 9999? 0: years + 1):
						mode == 1? (years % 10 == 9? years - 9: years + 1):
						mode == 2? (years % 10 == 0? years + 9: years - 1):
						mode == 3? ((years / 10) % 10 == 9? years - 90: years + 10):
						mode == 4? ((years / 10) % 10 == 0? years + 90: years - 10):
						mode == 5? ((years / 100) % 10 == 9? years - 900: years + 100):
						mode == 6? ((years / 100) % 10 == 0? years + 900: years - 100):
						mode == 7? ((years / 1000) % 10 == 9? years - 9000: years + 1000):
						mode == 8? ((years / 1000) % 10 == 0? years + 9000: years - 1000):
						years;
		end
	end
	
endmodule
