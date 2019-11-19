module MinuteCounter(minutes, clkHour, Clk, KEY, editCur, editMode, disMode);
	output reg[5:0] minutes = 59;
	output clkHour;
	input [3:0] KEY;
	input [2:0] editCur;
	input editMode, Clk;
	input [1:0] disMode;
	
	/*reg clkFake;
	initial begin
		minutes <= 59;
		clkFake <= 0;
	end*/
	
	assign clkHour = minutes == 59? 1: 0;
	
	always @(negedge Clk, negedge KEY[2], negedge KEY[1]/*, negedge KEY[0]*/) begin
		if(KEY[1] == 0) begin
			if (editCur == 3 && disMode == 0 && editMode == 1) begin
				minutes <= minutes % 10 == 9? minutes - 9: minutes + 1;
			end
			else if (editCur == 2 && disMode == 0 && editMode == 1) begin
				minutes <= ((minutes - (minutes % 10)) / 10) % 10 == 5? minutes - 50: minutes + 10;
			end
		end
		else if(KEY[2] == 0) begin
			if (editCur == 3 && disMode == 0 && editMode == 1) begin
				minutes <= minutes % 10 == 0? minutes + 9: minutes - 1;
			end
			else if (editCur == 2 && disMode == 0 && editMode == 1) begin
				minutes <= ((minutes - (minutes % 10)) / 10) % 10 == 0? minutes + 50: minutes - 10;
			end
		end
		/*else if(KEY[0] == 0) begin
			if(disMode == 0 && editMode == 1) begin
				minutes <= Clk == 0? (minutes == 0? 59: minutes - 1): minutes;
			end
		end*/
		else if(Clk == 0) begin
			if(editMode == 0) begin
				minutes <= minutes == 59? 0: minutes + 1;
			end
		end
	end
	
endmodule
